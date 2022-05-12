#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdbool.h>

char* first(char* sentence, char* key) {
    char *ret;
    ret = strstr(sentence, key);
    return ret;
}

char* read(char* file) {

 FILE *fp;
 char ch;
 char *ret = (char*)(malloc(200));

 fp = fopen (file, "r");
 char c = fgetc(fp);
 int i = 0;
    while (c != EOF)
    {   ret[i] = c;
        i++;
        c = fgetc(fp);
    }
  fclose(fp);
  return ret;
}

char* copy(char* input, char* output) {

 FILE *fp1, *fp2;
 char ch;
 char *ret;

 fp1 = fopen (input, "r");
 fp2 = fopen (output, "w");
 char c = fgetc(fp1);
    while (c != EOF)
    {
        fputc(c, fp2);
        c = fgetc(fp1);
    }
  fclose(fp1);
  return ret;
}

char* replace(char* file, char* word, char* replace) {

 FILE *fp, *ofp;
 char ch;
 char *ret = (char*)(malloc(200));
 char *read = (char*)(malloc(200));
 ofp = fopen("file_replace_output.txt", "w+");
 fp = fopen (file, "r+");
 char c = fgetc(fp);
 int i = 0;
 rewind(fp);
    while (!feof(fp)) {
        fscanf(fp, "%s", read);
        if (strcmp(read, word) == 0) {
            strcpy(read, replace);
        }
        fprintf(ofp, "%s ", read);
    }
  fclose(fp);
  return ret;
}

int count_word(char* file, char* word) {

 FILE *fp;
 char ch;
 char *ret = (char*)(malloc(200));

 fp = fopen (file, "r");
 char c = fgetc(fp);
 int i = 0, count = 0;
    while (fscanf(fp, " %1023s", ret) != EOF) {
        if (strcmp(ret, word) == 0) {
            count++;
        }
    }
  fclose(fp);
  return count;
}

bool is_present(char* file, char* word) {

 FILE *fp;
 char ch;
 char *ret = (char*)(malloc(200));

 fp = fopen (file, "r");
 char c = fgetc(fp);
 int i = 0, count = 0;
    while (fscanf(fp, " %1023s", ret) != EOF) {
        if (strcmp(ret, word) == 0) {
            fclose(fp);
            return true;
        }
    }
  fclose(fp);
  return false;
}

// int main() {
//     // printf("%s", middleName("Secondfirst","first"));
//     // printf("%s", readfile("text.txt"));
//     // printf("%s", copyfile("text.txt", "copy.txt"));
//     // printf("%c", )

//     // printf("%s", readfile("text.txt"));

//     // replaceword("text.txt", "live", "delhi");
//     // printf("%s", readfile("text.txt"));

//     // printf("%d", countword("text.txt", "line"));

//   return 0;
// }