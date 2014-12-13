%{
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
%}

IDENT 		[a-zA-Z_]+[0-9a-zA-Z_]*
NUMBER     	[1-9][0-9]*
TYPE		"int" | "stencil"
STARTER		"int main"


%%

{STARTER}		{ return STARTER;}
[=]          	{ return ASSIGN; }
"if"         	{ return IF; }
"else"       	{ return ELSE; }
"while"      	{ return WHILE; }
"for"			{ return FOR;	}
"int"			{ return INT;}
"stencil"		{ return STENCIL;}
{IDENT}			{ yylval.string = strdup(yytext); return ID; }
{NUMBER}     	{ yylval.value = atoi(yytext); return CSTE; }  // on retourne la valeur pour quelle soit traiter dans le yacc
\n           	{ return yytext[0]; }
[\t ]        	{	}
.            	{ printf("[Lex] Unknown character: %s\n", yytext); }

%%

// Free the memory allocated for Lex when we are done.
	void lex_free() {
  	yy_delete_buffer(YY_CURRENT_BUFFER);
  	free(yy_buffer_stack);
}
