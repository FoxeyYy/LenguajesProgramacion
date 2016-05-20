grammar practica3b;

prog	:	(interfaz|prototipo|declaracionVariable)*
	;

prototipo:	modificador* tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	modificador* tipo? ID parametros cuerpo {System.out.println("Funcion " + $ID.text + "\n\n\n");}
	;

cuerpo	:	'{' cuerpo* '}'
	|	(sentencia|control|bucle)
	;

declaracionVariable: modificador* tipo variable asignacion? (',' variable asignacion?)* ';'
	|	modificador* structOrUnion ';'
	|	modificador* enumDecl ';'
	;

asignacion:	('=' | '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|=') expresion
	;

modificador: 'typedef'
	|   'extern'
	|   'static'
	|   '_Thread_local'
	|   'auto'
	|   'register'
    ;


structOrUnion:	('struct'|'union') variable? '{' declaracionVariable+ '}' (variable (',' variable)*)?
	|	('struct'|'union') variable variable
	;

enumDecl	:	'enum'	variable '{' ID asignacion? (',' ID asignacion?)* '}'
	|	'enum'	variable ID asignacion?
	;

bucle	:	'while' '(' expresion ')' cuerpo
	|	'do' cuerpo	'while' '(' sentencia ')' ';'
	|	'for' '(' expresion? ';' expresion? ';' expresion? ')' cuerpo
	;

control	:	'if' '(' expresion ')' cuerpo ('else' cuerpo)?
	| 	'switch' '(' expresion ')' '{' ('case' (ID|literal) ':' cuerpo)+ '}'
	;

expresion:	(literal|variable|llamada|inicializacionArray|todo) expresion?
	|	expresion array
	|	'(' expresion ')'
	|	cast expresion
	|	expresion todo expresion
	;

inicializacionArray: '{' expresion(',' expresion)* '}'
	;

sentencia:	expresion ';'
	|	declaracionVariable
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

todo	: OPERADOR+|('*'OPERADOR*)+|'=';

cast	:	'(' tipo ')'
	;

tipo	:	ID '*'*
	;

variable:	'*'* ID array*
	|	'(' variable ')'
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
