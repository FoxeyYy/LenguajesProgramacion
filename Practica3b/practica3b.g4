grammar practica3b;

prog	:	(interfaz|prototipo)*
	;

prototipo:	tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	tipo? ID parametros '{' cuerpo '}' {System.out.println("Funcion " + $ID.text);}
	;

cuerpo	:	llamada*
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

ID	:	LET(LET|DIG)*;
LET	:	[a-zA-Z];
DIG	:	[0-9];
WS	:	[ \t\n]+ -> skip;
COMENTARIO:	'/*' .*? '*/' -> skip;
COMENTARIO_LINEA:	'//' ~[\r\n]* -> skip;
PRE_COMP:	'#' [\t]* ~[\r\n]* -> skip;
