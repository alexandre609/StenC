%{
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
%}



%%

int		{return INTEGER;}
[+,-,/]		{}
"if"		{return IF;}
"else"		{return ELSE;}
"while"		{return WHILE;}


%%

void lex_free(){
	yy_delete_buffer(YY_CURRENT_BUFFER);
	free(yy_buffer_stack);
}
