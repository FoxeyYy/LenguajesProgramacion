#include <stdio.h>
#include <stdlib.h>

#define ERROR -1
#define SUCESS 0


int index;
char lookahead;
char *string;
void match(char c);
void type();
void simple();
void nextToken();

int main(int argc, char **argv){
	string = argv[1];
	index = 0;
	lookahead = string[index];
	type();
	if(lookahead =='\n')
		exit(SUCESS);
	else 
		exit(ERROR);

}


void type(){
	if(lookahead == 'a'){
		printf("Matching array...\n");
		match('a');
		match('[');
		simple();
		match(']');
		match('o');
		type();
	}else if(lookahead == '^'){
		printf("Matching ^...\n");
		match('^');
		simple();
	}else if(lookahead =='i'|lookahead=='c'| lookahead == 'n'){
		printf("Matching simple..\n");
		simple();
	}
}

void simple(){
	if(lookahead == 'i'){
		printf("Matching integer..\n");
		match('i');
	}else if(lookahead =='c'){
		printf("Matching char...\n");
		match('c');
	}else if(lookahead =='n'){
		printf("Matching num ptpt num...\n");
		match('n');
		match('.');
		match('.');
		match('n');
	}else
		printf("ERROR, simple not found\n");
}


void match(char c){
	if(lookahead==c){
		nextToken();
	}else{
		printf("ERROR\n");
		exit(ERROR);
	}
} 

void nextToken(){
	index++;
	lookahead = string[index];

}
