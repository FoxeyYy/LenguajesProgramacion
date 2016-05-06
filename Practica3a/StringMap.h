#define MAX_CHARGE 1.5
#define INIT_MAX_ELEM 16
#define TRUE 1
#define FALSE 0

#define hash unsigned long

typedef struct node{
	char key[50];
	int value;
	struct node *next;
}node;

typedef struct map{
	unsigned int numElements;
	unsigned int maxElements;
	node **buckets;
}map;

typedef struct iterator{
	unsigned int index;
	node *node;
	map *map;
}iterator;

map* createMap();
iterator* createIterator(const map *m);

node* getNext(iterator *iterator);

void addElement(map *m, const char *key, const int value);
void removeElement(map *m, const char *key);
void refactor(map *m);

int hasNext(const iterator *iterator);
int getValue(const map *m, const char *key);

float getChargeFactor(const map *m);

hash getHash(const unsigned char *str);
