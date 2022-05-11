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


// void unittests(){

// 	cout<<(test("hello", "h(i|ello)") == 1 ? "PASSED TEST CASE 1" : "FAILED")<<endl;
// 	cout<<(test("ello", "h(i|ello)") == 0 ? "PASSED TEST CASE 2" : "FAILED")<<endl;

// 	vector<string> result = match("The wiiiiiiiiiild wild cat lived in a mild climate.", "(w|m)i*ld");
// 	const char *output[3] = { "wiiiiiiiiiild", "wild", "mild"};

// 	bool failed=false;
// 	for(int i = 0 ; i < result.size(); i++) {
// 		if(result[i] != output[i]){
// 			failed = true;
// 		}
// 	}
// 	cout<<(failed ? "FAILED" : "PASSED TEST CASE 3")<<endl;

// 	vector<int> result2 = match_indices("The wiiiiiiiiiild wild cat lived in a mild climate.", "(w|m)i*ld");
// 	int output2[3] = {4, 18, 38};
// 	failed=false;
// 	for(int i = 0 ; i < result.size(); i++) {
// 		if(result2[i] != output2[i]){
// 			failed = true;
// 		}
// 	}
// 	cout<<(failed ? "FAILED" : "PASSED TEST CASE 4")<<endl;

// 	vector<string> tokens = split("The wiiiiiiiiiild wild cat lived in a mild climate.", ' ');
	
// 	for(int i = 0 ; i < tokens.size(); i++) cout<<tokens[i]<<"-";
// 	cout<<"PASSED TEST CASE 5";
// }