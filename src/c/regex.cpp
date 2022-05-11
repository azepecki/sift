#include <regex>
#include <iostream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;



bool test(string str, string exp){

	regex e(exp);
	
	bool match = regex_match(str, e);

	return (match ? true : false);

}

vector<string> match(string sentence, string exp){
	int n = sentence.size();
	vector<string> result;
	regex e(exp);
	for(int i = 0 ; i < n; i++){
		for(int j = 0 ; j < n; j++){

		bool match = regex_match(sentence.substr(i, j), e);
		
		if(match){
			cout<<sentence.substr(i, j)<<" ";
			result.push_back(sentence.substr(i, j));
			}

		}
	}
	return result;
}

vector<int> match_indices(string sentence, string exp){
	int n = sentence.size();
	vector<int> result;
	regex e(exp);
	for(int i = 0 ; i < n; i++){
		for(int j = 0 ; j < n; j++){

		bool match = regex_match(sentence.substr(i, j), e);
		
		if(match){
			cout<<i<<" ";
			result.push_back(i);
			}

		}
	}
	return result;
}

vector<string> split(string line, char ch){
    vector <string> tokens;
     
    // stringstream class check1
    stringstream check1(line);
     
    string intermediate;
     
    // Tokenizing w.r.t. space ' '
    while(getline(check1, intermediate, ch))
    {
        tokens.push_back(intermediate);
    }
     

	return tokens;
}

string InputString(){
	string str;
	cin>>str;
	return str;
}

int InputInteger(){
	int str;
	cin>>str;
	return str;
}

string InputSentence(){
	string sentence;
	getline(cin, sentence);
	return sentence;
}

void testInput(){
	string str, exp;
	cin>>str;
	cin>>exp;
	test(str, exp);
}

void testmatchInput(){
	string sentence, exp;
	getline(cin, sentence);
	cin>>exp;
	vector<int> result = match_indices(sentence, exp);
}

void splitInput(){
	string sentence;
	getline(cin, sentence);
	char ch;
	cin>>ch;
	vector<string> tokens = split(sentence, ch);
	for(int i = 0 ; i < tokens.size(); i++) cout<<tokens[i]<<"-";
}

void rununittests(){
	// string str, exp;
	// cin>>str;
	// cin>>exp;
	// cout<<"string: "<<str<<"expression: "<<exp<<"Result: "<<test(str, exp);
	
	
	// string sentence, exp;
	// getline(cin, sentence);
	// cin>>exp;
	// vector<string> result = match(sentence, exp);


	// string sentence, exp;
	// getline(cin, sentence);
	// cin>>exp;
	// vector<int> result = match_indices(sentence, exp);


	// string sentence;
	// getline(cin, sentence);
	// char ch;
	// cin>>ch;
	// vector<string> tokens = split(sentence, ch);
	// for(int i = 0 ; i < tokens.size(); i++) cout<<tokens[i]<<"-";
}

void unittests(){

	cout<<(test("hello", "h(i|ello)") == 1 ? "PASSED TEST CASE 1" : "FAILED")<<endl;
	cout<<(test("ello", "h(i|ello)") == 0 ? "PASSED TEST CASE 2" : "FAILED")<<endl;

	vector<string> result = match("The wiiiiiiiiiild wild cat lived in a mild climate.", "(w|m)i*ld");
	const char *output[3] = { "wiiiiiiiiiild", "wild", "mild"};

	bool failed=false;
	for(int i = 0 ; i < result.size(); i++) {
		if(result[i] != output[i]){
			failed = true;
		}
	}
	cout<<(failed ? "FAILED" : "PASSED TEST CASE 3")<<endl;

	vector<int> result2 = match_indices("The wiiiiiiiiiild wild cat lived in a mild climate.", "(w|m)i*ld");
	int output2[3] = {4, 18, 38};
	failed=false;
	for(int i = 0 ; i < result.size(); i++) {
		if(result2[i] != output2[i]){
			failed = true;
		}
	}
	cout<<(failed ? "FAILED" : "PASSED TEST CASE 4")<<endl;

	vector<string> tokens = split("The wiiiiiiiiiild wild cat lived in a mild climate.", ' ');
	
	for(int i = 0 ; i < tokens.size(); i++) cout<<tokens[i]<<"-";
	cout<<"PASSED TEST CASE 5";
}

int main(){

	unittests();
  
	return 0;
}