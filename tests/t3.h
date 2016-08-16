/* BEGIN HEADER */
#ifndef t3_INCLUDE_
#define t3_INCLUDE_

#include <assert.h>
#include <unordered_map>
#include <utility>

#include "classp.h"

// Include files generated by bison
#include "t3.yacc.hh"
#include "location.hh"
#include "position.hh"

namespace t3 {
using std::istream;
using std::ostream;
using classp::classpPrint;
using classp::classpFormat;
using classp::AttributeMap;

// Location and state information from the parser.
typedef location ParseState;

extern ParseState defaultParseState;

class AstNode;
/* BEGIN FORWARD DECLARATIONS */
class Declaration;
class ProcedureDecl;
class Statement;
class Unparsed;
/* END FORWARD DECLARATIONS */

// Base class for t3 AST nodes
class AstNode : public classp::ClasspNode {
 public:
  string className() override { return "AstNode"; }
  AstNode(ParseState parseState)
    : parseState(parseState) {
    }

  // Write out a bracketed form of this AST from the declared syntax.
  virtual void bracketFormat(std::ostream& out, AstNode* self) {
    assert(false);
  }

  ParseState parseState;
};

/* BEGIN CLASS DEFINITIONS */
class ProcedureDecl: public AstNode {
 public:
  string className() override { return "ProcedureDecl"; }
  ProcedureDecl(ParseState parseState, identifier name, vector<Declaration*> arguments, vector<Declaration*> locals, vector<Statement*> statements);
  static ProcedureDecl* parse(istream& input, ostream& errors);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  identifier name;
  vector<Declaration*> arguments;
  vector<Declaration*> locals;
  vector<Statement*> statements;
};

class Declaration: public AstNode {
 public:
  string className() override { return "Declaration"; }
  Declaration(ParseState parseState, identifier type_name, identifier variable_name);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  identifier type_name;
  identifier variable_name;
};

class Statement: public AstNode {
 public:
  string className() override { return "Statement"; }
  Statement(ParseState parseState, identifier procedure_name, vector<identifier> arguments);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  identifier procedure_name;
  vector<identifier> arguments;
};

class Unparsed: public AstNode {
 public:
  string className() override { return "Unparsed"; }
  Unparsed(ParseState parseState, int foo);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  int foo;
};
/* END CLASS DEFINITIONS */

}  // namespace t3
#endif // t3_INCLUDE_

/* END HEADER */
