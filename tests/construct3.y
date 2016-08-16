/* BEGIN PARSER */
%code requires {

#include <string>
using std::string;
#include <vector>
using std::vector;

/* BEGIN CODE PREFIX */
/* END CODE PREFIX */

#include "classp.h"
using classp::AttributeMap;
typedef string identifier;

namespace construct3 {
class ParseDriver;
class AstNode;
/* BEGIN FORWARD DECLARATIONS */
class A;
class B;
class D;
/* END FORWARD DECLARATIONS */
}

}

%require "3.0.2"
%defines
%define api.value.type variant
%define "parser_class_name" {YYParser}
%error-verbose
%lex-param {construct3::ParseDriver* parser}
%locations
%define api.namespace {construct3}
%parse-param {construct3::ParseDriver* parser}
%parse-param {construct3::AstNode** result}
%define api.token.constructor
%skeleton "lalr1.cc"

%initial-action {
}

%token TOK_EOF 0              "end of file"

/* BEGIN GENERATED TOKEN DECLARATIONS */
%token TOK_LPAREN "`(`"
%token TOK_RPAREN "`)`"
%token WORD_and "`and`"
%token WORD_x "`x`"
%token WORD_y "`y`"
/* END GENERATED TOKEN DECLARATIONS */

%token TOK_BOOL   "boolean literal"
%token TOK_IDENTIFIER         "identifier"
%token TOK_INT64    "integer literal"
%token TOK_STRING_LITERAL     "string literal"


/* BEGIN NONTERMINAL TYPES */
%type <A*> class_A
%type <AttributeMap> alt_B__1
/* END NONTERMINAL TYPES */

%type <bool> TOK_BOOL
%type <int64_t> TOK_INT64
%type <string>  TOK_IDENTIFIER
%type <string>  TOK_STRING_LITERAL

%code {

#include "construct3.yacc.hh"
#include "construct3.h"

namespace construct3 {

YYParser::symbol_type yylex(ParseDriver* parser);

ParseState defaultParseState;

}  // namespace construct3

}


%start start

%%

start
/* BEGIN PARSEABLE */
  : class_A TOK_EOF { *result = $1; }
/* END PARSEABLE */
  ;

/* BEGIN PRODUCTIONS */
class_A
  :  TOK_LPAREN class_A TOK_RPAREN { $$ = $2; }
  |  WORD_x  alt_B__1 WORD_y {
      AttributeMap keywords = $2;
      $$ = new B(@$, keywords); }  // B
  |  TOK_IDENTIFIER WORD_and TOK_IDENTIFIER {
      $$ = new D(@$, $1, $3); }  // D
  ;

alt_B__1
  : class_A {
    $$ = AttributeMap();
    $$.Add("a1", $1); }
  |  {
    $$ = AttributeMap(); }
  ;



/* END PRODUCTIONS */

%%

#include <sstream>

