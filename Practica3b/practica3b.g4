grammar practica3b;

prog	:	interfaz;

interfaz:	FUNCION '{' FUNCION '}'
	;

LET	:	[a-zA-Z];
DIG	:	[0-9];
DIGS	:	DIG+;
ID	:	LET(LET|DIG)*;
FUNCION :	ID'('PARAMETROS)*')';
WS	:	[ \t\n]+ -> skip;
