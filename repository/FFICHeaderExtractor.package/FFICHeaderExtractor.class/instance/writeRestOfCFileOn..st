generating C program
writeRestOfCFileOn: stream
	stream cr.
	stream nextPutAll: '#define printDefinedConstant(file, const) fprintf(file, "#(%s %d %ld)\n", #const, const, sizeof(const))
#define printUndefinedConstant(file, const) fprintf(file, "#(UNDEFINED%s %d %d)\n", #const, 0, 0)

int main(int argc, const char * argv[]) {

    FILE *file = fopen("', self outputFilename, '", "w");
    if (file == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }
'.
	self writeListOfConstantsOn: stream. 

stream nextPutAll: '
    fclose(file);    
    return 0;
}

'
