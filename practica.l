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
reserved auto|if|break|int|case|long|char|register|continue|return|default|short|do|sizeof|double|static|else|struct|entry|switch|extern|typedef|float|union|for|unsigned|goto|while|enum|void|const|signed|volatile
comment_beg	"/*"
comment_end	"*/"
comment_line	"//"
new_line	"\n"
quote_beg	["]
quote_end	[^\\]["]
hash		"#"

	map *reserved;

	map *variables;

%x COMMENT STRING HEADERS IN_COMMENT 

%%

[ \t]+]	;

{comment_line}	{BEGIN IN_COMMENT;}
<IN_COMMENT>{new_line}	{BEGIN INITIAL;}
<IN_COMMENT>.	;


{comment_beg} {BEGIN COMMENT;}
<COMMENT>{comment_end}	{BEGIN INITIAL;}
<COMMENT>.	;

{quote_beg}		{BEGIN STRING;}
<STRING>{quote_end} {BEGIN INITIAL;}
<STRING>.	;

{hash} {BEGIN HEADERS;}
<HEADERS>{new_line}	{BEGIN INITIAL;}
<HEADERS>.	;


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


{new_line}	;	
.		;		

%%

int main(int argc, char **argv){
	if(argc!=2){
		printf("No ha introducido correctamente el nombre del fichero c para analizar\n");
		exit(1);
	}
	
	if(strstr(argv[1],".c")==NULL){
		printf("No ha introducido un fichero .c\n");
		exit(-1);
	}
	
	FILE *salidaReserved = fopen("palabras_reservadas.txt","w+");
	FILE *salidaVariables = fopen("identificadores.txt","w+");

	reserved = createMap();
	variables = createMap();
	
	yyin = fopen (argv[1], "r");
	
	yylex();
	
	iterator *iterator = createIterator(reserved);
	node *node = NULL;
	while(hasNext(iterator) == TRUE){
		node = getNext(iterator);
		fprintf(salidaReserved,"%s %d\n", node->key, node->value);
	}
	fclose(salidaReserved);
	free(iterator);
	node = NULL;
	iterator = createIterator(variables);
	while(hasNext(iterator) == TRUE){
		node = getNext(iterator);
		fprintf(salidaVariables,"%s %d\n", node->key, node->value);
	}
	fclose(salidaVariables);
}
