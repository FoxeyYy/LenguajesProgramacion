grammar practica3b;


@header{
import java.util.*;
}


@parser::members{
	LinkedList queue = new LinkedList();

	HashMap<String,String> local = new HashMap();	
	HashMap<String,String> global = new HashMap();	
	
	ArrayList<String> programLocal = new ArrayList();
	ArrayList<String> programGlobal = new ArrayList();
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

prog	:	(interfaz|prototipo|declaracionVarGlobal|declaracionVarExterna)*  {print();}
	;

prototipo:	modificador* tipo? ID '(' listaParametros ')' ';'
	;

interfaz:	modificador* tipo? ID parametros cuerpo {System.out.println("Funcion " + $ID.text );print(); local.clear();}
	;

cuerpo	:	'{' cuerpo* '}'
	|	(sentencia|control|bucle)
	;

	
declaracionVarGlobal : declaracionVariable 		{System.out.println("Global " + $declaracionVariable.var[0] +" "+ $declaracionVariable.var[1]);
							global.put($declaracionVariable.var[1],$declaracionVariable.var[0]);
							programLocal.add($declaracionVariable.var[0] + " " + $declaracionVariable.var[1]);}
	;

declaracionVarLocal : declaracionVariable 		{local.put($declaracionVariable.var[1],$declaracionVariable.var[0]);
							queue.add("	Local " + $declaracionVariable.var[0]+ " " +$declaracionVariable.var[1]);
							programLocal.add($declaracionVariable.var[0] + " " + $declaracionVariable.var[1]);}
	;

declaracionVariable returns [String[] var] : modificador* tipo variable asignacion? (',' variable asignacion?)* ';' {$var = new String[2];$var[0] = $tipo.text;
															 $var[1] = $variable.var;}
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

llamada	locals[String ambito]:	ID parametros	{$ambito = check($parametros.text);
						queue.add("	Llamada "+ $ID.text +" parametros( "+ $ambito +" )");}
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
