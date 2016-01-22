generating C program
writeRestOfCFileOn: stream
	stream cr.
	stream nextPutAll: '/*
 Writes in a pretty-way STON format the constants name, values and sizeof.
 Example:
 
{
        ''SIGKILL'' : [
                9,
                4
        ],
        ''SIGTERM'' : [
                15,
                4
        ]
}
 
 Then this STON file is directly parsed from Pharo
*/
void writeStonFileFromConstants(FILE* file)
{
    int i;
    int hadPrevious;
    hadPrevious = 0;
    fprintf(file, "{\n");
    for (i=0; i<SIZE; i++) {
        
        if (strlen(constants[i].name) > 0 ) {
            if(hadPrevious) {
                fprintf(file, ",\n");
            }
            fprintf(file, "\t''%s'' : [\n", constants[i].name);
            fprintf(file, "\t\t%d,\n", constants[i].value);
            fprintf(file, "\t\t%lu\n", sizeof(constants[i].value));
            fprintf(file, "\t]");
            hadPrevious = 1;
        } 
        
    };
    fprintf(file, "\n}\n");
};

/*
 Writes a Smalltalk method source in which constant values are assigned directly into class vars.
 Example:
 
 initVariablesMacOS32
	SIGABRT := 6;
	SIGALRM := 14;
    "SIGPOLL Undefined for this platform"

 Then this file is compiled directly into a SharedPool class
 */
void writeSmalltalkFileFromConstants(FILE* file)
{
    int i;
    fprintf(file, "%s\n", METHOD_NAME);
    fprintf(file, "\t<platformName: ''%s'' wordSize: %d>\n", PLATFORM_NAME, WORD_SIZE);
    for (i=0; i<SIZE; i++) {
        if (constants[i].defined) {
            fprintf(file, "\t%s := %d.\n", constants[i].name, constants[i].value );
        } else {
            fprintf(file, "\t\"%s Undefined for this platform\"\n", constants[i].name);
        }
        
    }
};


int main(int argc, const char * argv[]) {
    
    initializeConstantsArray();
    fillContantsArray();
    
    FILE *file = fopen("', self outputFilename, '", "w");
    if (file == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }
    writeSmalltalkFileFromConstants(file);
    fclose(file);
    
    return 0;
}


'