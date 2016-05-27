grammar practica3b;


@header{
import java.util.*;
}


@parser::members{
	LinkedList queue = new LinkedList();

	ArrayList<String> local = new ArrayList();	
	ArrayList<String> global = new ArrayList();	

	void print(){
		while(!queue.isEmpty()){
			System.out.println(queue.poll());
		}
	}
	
	String check(String var){
		if(local.contains(var))
			return "Local" + var;
		else if(global.contains(var)){ 
			return "Global " + var;
		}return var;
	}
}

prog	:	(interfaz|prototipo|declaracionVarGlobal)*  {print();}
	;

prototipo:	modificador* tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	modificador* tipo? ID parametros cuerpo {System.out.println("Funcion " + $ID.text );print();}
	;

cuerpo	:	'{' cuerpo* '}'
	|	(sentencia|control|bucle)
	;

	
declaracionVarGlobal : declaracionVariable 		{System.out.println("Global " + $declaracionVariable.text);global.add($declaracionVariable.text);}
	;

declaracionVarLocal : declaracionVariable 		{local.add($declaracionVariable.text);queue.add("	Local " + $declaracionVariable.text);}
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

expresion:	(literal|llamada|variable|inicializacionArray|operacion) expresion?
	|	expresion array
	|	'(' expresion ')'
	|	cast expresion
	|	expresion operacion expresion
	;

inicializacionArray: '{' expresion(',' expresion)* '}'
	;

sentencia:	declaracionVarLocal
	|	expresion ';'
	|	';'
	;

llamada	locals[String ambito]:	ID parametros	{$ambito = check($parametros.text);queue.add("	Llamada "+ $ID.text +" parametros "+ $ambito);}
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? expresion 
	;

operacion:	operacionSimple+|asignacion
	;

operacionSimple	:  '>' | '<' | '*' | '/' | '%' | '+' | '-' | '!' | '|' | '&' | '.'
	;

cast	:	'(' tipo ')'
	;

tipo	:	ID+ '*'*
	;

variable:	'*'* ID array*
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

WS	:	[ \t\n]+ -> skip;
SALTO	:	('goto'|'continue'|'break'|'return') ~[\r\n;]* ';'-> skip;
COMENTARIO:	'/*' .*? '*/' -> skip;
COMENTARIO_LINEA:	'//' ~[\r\n]* -> skip;
PRE_COMP:	'#' [\t]* ~[\r\n]* -> skip;
