#include <cstdlib>
#include <iostream>
#include <string>
using namespace std;

void test(string message, bool b) {
  cout.width(30);
  cout << message;
  cout.width(10);
  if (b)
    cout << " PASSED\n";
  else
    cout << " FAILED\n";
}

// Returns the length of a string
int stringLength(string s) {
  return s.length();
}

// Converts a string to the empty string
string stringClear(string s) {
  s.clear();
  return s;
}

// Returns true if the string is empty
bool stringEmpty(string s) {
  return s.empty();
}

// Returns the character of a string at a given index
char charAt(string s, int index) {
  return s.at(index);
}

// Returns a concatenation of strings left and right
string stringAppend(string left, string right) {
  return left+= right;
}

// Returns the result of inserting a string into another
string stringInsert(string s, string toInsert) {
  return s.insert(7, toInsert);
}

// Erases part of a string
string stringErase(string s) {
  return s.erase(6, 19);
}

// Replaces part of a string
string stringReplace(string s) {
  return s.replace(0, 7, "Things");
}

// Returns the first index of character c in string s
int stringFind(string s, char c) {
  return s.find(c);
}

// Returns the last index of character c in string s
int stringRFind(string s, char c) {
  return s.rfind(c);
}

// Returns the index of the first character in the string that is not c
int stringFirstNot(string s, char c) {
  return s.find_first_not_of(c);
}

// Returns the index of the first occurance of character c
int stringFirst(string s, char c) {
  return s.find_first_of(c);
}

// Returns part of a string
string stringSubstring(string s) {
  return s.substr(7, 7);
}

// Returns the first name, given a full name
string firstName(string s) {
  int firstSpaceIndex = s.find(' ');
  return s.substr(0, firstSpaceIndex);
}

// Returns the middle name, given a full name
string middleName(string s) {
  int firstSpaceIndex = s.find(' ');
  int lastSpaceIndex = s.find_last_of(' ');
  int lengthOfMiddleName = lastSpaceIndex - firstSpaceIndex - 1;
  return s.substr(firstSpaceIndex + 1, lengthOfMiddleName);
}

// Returns the last name, given a full name
string lastName(string s) {
  return s.substr(s.find_last_of(' ') + 1, s.length() - 1);
}

// Returns a capitalized version of a string
string capitalize(string s) {
  char first = s[0];
  first = toupper(first);
  s[0] = first;
  return s;
}

// Returns true if the string contains character c
bool include(string s, char c) {
  return s.find_first_of(c) != s.npos;
}

// Returns a string substituting character target with character replacement
string substitute(string s, char target, char replacement) {
  int indexToReplace = 0;
  while (include(s, target)) {
    indexToReplace = s.find(target);
    s[indexToReplace] = replacement;
  }
  return s;
}

// Test suite. You should read, but not modify, this function.
void runAllTests() {
  test( "Testing length()", stringLength("Now") == 3 );
  test( "Testing clear()", stringClear("Is") == "" );
  test( "Testing empty()", stringEmpty("") );
  test( "Testing at()", charAt("Elephant", 3) == 'p' );
  test( "Testing append()", stringAppend("There's a ", "ocaml mystic.") == "There's a ocaml mystic." );
  test( "Testing insert()", stringInsert("If you carefully.", "listen ") == "If you listen carefully." );
  test( "Testing erase()", stringErase("This could be the first trumpet") == "This crumpet" );
  test( "Testing replace()", stringReplace("Strings are not the way") == "Things are not the way" );
  test( "Testing find()", stringFind("Have to face reality now.", 'o') == 6 );
  test( "Testing rfind()", stringRFind("Have to face reality now.", 'o') == 22 );
  test( "Testing find_first_of()", stringFirst("XXXXOXXX", 'O') == 4);
  test( "Testing find_first_not_of()", stringFirstNot("XXXXOXXX", 'X') == 4);
  test( "Testing substr()", stringSubstring("Such a natural mystic") == "natural" );
  test( "Testing firstName()", firstName("Robert Nesta Marley") == "Robert" );
  test( "Testing middleName()", middleName("Robert Nesta Marley") == "Nesta" );
  test( "Testing lastName()", lastName("Robert Nesta Marley") == "Marley" );
  test( "Testing capitalize()", capitalize("eager") == "Eager" );
  test( "Testing include()", include("Robert", 'o') );
  test( "Testing substitute()", substitute("The Gxxgle", 'x', 'o') == "The Google" );
}

int main() {

  cout << "Testing your functions...\n\n";
  runAllTests();

    // Exit program.
    return 0;
}