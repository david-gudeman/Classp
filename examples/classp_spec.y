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

namespace classp_spec {
class ParseDriver;
class AstNode;
/* BEGIN FORWARD DECLARATIONS */
class LitPattern;
class Operation;
class Pattern;
/* END FORWARD DECLARATIONS */
}

}

%require "3.0.2"
%defines
%define api.value.type variant
%define "parser_class_name" {YYParser}
%error-verbose
%lex-param {classp_spec::ParseDriver* parser}
%locations
%define api.namespace {classp_spec}
%parse-param {classp_spec::ParseDriver* parser}
%parse-param {classp_spec::AstNode** result}
%define api.token.constructor
%skeleton "lalr1.cc"

%initial-action {
}

%token TOK_EOF 0              "end of file"

/* BEGIN GENERATED TOKEN DECLARATIONS */
%token TOK_LPAREN "`(`"
%token TOK_RPAREN "`)`"
/* END GENERATED TOKEN DECLARATIONS */

%token TOK_BOOL   "boolean literal"
%token TOK_IDENTIFIER         "identifier"
%token TOK_INT64    "integer literal"
%token TOK_STRING_LITERAL     "string literal"


/* BEGIN NONTERMINAL TYPES */
%type <Pattern*> class_Pattern
/* END NONTERMINAL TYPES */

%type <bool> TOK_BOOL
%type <int64_t> TOK_INT64
%type <string>  TOK_IDENTIFIER
%type <string>  TOK_STRING_LITERAL

%code {

#include "classp_spec.yacc.hh"
#include "classp_spec.h"

namespace classp_spec {

YYParser::symbol_type yylex(ParseDriver* parser);

ParseState defaultParseState;

}  // namespace classp_spec

}


%start start

%%

start
/* BEGIN PARSEABLE */
  : class_Pattern TOK_EOF { *result = $1; }
/* END PARSEABLE */
  ;

/* BEGIN PRODUCTIONS */
class_Pattern
  : TOK_IDENTIFIER {
      $$ = new LitPattern(@$, $1); }  // LitPattern
  |  TOK_LPAREN class_Pattern TOK_RPAREN { $$ = $2; }
  ;



/* END PRODUCTIONS */

%%

#include <sstream>

namespace classp_spec {

using std::istream;
using std::ostream;
using std::stringstream;

AstNode* parse(istream& input, ostream& errors);

/* BEGIN METHOD DEFINITIONS */
Pattern::Pattern(ParseState parseState)
    : AstNode(parseState) {
}

Pattern* Pattern::parse(istream& input, ostream& errors) {
  return dynamic_cast<Pattern*>(classp_spec::parse(input, errors));
}
void Pattern::printMembers(ostream& out) {
}
Operation::Operation(ParseState parseState, Pattern* pattern1, AttributeMap& keyword_args)
    : Pattern(parseState)
    , pattern1(pattern1) {
  if (!(keyword_args.Take("pattern2", pattern2))) {
    ;
  }
}

void Operation::printMembers(ostream& out) {
  Pattern::printMembers(out);

  out << " pattern1:";
  classpPrint(out, pattern1);
  out << " pattern2:";
  classpPrint(out, pattern2);
}
LitPattern::LitPattern(ParseState parseState, identifier str)
    : Pattern(parseState)
    , str(str) {
}

void LitPattern::printMembers(ostream& out) {
  Pattern::printMembers(out);

  out << " str:";
  classpPrint(out, str);
}

void LitPattern::format(ostream& out, int precedence) {
  classpFormat(out, 0, str);
}
/* END METHOD DEFINITIONS */

#ifdef PARSER_TEST

void ParseAndPrint(istream& input, ostream& out) {
/* BEGIN PARSE PARSEABLE */
  AstNode* result = Pattern::parse(input, out);
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


}  // namespace classp_spec

#ifdef PARSER_TEST

#include <fstream>
#include <iostream>

using std::istream;
using std::ifstream;

const char usage[] = "usage: classp_spec [input-file | --samples]\n";

int main(int argc, char** argv) {
  if (argc > 2) {
    std::cerr << usage;
    exit(1);
  }
  if (argc == 2 && std::string(argv[1]) == "--samples") {
    if (classp_spec::ParseSamples() > 0) exit(1);
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
    classp_spec::ParseAndPrint(input, std::cout);
  }
  return 0;
}

#endif  // PARSER_TEST

/* END PARSER */
