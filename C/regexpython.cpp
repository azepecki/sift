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



int main(){

	// string str, exp;
	// cin>>str;
	// cin>>exp;
	// test(str, exp);
	
	
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
	return 0;
}