import XCTest
import ExpressionTree
@testable import GodelNumbering

final class GStatementTests: XCTestCase {
  func test_isProvable() {
    let axioms = [ExpressionTree(formula: "0=0")]
    let theorems = [ExpressionTree(formula: "0=0")]
    let proof = Proof(axioms: axioms, theorems: theorems)
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // (∃x)(x=sy)
    let gStatement = GStatement(proof: proof, gn: gn)
    XCTAssertFalse(gStatement.isProvable())
  }

  func test_provable_leads_to_contradiction() {
    let axioms = [ExpressionTree(formula: "0=0")]
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // (∃x)(x=sy)
    let substituted = ExpressionTree.sub(gn: gn, variable: 13, term: gn)
    let theorems = [substituted]
    let proof = Proof(axioms: axioms, theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    XCTAssertTrue(gStatement.isProvable())
  }
}
