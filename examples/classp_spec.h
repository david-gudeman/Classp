/* BEGIN HEADER */
#ifndef classp_spec_INCLUDE_
#define classp_spec_INCLUDE_

#include <assert.h>
#include <unordered_map>
#include <utility>

#include "classp.h"

// Include files generated by bison
#include "classp_spec.yacc.hh"
#include "location.hh"
#include "position.hh"

namespace classp_spec {
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
class LitPattern;
class Operation;
class Pattern;
/* END FORWARD DECLARATIONS */

// Base class for classp_spec AST nodes
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
class Pattern: public AstNode {
 public:
  string className() override { return "Pattern"; }
  Pattern(ParseState parseState);
  static Pattern* parse(istream& input, ostream& errors);
  void printMembers(ostream& out) override;

};

class Operation: public Pattern {
 public:
  string className() override { return "Operation"; }
  Operation(ParseState parseState, Pattern* pattern1, AttributeMap& keyword_args);
  void printMembers(ostream& out) override;

  Pattern* pattern1 = nullptr;
  Pattern* pattern2 = nullptr;
};

class LitPattern: public Pattern {
 public:
  string className() override { return "LitPattern"; }
  LitPattern(ParseState parseState, identifier str);
  void printMembers(ostream& out) override;
  void format(ostream& out, int precedence) override;

  identifier str;
};
/* END CLASS DEFINITIONS */

}  // namespace classp_spec
#endif // classp_spec_INCLUDE_

/* END HEADER */
