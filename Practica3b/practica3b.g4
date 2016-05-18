grammar practica3b;

prog	:	interfaz*
	;

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

ID	:	LET(LET|DIG)*
	;

LET	:	[a-zA-Z];
DIG	:	[0-9];
WS	:	[ \t\n]+ -> skip;
