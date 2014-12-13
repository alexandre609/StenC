%{
  # define _GNU_SOURCE
  #include <stdio.h>
  #include <stdlib.h>
  #include "symbol.h" 

  void yyerror(char*);
  int yylex();
  void lex_free();


  
%}
%token STARTER ASSIGN STENCIL INT IF ELSE WHILE FOR ID CSTE



%%

axiom: STARTER '{' STMT_LIST '}'       // INT MAIN. DEBUT DU PROGRAMME
;

STMTLIST:							// STATEMENT LIST
	STMTLIST STMT
	| STMT
  	;

//DECLARATION MULTIPLE
DCLR    
	: ID                               
    //| ID '[' CSTE ']'        
    ;

DCL 
    : INT DCLR          
    | DCL ',' DCL         
    ;

// STENCIL_DCL
// 	: STENCIL ID '{' CSTE ',' CSTE '}' 
// 	;


STMT:								// STATEMENT IN C.  WE WILL HAVE CONFLICT DU TO C NATURE.
    ID ASSIGN EXPR ';'
    | DCL ';'
    //| STENCIL_DCL ';'
    ;
//     | CONTROLFLOW
  	
// CONTROLFLOW:
//   	WHILE COND STMTLIST 
//   	| IF COND STMTLIST
//   	| IF COND STMTLIST ELSE STMTLIST 
//   	;

// GESTION CONFLIT AVANCE SUR LE IF ELSE EN C SANS ENDIF/FI.
// stat      : matched
//           | unmatched
//           ;
// unmatched : IF '(' exp ')' stat
//           | IF '(' exp ')' matched ELSE unmatched
//           | FOR '(' exp ';' exp ';' exp ')' unmatched
//           | WHILE '(' exp ')' unmatched
//           | . . .
//           ;
// matched   : IF '(' exp ')' matched ELSE matched
//           | FOR '(' exp ';' exp ';' exp ')' matched
//           | WHILE '(' exp ')' matched
//           | expr
//           ;




  
// COND								// EXPRESSION CONDITIONNEL
//     EXPR EQUAL EXPR                 // EQUAL EQUAL ==
//   	| EXPR NE EXPR          
//     | EXPR LE EXPR         
//     | EXPR GE EXPR         
//     | EXPR LT EXPR          
//     | EXPR GT EXPR          
//   	| COND OR COND
//     | COND AND COND
//   	| NOT COND
//   	| '(' COND ')'
// 		;

EXPR:
    ID
  	| CSTE
  	;
 
%%





%%

void yyerror (char *s){
	fprintf(stderr, "[Yacc] error: %s\n", s);
}

int main(){
	FILE *fichier = fopen("test.s","w+");
	yyparse();
	lex_free();
	fclose(fichier);
	return 0;
}
