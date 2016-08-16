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

namespace x {
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
%lex-param {x::ParseDriver* parser}
%locations
%define api.namespace {x}
%parse-param {x::ParseDriver* parser}
%parse-param {x::AstNode** result}
%define api.token.constructor
%skeleton "lalr1.cc"

%initial-action {
}

%token TOK_EOF 0              "end of file"

/* BEGIN GENERATED TOKEN DECLARATIONS */
%token TOK_LPAREN "`(`"
%token TOK_RPAREN "`)`"
%token WORD_elif "`elif`"
%token WORD_else "`else`"
%token WORD_fi "`fi`"
%token SYM__0 "`found 1`"
%token SYM__1 "`found 2`"
%token SYM__2 "`found 3`"
%token WORD_if "`if`"
%token WORD_then "`then`"
/* END GENERATED TOKEN DECLARATIONS */

%token TOK_BOOL   "boolean literal"
%token TOK_IDENTIFIER         "identifier"
%token TOK_INT64    "integer literal"
%token TOK_STRING_LITERAL     "string literal"


/* BEGIN NONTERMINAL TYPES */
%type <A*> class_A
%type <AttributeMap> alt_B__1
%type <A*> typed_A__1
%type <A*> typed_A__2
/* END NONTERMINAL TYPES */

%type <bool> TOK_BOOL
%type <int64_t> TOK_INT64
%type <string>  TOK_IDENTIFIER
%type <string>  TOK_STRING_LITERAL

%code {

#include "x.yacc.hh"
#include "x.h"

namespace x {

YYParser::symbol_type yylex(ParseDriver* parser);

ParseState defaultParseState;

}  // namespace x

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
  |  WORD_if class_A WORD_then  alt_B__1 WORD_elif typed_A__1 WORD_else typed_A__2 WORD_fi {
      AttributeMap keywords = $4;
      keywords.Add("a1", $2);
      keywords.Add("a4", $8);
      $$ = new B(@$, $6, keywords); }  // B
  | TOK_IDENTIFIER {
      $$ = new D(@$, $1); }  // D
  ;

alt_B__1
  : class_A {
    $$ = AttributeMap();
    $$.Add("a2", $1); }
  |  {
    $$ = AttributeMap(); }
  ;

typed_A__1
  : SYM__0 { $$ = new D(defaultParseState, /*str*/ "1"); }
  | SYM__1 { $$ = new D(defaultParseState, /*str*/ "2"); }
  ;

typed_A__2
  : SYM__2 { $$ = new D(defaultParseState, /*str*/ "3"); }
  |  { $$ = new D(defaultParseState, /*str*/ "4"); }
  ;



/* END PRODUCTIONS */

%%

#include <sstream>

namespace x {

using std::istream;
using std::ostream;
using std::stringstream;

AstNode* parse(istream& input, ostream& errors);

/* BEGIN METHOD DEFINITIONS */
A::A(ParseState parseState)
    : AstNode(parseState) {
}

A* A::parse(istream& input, ostream& errors) {
  return dynamic_cast<A*>(x::parse(input, errors));
}
void A::printMembers(ostream& out) {
}
B::B(ParseState parseState, A* a3, AttributeMap& keyword_args)
    : A(parseState)
    , a3(a3) {
  if (!(keyword_args.Take("a1", a1))) {
    a1 = new D(defaultParseState, /*str*/ "");
  }
  if (!(keyword_args.Take("a2", a2))) {
    a2 = new D(defaultParseState, /*str*/ "");
  }
  has_a4 = keyword_args.Take("a4", a4);
}

void B::printMembers(ostream& out) {
  A::printMembers(out);

  out << " a1:";
  classpPrint(out, a1);
  out << " a2:";
  classpPrint(out, a2);
  out << " a3:";
  classpPrint(out, a3);
  if (has_a4) {
    out << " a4:";
    classpPrint(out, a4);
  } else {
    out << "a4[not defined]";
    }
}

void B::format(ostream& out, int precedence) {
  out << "if";
  out << " ";
  classpFormat(out, 0, a1);
  out << " ";
  out << "then";
  out << " ";
  if (a2 != nullptr && (a2->className() != "D" || dynamic_cast<D*>(a2)->str != "")) {
    classpFormat(out, 0, a2);
  }
  out << " ";
  out << "elif";
  out << " ";
  if (a3 != nullptr && (a3->className() != "D" || dynamic_cast<D*>(a3)->str != "1")) {
    out << "found 1";
  } else if (a3 != nullptr && (a3->className() != "D" || dynamic_cast<D*>(a3)->str != "2")) {
    out << "found 2";
  }
  out << " ";
  out << "else";
  out << " ";
  if (!has_a4) {
  } else if (a4 != nullptr && (a4->className() != "D" || dynamic_cast<D*>(a4)->str != "3")) {
    out << "found 3";
  } else if (a4 != nullptr && (a4->className() != "D" || dynamic_cast<D*>(a4)->str != "4")) {
    out << "";
  }
  out << " ";
  out << "fi";
}
D::D(ParseState parseState, identifier str)
    : A(parseState)
    , str(str) {
}

void D::printMembers(ostream& out) {
  A::printMembers(out);

  out << " str:";
  classpPrint(out, str);
}

void D::format(ostream& out, int precedence) {
  classpFormat(out, 0, str);
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
/* END SAMPLES */
  std::cout << "Errors: " << num_errors << "\n";
  return num_errors;
}

#endif  // PARSER_TEST


}  // namespace x

#ifdef PARSER_TEST

#include <fstream>
#include <iostream>

using std::istream;
using std::ifstream;

const char usage[] = "usage: x [input-file | --samples]\n";

int main(int argc, char** argv) {
  if (argc > 2) {
    std::cerr << usage;
    exit(1);
  }
  if (argc == 2 && std::string(argv[1]) == "--samples") {
    if (x::ParseSamples() > 0) exit(1);
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
    x::ParseAndPrint(input, std::cout);
  }
  return 0;
}

#endif  // PARSER_TEST

/* END PARSER */
