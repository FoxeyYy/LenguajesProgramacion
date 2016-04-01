%{
#include <stdio.h>
#include "StringMap.h"
%}

let	[a-zA-Z]
dig	[0-9]
digs	{dig}+
frac	[.]{digs}
expo	[eE][+-]?{digs}
id	{let}({let}|{dig})*
float	{digs}{frac}?{expo}?
reserved {auto|if|break|int}
comment_beg	"/*"
comment_end	"*/"
new_line	"\n"

	map *reserved = createMap();

	map *variables = createMap();

%x COMMENT STRING

%%

[ \t]+	;

{comment_beg} {BEGIN COMMENT;}
<COMMENT>comment_end	{BEGIN INITIAL;}
<COMMENT>.	{}

id	{
	int value = getValue(variables, yytext);
	value++;
	removeElement(variables, yytext);
	addElement(variables, yytext, value);
	}

reserved	{
	int value = getValue(reserved, yytext);
	value++;
	removeElement(reserved, yytext);
	addElement(reserved, yytext, value);
	}

{new_line}	{}
.		{}

%%

int main(int argc, char **argv){
	yylex();
	printf("if %d\n", getValue(reserved, "if"));
	printf("hola %d\n", getValue(reserved, "hola"));
}
