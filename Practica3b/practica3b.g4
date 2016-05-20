grammar practica3b;

prog	:	(interfaz|prototipo|declaracionVariable)*
	;

prototipo:	tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	tipo? ID parametros cuerpo {System.out.println("Funcion " + $ID.text + "\n\n\n");}
	;

cuerpo	:	'{' cuerpo* '}'
	|	(sentencia|control|bucle)
	;

declaracionVariable: tipo variable expresion? (',' variable expresion?)* ';'?
	| 	typedef ';'?
	|	structOrUnion ';'?
	;

typedef:	 'typedef' declaracionVariable variable
	;

structOrUnion:	('struct'|'union') variable? '{' declaracionVariable+ '}' variable?
	;

bucle	:	'while' '(' expresion ')' cuerpo
	|	'do' cuerpo	'while' '(' sentencia ')' ';'
	|	'for' '(' expresion? ';' expresion? ';' expresion? ')' cuerpo
	;

control	:	'if' '(' expresion ')' cuerpo ('else' cuerpo)?
	| 	'switch' '(' expresion ')' '{' ('case' (ID|literal) ':' cuerpo)+ '}'
	;

expresion:	cast? (literal|variable|llamada|inicializacionArray|todo) ('[' expresion ']')? expresion?
	|	'(' expresion ')'
	;

inicializacionArray: '{' expresion(',' expresion)* '}'
	;

sentencia:	expresion ';'
	|	declaracionVariable ';'
	|	';'
	;

llamada	:	ID parametros	{System.out.println("\t llamada " + $ID.text);}
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? expresion
	;

todo	: OPERADOR+|('*'OPERADOR*)+;

cast	:	'(' tipo ')'
	;

tipo	:	ID '*'*
	;

variable:	ID array*
	;

array	:	'[' expresion? ']'
	;

literal:	DIG+
	|	STRING+
	|	CHAR
	;

ID	:	'_'?LET(LET|DIG|'_')*;
LET	:	[a-zA-Z];
DIG	:	[0-9];
STRING	:	'"' ~["\r\n]* '"';
CHAR	:	['] ~['\r\n] ['];
OPERADOR:	[-+/%=\*><!|&.];
WS	:	[ \t\n]+ -> skip;
SALTO	:	('goto'|'continue'|'break'|'return') ~[\r\n;]* ';'-> skip;
COMENTARIO:	'/*' .*? '*/' -> skip;
COMENTARIO_LINEA:	'//' ~[\r\n]* -> skip;
PRE_COMP:	'#' [\t]* ~[\r\n]* -> skip;
