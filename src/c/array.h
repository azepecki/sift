#include <stdbool.h>

char **alloc_arr_s(int len);

int *alloc_arr_i(int len);

double *alloc_arr_d(int len);

bool *alloc_arr_b(int len);

char *acc_arr_s(char ** arr, int i);

int acc_arr_i(int *arr, int i);

double acc_arr_d(double *arr, int i);

bool acc_arr_b(bool *arr, int i);

char *set_arr_s(char ** arr, int i, char *x);

int set_arr_i(int *arr, int i, int x);

double set_arr_d(double *arr, int i, double x);

bool set_arr_b(bool *arr, int i, bool x);

char **literal_arr_s(int len, char **elements);

int *literal_arr_i(int len, int *elements);

double *literal_arr_d(int len, double *elements);

bool *literal_arr_b(int len, bool *elements);