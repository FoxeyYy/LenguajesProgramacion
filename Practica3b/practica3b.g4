grammar practica3b;

prog	:	(interfaz|prototipo)*
	;

<<<<<<< Updated upstream
prototipo:	tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	tipo? ID parametros '{' cuerpo '}' {System.out.println("Funcion " + $ID.text + "\n\n\n");}
	;

cuerpo	:	sentencia*
	;

sentencia:	';'
	|	variable sentencia
	|	OPERADOR sentencia
	|	llamada sentencia
=======
interfaz:	tipo ID parametros '{' cuerpo '}' {System.out.println("Funcion " + $ID.text);}
	;

cuerpo	:	(llamada|otro)*
	;

otro	:	OTRO
>>>>>>> Stashed changes
	;

llamada	:	ID parametros	{System.out.println("\t llamada " + $ID.text);}
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? variable
	| llamada
	;

tipo	:	ID'*'*
	;

variable:	ID array*
	;

array	:	'[' ']'
	;
<<<<<<< Updated upstream

ID	:	LET(LET|DIG)*;
=======
OTRO	:	[^ID];
>>>>>>> Stashed changes
LET	:	[a-zA-Z];
DIG	:	[0-9];
OPERADOR:	[-+=*/!|&];
WS	:	[ \t\n]+ -> skip;
COMENTARIO:	'/*' .*? '*/' -> skip;
COMENTARIO_LINEA:	'//' ~[\r\n]* -> skip;
PRE_COMP:	'#' [\t]* ~[\r\n]* -> skip;
