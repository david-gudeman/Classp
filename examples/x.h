/* BEGIN HEADER */
#ifndef x_INCLUDE_
#define x_INCLUDE_

#include <assert.h>
#include <unordered_map>
#include <utility>

#include "classp.h"

// Include files generated by bison
#include "x.yacc.hh"
#include "location.hh"
#include "position.hh"

namespace x {
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
class A;
class B;
class D;
/* END FORWARD DECLARATIONS */

// Base class for x AST nodes
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
class A: public AstNode {
 public:
  string className() override { return "A"; }
  A(ParseState parseState);
  static A* parse(istream& input, ostream& errors);
  void printMembers(ostream& out) override;

};

class B: public A {
 public:
  string className() override { return "B"; }
  B(ParseState parseState, A* a3, AttributeMap& keyword_args);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  A* a1 = nullptr;
  A* a2 = nullptr;
  A* a3 = nullptr;
  A* a4 = nullptr;
  bool has_a4 = false;
};

class D: public A {
 public:
  string className() override { return "D"; }
  D(ParseState parseState, identifier str);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  identifier str;
};
/* END CLASS DEFINITIONS */

}  // namespace x
#endif // x_INCLUDE_

/* END HEADER */