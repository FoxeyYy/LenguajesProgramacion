#define MAX_CHARGE 1.5
#define INIT_MAX_ELEM 16

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

map* createMap();

void addElement(map *m, const char *key, const int value);
void removeElement(map *m, const char *key);
void refactor(map *m);

int getValue(const map *m, const char *key);

float getChargeFactor(const map *m);

hash getHash(const unsigned char *str);
