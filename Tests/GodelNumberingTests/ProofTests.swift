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
  
  func test_isProvable_withLongerFormulas() {
    let axioms = [
      ExpressionTree(formula: "0=0"),
      ExpressionTree(formula: "s(0)=s(0)"),
      ExpressionTree(formula: "0+0=0"),
      ExpressionTree(formula: "s(0)+0=s(0)"),
      ExpressionTree(formula: "0=0∧s(0)=s(0)")
    ]
    let theorems = axioms
    let proof = Proof(axioms: axioms, theorems: theorems)
    
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "0=0")))
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "s(0)=s(0)")))
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "0+0=0")))
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "s(0)+0=s(0)")))
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "0=0∧s(0)=s(0)")))
    
    XCTAssertFalse(proof.isProvable(formula: ExpressionTree(formula: "0=s(0)")))
    XCTAssertFalse(proof.isProvable(formula: ExpressionTree(formula: "s(0)=0")))
    XCTAssertFalse(proof.isProvable(formula: ExpressionTree(formula: "0+0=s(0)")))
    XCTAssertFalse(proof.isProvable(formula: ExpressionTree(formula: "0=0∨0=s(0)")))
  }
}
