#include <regex>
#include <string>
#include <stdlib.h>

using namespace std;

int test(char *str, char *exp){
	regex e(exp);
	bool match = regex_match(str, e);
	return (match ? 1 : 0);
}

char **match(char *sentence, char *exp) {
	int n = strlen(sentence);
	regex e(exp);

	char **result = (char **) malloc (sizeof (char *) * 100);
	int k = 0;
	for(int i = 0 ; i <= n; i++) {
		for(int j = i; j <= n; j++) {
		
		char *substring = substr(sentence, i, j);
		bool match = regex_match(substring, e);
		if(match) {
			result[k] = substring;
			k++;
			}

		}
	}
	
	return result;
}

int *match_indices(char *sentence, char *exp){
	int n = strlen(sentence);
	regex e(exp);

	int *result = (int *) malloc (sizeof (int) * 100);
	int k = 0;

	for(int i = 0 ; i < n; i++){
		for(int j = i ; j < n; j++){

		char *substring = substr(sentence, i, j);
		bool match = regex_match(substring, e);

		if(match){
			result[k] = i;
			k++;
			}

		}
	}
	return result;
}


char* substr(const char *src, int m, int n)
{
    int len = n - m;
 
    char *dest = (char*)malloc(sizeof(char) * (len + 1));
 
    for (int i = m; i < n && (*(src + i) != '\0'); i++)
    {
        *dest = *(src + i);
        dest++;
    }
 
    *dest = '\0';
 
    return dest - len;
}