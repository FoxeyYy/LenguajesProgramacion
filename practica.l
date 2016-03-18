%{
#define FOR 257
#define WHILE 258
#define SWITCH 259
#define IF 260
#define ELSE 261
#define DO 262
#define BREAK 263
#define CONTINUE 264
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

	int *reserved =(int*) malloc( sizeof(int) * NUM_RESERVED); //TODO inicializar
	int yylval = 0,
		nl = 1;
%x COMMENT STRING

%%

//Blanks
[ \t]+	; //TODO esta bien?

//Comments
{comment_beg} {BEGIN COMMENT;}
<COMMENT>comment_end	{BEGIN INITIAL;}
<COMMENT>.	{}

//Reserved
if	{yylval = nl;
	index(IF)++;
	return IF;}
else	{yylval = nl;
	index(ELSE)++;
	return ELSE;}
for	{yylval = nl;
	index(FOR)++;
	return FOR;}

//Rest
{new_line}	{nl++;}
.		{}

%%

main(int argc, int **argv){
}
