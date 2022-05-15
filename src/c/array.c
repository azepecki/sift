#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "array.h"

char **alloc_arr_s(int len) {
    char **arr = (char **) malloc(sizeof(int) + len * sizeof(char *));
    ((int *) arr)[0] = len; 
	return arr;
}

int *alloc_arr_i(int len) {
    int *arr = (int *) malloc(sizeof(int) + len * sizeof(int));
    arr[0] = len; 
	return arr;
}

double *alloc_arr_d(int len) {
    double *arr = (double *) malloc(sizeof(int) + len * sizeof(double));
    ((int *) arr)[0] = len; 
	return arr;
}

bool *alloc_arr_b(int len) {
    bool *arr = (bool *) malloc(sizeof(int) + len * sizeof(bool));
    ((int *) arr)[0] = len; 
	return arr;
}

char *acc_arr_s(char ** arr, int i) {
    return *((char **)((int *)arr + 1) + i); 
}

int acc_arr_i(int *arr, int i) {
    return *((int *)((int *)arr + 1) + i); 
}

double acc_arr_d(double *arr, int i) {
    return *((double *)((int *)arr + 1) + i); 
}

bool acc_arr_b(bool *arr, int i) {
    return *((bool *)((int *)arr + 1) + i); 
}

char *set_arr_s(char ** arr, int i, char *x) {
    *((char **)((int *)arr + 1) + i) = x; 
	return x;
}

int set_arr_i(int *arr, int i, int x) {
    *((int *)((int *)arr + 1) + i) = x; 
	return x;
}

double set_arr_d(double *arr, int i, double x) {
    *((double *)((int *)arr + 1) + i) = x; 
	return x;
}

bool set_arr_b(bool *arr, int i, bool x) {
    *((bool *)((int *)arr + 1) + i) = x; 
	return x;
}

char **literal_arr_s(int len, char **elements) {
    char **arr = alloc_arr_s(len);
    for (int i = 0; i < len; i++) {
        set_arr_s(arr, i, elements[i]);
    }
	return arr;
}

int *literal_arr_i(int len, int *elements) {
    int *arr = alloc_arr_i(len);
    for (int i = 0; i < len; i++) {
        set_arr_i(arr, i, elements[i]);
    }
	return arr;
}

double *literal_arr_d(int len, double *elements) {
    double *arr = alloc_arr_d(len);
    for (int i = 0; i < len; i++) {
        set_arr_d(arr, i, elements[i]);
    }
	return arr;
}

bool *literal_arr_b(int len, bool *elements) {
    bool *arr = alloc_arr_b(len);
    for (int i = 0; i < len; i++) {
        set_arr_b(arr, i, elements[i]);
    }
	return arr;
}