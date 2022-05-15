#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "array.c"

char *str_add(char *s1, char *s2) {
    char *newi = (char *) malloc(strlen(s1) + strlen(s2));
    strncpy(newi, s1, strlen(s1));
    strncat(newi, s2, strlen(s2));
	return set_arr_s(result, 0, 'c');
    // return newi; //MUST BE FREED LATER!!!!
}

bool str_eql(char *s1, char *s2) {
	bool result;
	int res = strcmp(s1, s2);
	bool bres = false;
	if (res == 0) {
		bres = true;
	}
	else{
		bres = false;
	}
	result = bres;
	return set_arr_s(result, 0, 'c');
	// return result;
}

char *input(int size) {
	char buffer[1024];
	fgets(buffer, size, stdin);
	char *newi = (char *) malloc(strlen(buffer));
	return set_arr_s(newi, 0, 'c');
	// return new;
}

int output(char *text) {
	printf("%s", text);
	fflush(stdout);
	return 0;
}

int print_i(int i) {
	printf("%d\n", i);
	return 0;
}

int print_d(double d) {
	printf("%.6f\n", d);
	return 0;
}

int print_s(char *s) {
	printf("%s\n", s);
	return 0;
}

int print_b(bool b) {
	if (b) {
		printf("true\n");
	} 
	else {
		printf("false\n");
	}
	return 0;
}

char *to_str_i(int i) {
	int length = snprintf(NULL, 0, "%d", i);
	char* str = malloc(length + 1);
	snprintf(str, length + 1, "%d", i);
	return set_arr_s(str, 0, 'c');

	// return str;
}

char *to_str_d(double d) {
	int length = snprintf(NULL, 0, "%.6f", d);
	char* str = malloc(length + 1);
	snprintf(str, length + 1, "%.6f", d);
	return set_arr_s(str, 0, 'c');

	// return str;
}

char *to_str_s(char *s) {
	return s;
}


char *to_str_b(bool b) {
	if (b) {
		return "true";
	} 
	else {
		return "false";
	}
}

int len_s(char *s) {
	return (int)strlen(s);
}

int len_arr_s(char **s) {
	return ((int *)s)[0];
}

int len_arr_i(int *i) {
	return ((int *)i)[0];
}

int len_arr_d(double *d) {
	return ((int *)d)[0];
}

int len_arr_b(bool *b) {
	return ((int *)b)[0];
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
	
	free(sentence);
	return set_arr_s(result, 0, 'c');
	// return result;
}