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
reserved auto|if|break|int
comment_beg	"/*"
comment_end	"*/"
new_line	"\n"

	map *reserved;

	map *variables;

%x COMMENT STRING

%%

[ \t]+	;

{comment_beg} {BEGIN COMMENT;}
<COMMENT>comment_end	{BEGIN INITIAL;}
<COMMENT>.	{}

{reserved}	{
	int value = getValue(reserved, yytext);
	value++;
	removeElement(reserved, yytext);
	addElement(reserved, yytext, value);
	}

{id}	{
	int value = getValue(variables, yytext);
	value++;
	removeElement(variables, yytext);
	addElement(variables, yytext, value);
	}


{new_line}	{}
.		{}

%%

int main(int argc, char **argv){
	reserved = createMap();
	variables = createMap();
	yylex();
	iterator *iterator = createIterator(reserved);
	node *node = NULL;
	while(hasNext(iterator) == TRUE){
		node = getNext(iterator);
		printf("%s %d\n", node->key, node->value);
	}

	free(iterator);
	node = NULL;
	iterator = createIterator(variables);
	while(hasNext(iterator) == TRUE){
		node = getNext(iterator);
		printf("%s %d\n", node->key, node->value);
	}
}
