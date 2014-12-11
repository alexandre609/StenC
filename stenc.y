%{
	#include <stdio.h>
	#include <stdlib.h>

	void yyerror(char*);
	int yylex();
	void lex_free();

	
%}

%token INTEGER IF ELSE WHILE

%union {
	char* string;
	int value;
}

%%

axiom: CONDITION
	;

CONDITION: IF
	| IF ELSE
	;
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
