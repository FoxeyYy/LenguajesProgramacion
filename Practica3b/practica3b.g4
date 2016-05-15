grammar practica3b;

prog	:	interfaz*;

interfaz:	tipo ID parametros '{' llamada* '}' {System.out.println("Funcion " + $ID.text);}
	;

llamada	:	ID parametros	{System.out.println("\t llamada " + $ID.text);}
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? ID
	| llamada
	;

tipo	:	ID
	;

LET	:	[a-zA-Z];
DIG	:	[0-9];
DIGS	:	DIG+;
ID	:	LET(LET|DIG)*;
WS	:	[ \t\n]+ -> skip;
