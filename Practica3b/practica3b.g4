grammar practica3b;

prog	:	interfaz*;

interfaz:	tipo ID parametros '{' llamadas* '}'
	;

llamadas:	ID parametros
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? ID
	;

tipo	:	ID
	;

LET	:	[a-zA-Z];
DIG	:	[0-9];
DIGS	:	DIG+;
ID	:	LET(LET|DIG)*;
WS	:	[ \t\n]+ -> skip;
