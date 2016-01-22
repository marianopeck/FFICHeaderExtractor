generating C program
writeRestOfCFileOn: stream
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
void writeOutputFileFromConstants(FILE* file)
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


int main(int argc, const char * argv[]) {
    
    initializeConstantsArray();
    fillContantsArray();
    
    FILE *file = fopen("', self stonFilename, '", "w");
    if (file == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }
    writeOutputFileFromConstants(file);
    fclose(file);
    
    return 0;
}


'