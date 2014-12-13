/* University of Strasbourg - Master ILC-ISI-RISE
 * Compilation Lab - Intermediate Code Generation
 * Generation of quad code for control expressions
 */
%{
  # define _GNU_SOURCE
  #include <stdio.h>
  #include <stdlib.h>
  #include "include/quad.h" 

  void yyerror(char*);
  int yylex();
  void lex_free();

  Symbol* symbol_table = NULL;
  Quad*    quad_list = NULL;
%}

%union {
  char* string;
  int value;
  Symbol s ;

  struct
  {
	  Quad code ;
	  QuadList next ;
	  int label ;
  } gotoS ;

  struct
  {
	QuadList trueList ;
	QuadList falseList ;
	Quad code ;
  } list ;
  
  struct
  {
	  QuadList next ;
	  Quad code ;
  } loop ;
}

%token ASSIGN WHILE DO DONE IF THEN ELSE ENDIF
%token EQUAL TRUE FALSE OR AND NOT
%token <string> ID
%token <value> NUM

%type <list> condition
%type <s> expression
%type <loop> statement statement_list
%type <value> tag
%type <gotoS> tagGoto

%left EQUAL
%left OR
%left AND
%right NOT

%%

axiom:
  statement_list tag '\n'
    {
      Q_complete (symbol_table , $1.next , $2) ;
      printf("Match !!!\n");
      Q_printQuad ($1.code) ;
      quad_list = $1.next ;
      return 0;
    }

statement_list:
    statement_list tag statement
    {
		Q_complete (symbol_table , $1.next , $2) ;
		$$.next = $3.next ;
		$$.code = Q_add ($1.code , $3.code) ;
	}
  | statement
    {
		$$.next = $1.next ;
		$$.code = $1.code ;
	}
  ;

statement:
    ID ASSIGN expression
    {
		$$.next = NULL ;
		$$.code = Q_new ('a' , S_lookupSymbol (symbol_table , $1) , $3 , NULL) ; // Affectation, pas de resultat pour le moment.
	}
  | WHILE tag condition DO tag statement_list tagGoto DONE
    {
		Q_complete (symbol_table , $3.trueList , $5) ;
		Q_complete (symbol_table , $7.next     , $2) ;
		$$.next = Q_concat ($3.falseList , $6.next) ;
		$$.code = Q_add ($3.code , $6.code) ;
		$$.code = Q_add ($$.code , $7.code) ;
	}
  | IF condition THEN tag statement_list ENDIF
    {
		Q_complete (symbol_table , $2.trueList , $4) ;
		$$.next = Q_concat ($2.falseList , $5.next) ;
		$$.code = Q_add ($2.code , $5.code) ;
	}
  | IF condition THEN tag statement_list tagGoto ELSE statement_list ENDIF
    {
		Q_complete (symbol_table , $2.trueList  , $4) ;
		Q_complete (symbol_table , $2.falseList , $6.label) ;
		$$.next = Q_concat ($6.next , $8.next) ;
		$$.code = Q_add ($2.code , $5.code) ;
		$$.code = Q_add ($$.code , $6.code) ;
		$$.code = Q_add ($$.code , $8.code) ;
	}
  ;
  
condition:
    expression EQUAL expression
    {
		Quad true    = Q_new ('e' , $1 , $3 , NULL) ; // Egalite.
		Quad false   = Q_new ('g' , NULL , NULL , NULL) ; // Goto.
		$$.trueList  = Q_newList (true) ;
		$$.falseList = Q_newList (false) ;
		$$.code      = Q_add ($$.code , true) ;
		$$.code      = Q_add ($$.code , false) ;
	}
  | TRUE
    {
		$$.falseList = NULL ;
		$$.code      = Q_new ('g' , NULL , NULL , NULL) ; // Nouveau quad goto.
		$$.trueList  = Q_newList ($$.code) ;
	}
  | FALSE
    {
		$$.trueList  = NULL ;
		$$.code      = Q_new ('g' , NULL , NULL , NULL) ; // Nouveau quad goto.
		$$.falseList = Q_newList ($$.code) ;
	}
  | condition OR tag condition
    {
		Q_complete (symbol_table , $1.falseList , $3) ;
		$$.trueList  = Q_concat ($1.trueList , $4.trueList) ; // Concatener les trueList.
		$$.falseList = $4.falseList ;
		$$.code      = Q_add ($1.code , $4.code) ;
	}
  | condition AND tag condition
    {
		Q_complete (symbol_table , $1.trueList , $3) ;
		$$.trueList  = $4.trueList ;
		$$.falseList = Q_concat ($1.falseList , $4.falseList) ; // Concatener les falseList.
		$$.code      = Q_add ($1.code , $4.code) ;
	}
  | NOT condition
	{
		$$.trueList  = $2.falseList ; // Le false devient true.
		$$.falseList = $2.trueList ; // Le true devient false.
	}
  | '(' condition ')'
	{
		$$ = $2 ;
	}
  ;

expression:
    ID
    {
		$$ = S_lookupSymbol (symbol_table , $1) ; // Chercher le symbole d'identifiant donne dans la table des symboles.
	}
  | NUM
    {
		char * id ;
		asprintf (& id , "temporarySymbol_%d" , idTemporary) ; // Creer le nom d'un symbole temporaire.
		idTemporary ++ ; // Un symbole temporaire de plus est cree.
		$$ = S_newSymbol (symbol_table , $1 , id , 'g') ;
	}
  ;
  
tag :
	{
		$$ = nextQuad ;
	}
	
tagGoto :
	{
		$$.code = Q_new ('g' , NULL , NULL , NULL) ; // Quad goto.
		$$.next = Q_newList ($$.code) ;
		$$.label = nextQuad ;
	}

%%

void yyerror (char *s) {
    fprintf(stderr, "[Yacc] error: %s\n", s);
}

int main() {
  printf("Enter your code:\n");
  symbol_table = S_new () ;
  yyparse();
  printf("-----------------\nSymbol table:\n");
  S_print(symbol_table);
  printf("-----------------\nQuad list:\n");
  Q_printList(quad_list);

  // Be clean.
  lex_free();
  Q_delete(quad_list);
  S_delete(symbol_table);
  return 0;
}
