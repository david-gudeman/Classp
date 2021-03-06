/* BEGIN HEADER */
#ifndef alt3_INCLUDE_
#define alt3_INCLUDE_

#include <assert.h>
#include <unordered_map>
#include <utility>

#include "classp.h"

// Include files generated by bison
#include "alt3.yacc.hh"
#include "location.hh"
#include "position.hh"

namespace alt3 {
using std::istream;
using std::ostream;
using classp::classpPrint;
using classp::classpFormat;
using classp::AttributeMap;

// Location and state information from the parser.
typedef location ParseState;

class AstNode;
/* BEGIN FORWARD DECLARATIONS */
class A;
/* END FORWARD DECLARATIONS */

// Base class for alt3 AST nodes
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
  A(ParseState parseState, AttributeMap& keyword_args);
  static A* parse(istream& input, ostream& errors);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  int a;
  bool has_a = false;
};
/* END CLASS DEFINITIONS */

}  // namespace alt3
#endif // alt3_INCLUDE_

/* END HEADER */
