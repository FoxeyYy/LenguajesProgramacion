grammar practica3b;


@header{
import java.util.*;
}


@parser::members{
	LinkedList queue = new LinkedList();

	HashMap<String,String> local = new HashMap();	
	HashMap<String,String> global = new HashMap();	
	HashMap<String,String> extern = new HashMap();	
	
	void print(){
		while(!queue.isEmpty()){
			System.out.println(queue.poll());
		}
	}
	
	String check(String var){
		var = var.replace("&","");
		var = var.replace("*","");
		var = var.substring(1,var.length()-1);
		String[] parametros = var.split(",");
		String variables = "";
		for(String parametro : parametros){
			if(local.containsKey(parametro)){
				variables +="Local " + parametro +" ";
			}else if(global.containsKey(parametro)){ 
				variables +="Global " + parametro + " ";
			}else if(extern.containsKey(parametro)){
				variables +="Externa " + parametro + " "; 
			}else	
				variables += parametro + " ";
		}
		return variables;
	}

	void addLocal(String var, String tipo){
	if(!local.containsKey(var)&&tipo!=null)
		local.put(var,tipo);
	}
	
}

prog	:	(interfaz|prototipo|declaracionVarGlobal|declaracionVarExterna|declaracionTipo)*  {print();}
	;

prototipo:	modificador* tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	modificador* tipo? ID parametros cuerpo {System.out.println("Funcion " + $ID.text );print(); local.clear();}
	;

cuerpo	:	'{' cuerpo* '}'
	|	(sentencia|control|bucle)
	;

	
declaracionVarExterna : 'extern' declaracionVariable	{System.out.println("Variable externa " + $declaracionVariable.var[0] +" "+ $declaracionVariable.var[1]);
							extern.put($declaracionVariable.var[1],$declaracionVariable.var[0]);}	
	;

declaracionVarGlobal : declaracionVariable 		{System.out.println("Variable global " + $declaracionVariable.var[0] +" "+ $declaracionVariable.var[1]);
							global.put($declaracionVariable.var[1],$declaracionVariable.var[0]);}
	;

declaracionVarLocal : declaracionVariable 		{local.put($declaracionVariable.var[1],$declaracionVariable.var[0]);
							queue.add("	Variable local " + $declaracionVariable.var[0]+ " " +$declaracionVariable.var[1]);}
	;

declaracionVariable returns [String[] var] :  tipo variable asignacion? (',' variable asignacion?)* ';' {$var = new String[2];$var[0] = $tipo.text;
															 $var[1] = $variable.var;}
	;

declaracionTipo : modificador* structOrUnion ';'
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

llamada	locals[String ambito]:	ID parametros	{$ambito = check($parametros.text);
						queue.add("	Llama a la función "+ $ID.text +" con los parametros( "+ $ambito +" )");}
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? expresion			{addLocal($expresion.text,$tipo.text);}
	;

operacion:	operacionSimple+|asignacion
	;

operacionSimple	:  '>' | '<' | '*' | '/' | '%' | '+' | '-' | '!' | '|' | '&' | '.'
	;

cast	:	'(' tipo ')'
	;

tipo	:	ID+ '*'*
	;

variable returns[String var]:	('*'*|'&'*) ID array* {$var = $ID.text;}
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
