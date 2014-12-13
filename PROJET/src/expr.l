%{
  #include <stdlib.h>
  #include <string.h>
  #include "include/quad.h" 
  #include "y.tab.h"
  # define YY_NO_INPUT
  extern YYSTYPE yylval ;
%}

%option nounput
%option noyywrap

identifier [a-zA-Z_]+[0-9a-zA-Z_]*
number     [1-9][0-9]*

%%

[=]          { return ASSIGN; }
"if"         { return IF; }
"while"      { return WHILE; }
"done"       { return DONE; }
"do"         { return DO; }
"then"       { return THEN; }
"else"       { return ELSE; }
"endif"      { return ENDIF; }
"true"       { return TRUE; }
"false"      { return FALSE; }
{identifier} { yylval.string = strdup(yytext); return ID; }
{number}     { yylval.value = atoi(yytext); return NUM; }
"=="         { return EQUAL; }
"&&"         { return AND; }
"||"         { return OR; }
"!"          { return NOT; }
[()]         { return yytext[0]; }
\n           { return yytext[0]; }
[\t ]        { }
.            { printf("[Lex] Unknown character: %s\n", yytext); }

%%

// Free the memory allocated for Lex when we are done.
void lex_free() {
  yy_delete_buffer(YY_CURRENT_BUFFER);
  free(yy_buffer_stack);
}
