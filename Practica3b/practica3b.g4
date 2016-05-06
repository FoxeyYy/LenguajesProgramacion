grammar practica3b;

prog	:	interfaz+;

interfaz:	FUNCION '{' llamada '}' {
	;

llamada :	FUNCION llamada
	|
	;

LET	:	[a-zA-Z]
DIG	:	[0-9]
DIGS	:	{DIG}+
ID	:	{LET}({LET}|{DIG})*
FUNCION :	{ID}'('.')'
WS	:	[ \t]+ -> skip;
