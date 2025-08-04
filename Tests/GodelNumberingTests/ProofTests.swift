import XCTest
import ExpressionTree
@testable import GodelNumbering

final class ProofTests: XCTestCase {
  func test_isProvable() {
    let axioms = [ExpressionTree(formula: "0=0")]
    let theorems = [ExpressionTree(formula: "0=0")]
    let proof = Proof(axioms: axioms, theorems: theorems)
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "0=0")))
    XCTAssertFalse(proof.isProvable(formula: ExpressionTree(formula: "0=s0")))
  }
}
