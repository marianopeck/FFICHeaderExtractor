generating C program
writeConstantsArrayOn: stream
	stream nextPutAll: '#define SIZE ', self sharedPool classVarNames size asString, ' 

struct preconstant {
    int value;
    char* name;
	 int defined;
};

struct preconstant constants[SIZE];

void initializeConstantsArray(){
    int i;
    for (i=0; i < SIZE; i++) {
        constants[i].value = 0;
        constants[i].name = "";
        constants[i].defined = 0;
    }
}
'