namespace construct3 {

using std::istream;
using std::ostream;
using std::stringstream;

AstNode* parse(istream& input, ostream& errors);

/* BEGIN METHOD DEFINITIONS */
A::A(ParseState parseState)
    : AstNode(parseState) {
}

A* A::parse(istream& input, ostream& errors) {
  return dynamic_cast<A*>(construct3::parse(input, errors));
}
void A::printMembers(ostream& out) {
}
B::B(ParseState parseState, AttributeMap& keyword_args)
    : A(parseState) {
  if (!(keyword_args.Take("a1", a1))) {
    a1 = new D(defaultParseState, /*str1*/ "blank1", /*str2*/ "blank2");
  }
}

void B::printMembers(ostream& out) {
  A::printMembers(out);

  out << " a1:";
  classpPrint(out, a1);
}

void B::format(ostream& out, int precedence) {
  out << "x";
  out << " ";
  if (a1 != nullptr && (a1->className() != "D" || dynamic_cast<D*>(a1)->str1 != "blank1" || dynamic_cast<D*>(a1)->str2 != "blank2")) {
    classpFormat(out, 0, a1);
  }
  out << " ";
  out << "y";
}
D::D(ParseState parseState, identifier str1, identifier str2)
    : A(parseState)
    , str1(str1)
    , str2(str2) {
}

void D::printMembers(ostream& out) {
  A::printMembers(out);

  out << " str1:";
  classpPrint(out, str1);
  out << " str2:";
  classpPrint(out, str2);
}

void D::format(ostream& out, int precedence) {
  classpFormat(out, 0, str1);
  out << " ";
  out << "and";
  out << " ";
  classpFormat(out, 0, str2);
}
/* END METHOD DEFINITIONS */

#ifdef PARSER_TEST

void ParseAndPrint(istream& input, ostream& out) {
/* BEGIN PARSE PARSEABLE */
  AstNode* result = A::parse(input, out);
/* END PARSE PARSEABLE */
  if (result) {
    out << "Succeeded:\n";
    result->format(out);
    out << "\n";
  } else {
    out << "Parse failed.\n";
  }
}

// These constants never a legal output from AstParser::print()
const char kSucceed[] = "!succeed!";
const char kFail[] = "!fail!";
const char kPrint[] = "!print!";

// Runs the parser in the given sample and compares the result to
// expected_result which can be nullptr to indicate that the parse should fail.
// With no second argument, this just prints the result. Returns 1 if the parse
// failed and was not expected to, or if the result is different from the
// expected result, otherwise returns 0.
template<class T>
int ParseSample(const char* sample, const char* expected_result = kPrint) {
  stringstream input(sample);
  stringstream errors;
  std::cout << "parsing sample '" << sample << "':\n";
  AstNode* result = T::parse(input, errors);
  if (result) {
    stringstream actual_result;
    result->print(actual_result);
    if (expected_result == kFail) {
      std::cout << "ERROR[succeeds but expected fail:\n"
          << "  result->" << actual_result.str() << "]\n";
      return 1;
    }

    // Now format the output and try parsing it again.
    stringstream formatted;
    result->format(formatted);
    std::cout << "parsing formatted result '" << formatted.str() << "'\n";
    AstNode* result2 = T::parse(formatted, errors);
    if (!result2) {
      std::cout << "\nERROR[parsing the formatted string failed." 
          << "\n  original parse->" << actual_result.str() << "]\n";
      return 1;
    }
    stringstream actual_result2;
    result2->print(actual_result2);
    if (actual_result.str() != actual_result2.str()) {
      std::cout << "ERROR[parsed formatted string does not match:"
          << "\n  original->" << actual_result.str()
          << "\n  parsed->  " << actual_result2.str() << "\n  ]\n";
      return 1;
    }

    std::cout<< "SUCCEEDS";
    if (expected_result == kPrint) {
      std::cout << ": ";
      result->print(std::cout);
    } else if (expected_result != kSucceed) {
      if (actual_result.str() != expected_result) {
        std::cout << "\nERROR[expected and actual result do not match:"
            << "\n  expected-> " << expected_result
            << "\n  actual->   " << actual_result.str() << "\n  ]\n";
        return 1;
      }
    }
    std::cout << "\n";
    return 0;
  } else {
    std::cout << "FAILS";
    if (expected_result == kFail) {
      std::cout << " [as expected]\n";
      return 0;
    } else if (expected_result == kPrint || expected_result == kSucceed) {
      std::cout << ": ERROR[expected success]";
    } else {
      std::cout << ": ERROR[expected " << expected_result << "]";
    }
    std::cout << "\n  " << errors.str();
    return 1;
  }
}

int ParseSamples() {
  int num_errors = 0;
/* BEGIN SAMPLES */
  num_errors += ParseSample<A>(R"#A#(( and ))#A#", kFail);
  num_errors += ParseSample<A>(R"#A#(x y)#A#", R"#A#((B a1:(D str1:blank1 str2:blank2)))#A#");
  num_errors += ParseSample<A>(R"#A#(x foo y)#A#", kFail);
  num_errors += ParseSample<A>(R"#A#(x foo and bar y)#A#", R"#A#((B a1:(D str1:foo str2:bar)))#A#");
/* END SAMPLES */
  std::cout << "Errors: " << num_errors << "\n";
  return num_errors;
}

#endif  // PARSER_TEST


}  // namespace construct3

#ifdef PARSER_TEST

#include <fstream>
#include <iostream>

using std::istream;
using std::ifstream;

const char usage[] = "usage: construct3 [input-file | --samples]\n";

int main(int argc, char** argv) {
  if (argc > 2) {
    std::cerr << usage;
    exit(1);
  }
  if (argc == 2 && std::string(argv[1]) == "--samples") {
    if (construct3::ParseSamples() > 0) exit(1);
  } else {
    ifstream file;
    if (argc == 2) {
      file.open(argv[1]);
      if (file.fail()) {
        std::cerr << "failed to open '" << argv[1] << "' for reading\n";
        exit(1);
      }
    }
    istream& input = argc == 2 ? file : std::cin;
    construct3::ParseAndPrint(input, std::cout);
  }
  return 0;
}

#endif  // PARSER_TEST

/* END PARSER */
