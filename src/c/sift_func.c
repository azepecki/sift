#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

char *str_add(char *s1, char *s2) {
    char *new = (char *) malloc(strlen(s1) + strlen(s2));
    strncpy(new, s1, strlen(s1)-1);
    strncat(new, s2+1, strlen(s2)-1);
	free(new);
    return new;
}

bool str_eql(char *s1, char *s2) {
	bool result;
	int res = strcmp(s1, s2);
	bool bres = false;
	if (res == 0){
		bres = true;
	}
	else{
		bres = false;
	}
	result = bres;
	return result;
}

int len(const char *str) {
	int l;
	size_t len = strlen(str);
	l = (int)(len) - 2;
	return l;
}

char **word_tokenize(char *str) {
	char *sentence = (char *) malloc(strlen(str) + 1);
	strcpy(sentence, str);
	int spaces = 1;
	for(int i=0; str[i] != '\0'; i++) {
		if (str[i] == ' ') {
			spaces++;
		}
	}
	
	char **result = malloc (sizeof (char *) * spaces);
	char *token = strtok(sentence, " ");
	int i = 0;
	while (token != NULL) {
		result[i] = token;
		i++;
		token = strtok(NULL, " ");
	}

	free(result);
	free(sentence);
	return result;
}