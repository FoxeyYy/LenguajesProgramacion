%{
#define INT 257
#define FLOAT 258
#define DOUBLE 259
#define CHAR 260
#define LONG 261
#define UNSIGNED 262
#define CONST 263
#define IF 264
#define ELSE 265
#define SWITCH 266
#define CASE 267
#define BREAK 268
#define CONTINUE 269
#define WHILE 270
#define FOR 271
#define DO 272
#define DEFAULT 273
#define GOTO 274
#define RETURN 275
#define index(n) n - 257
#define NUM_RESERVED 9 - 2
%}
let	[a-zA-Z]
dig	[0-9]
digs	{dig}+
frac	[.]{digs}
expo	[eE][+-]?{digs}
id	{let}({let}|{dig})*
float	{digs}{frac}?{expo}?
comment_beg	"/*"
comment_end	"*/"
new_line	"\n"

	int *reserved =(int*) malloc( sizeof(int) * NUM_RESERVED);

	map *hashmap = createMap();
%x COMMENT STRING

%%

//Blanks
[ \t]+	;

//Comments
{comment_beg} {BEGIN COMMENT;}
<COMMENT>comment_end	{BEGIN INITIAL;}
<COMMENT>.	{}

//IDs
id	{
	int value = getValue(m, yytext);
	removeElement(m, yytext);
	addElement(m, yytext, value+1);
	}

//Reserved
if	{
	index(IF)++;
	return IF;
	}
else	{
	index(ELSE)++;
	return ELSE;
	}
for	{
	index(FOR)++;
	return FOR;
	}

//Rest
{new_line}	{nl++;}
.		{}

%%

main(int argc, int **argv){
	for(int i = 0; i < NUM_RESERVED; i++){
		reserved[i] = 0;
	}
}
