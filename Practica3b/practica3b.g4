grammar practica3b;


@header{
import java.util.*;
import java.io.*;
}


@parser::members{

	LinkedList colaLocal = new LinkedList();
	LinkedList colaPrograma = new LinkedList();

	HashMap<String,String> varLocales = new HashMap();	
	HashMap<String,String> varGlobales = new HashMap();	
	HashMap<String,String> varExternas = new HashMap();	
	
	
	String ambito(String var){
		var = var.replace("&","");
		var = var.replace("*","");
		var = var.substring(1,var.length()-1);
		String[] parametros = var.split(",");
		String variables = "";
		for(String parametro : parametros){
			if(varLocales.containsKey(parametro)){
				variables +="Local " + parametro +" ";
			}else if(varGlobales.containsKey(parametro)){ 
				variables +="Global " + parametro + " ";
			}else if(varExternas.containsKey(parametro)){
				variables +="Externa " + parametro + " "; 
			}else	
				variables += parametro + " ";
		}
		return variables;
	}

	void comprobar(String var, String tipo){
	if(!varLocales.containsKey(var)&&tipo!=null) 
		varLocales.put(var,tipo);
	}

	void localAGlobal(){
		while(!colaLocal.isEmpty())
			colaPrograma.add(colaLocal.remove());
	}
	
	void guardar(){
		try{
			File fichero = new File("Resultados.txt");
			PrintWriter out = new PrintWriter(new FileWriter(fichero,false));
			while(!colaPrograma.isEmpty())
				out.print(String.valueOf(colaPrograma.remove()));
			out.close();
		}catch(IOException e){
			System.out.println("Error");
		}
	}
}

prog	:	(interfaz|prototipo|declaracionVarGlobal|declaracionVarExterna|declaracionTipo)* 	{guardar();} 
	;

prototipo:	modificador* tipo? ID parametros ';'
	;

interfaz:	modificador* tipo? ID parametros cuerpo {colaLocal.addFirst("Funcion " + $ID.text + "\n"); localAGlobal(); varLocales.clear();}
	;

cuerpo	:	'{' cuerpo* '}'
	|	(sentencia|control|bucle)
	;

	
declaracionVarExterna : 'extern' declaracionVariable	{colaPrograma.addFirst("Variable externa " + $declaracionVariable.var[0] +" "+ $declaracionVariable.var[1] + "\n");
							varExternas.put($declaracionVariable.var[1],$declaracionVariable.var[0]);}	
	;

declaracionVarGlobal : declaracionVariable 		{colaPrograma.addFirst("Variable global " + $declaracionVariable.var[0] +" "+ $declaracionVariable.var[1] + "\n");
							varGlobales.put($declaracionVariable.var[1],$declaracionVariable.var[0]);}
	;

declaracionVarLocal : declaracionVariable 		{colaLocal.add("	Variable local " + $declaracionVariable.var[0]+ " " +$declaracionVariable.var[1] + "\n");
							varLocales.put($declaracionVariable.var[1],$declaracionVariable.var[0]);}
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

llamada	locals[String ambito]:	ID parametros	{$ambito = ambito($parametros.text);
						colaLocal.add("	Llama a la función "+ $ID.text +" con los parametros( "+ $ambito +" )" + "\n");}
	;

parametros:	'(' listaParametros? ')'
	;

listaParametros:	parametro (',' parametro)*
	;

parametro:	tipo? expresion			{comprobar($expresion.text,$tipo.text);}
	;

operacion:	operacionSimple+|asignacion
	;

operacionSimple	:  '>' | '<' | '*' | '/' | '%' | '+' | '-' | '!' | '|' | '&' | '.'
	;

cast	:	'(' tipo ')'
	;

tipo	:	ID+ ('&'|'*')*
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
