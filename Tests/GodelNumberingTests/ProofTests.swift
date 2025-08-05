import XCTest
import ExpressionTree
@testable import GodelNumbering

final class ProofTests: XCTestCase {
  func test_isProvable() {
    let theorems = [ExpressionTree(formula: "0=0")]
    let proof = Proof(theorems: theorems)
    
    XCTAssertTrue(proof.isProvable(formula: ExpressionTree(formula: "0=0")))
    XCTAssertFalse(proof.isProvable(formula: ExpressionTree(formula: "0=s0")))
  }
  
  func test_isProvable_withLongerFormulas() {
      // --- Provable Theorems ---
      let zeroEqualsZero = ExpressionTree(formula: "0=0")                     // "Zero equals zero." A basic axiom of equality.
      let successorOfZeroEqualsSuccessorOfZero = ExpressionTree(formula: "s(0)=s(0)") // "The successor of zero equals the successor of zero" (i.e., 1=1).
      let zeroPlusZeroEqualsZero = ExpressionTree(formula: "0+0=0")           // "Zero plus zero equals zero." A base case for addition.
      let successorOfZeroPlusZero = ExpressionTree(formula: "s(0)+0=s(0)")    // "The successor of zero plus zero equals the successor of zero" (i.e., 1+0=1).
      let conjunctionOfTruths = ExpressionTree(formula: "0=0∧s(0)=s(0)")      // "Zero equals zero AND the successor of zero equals the successor of zero."

      // --- Unprovable Statements ---
      let zeroEqualsSuccessorOfZero = ExpressionTree(formula: "0=s(0)")       // "Zero equals the successor of zero" (i.e., 0=1).
      let successorOfZeroEqualsZero = ExpressionTree(formula: "s(0)=0")       // "The successor of zero equals zero" (i.e., 1=0).
      let zeroPlusZeroEqualsSuccessorOfZero = ExpressionTree(formula: "0+0=s(0)") // "Zero plus zero equals the successor of zero" (i.e., 0+0=1).
      let disjunctionWithFalsehood = ExpressionTree(formula: "0=0∨0=s(0)")    // "Zero equals zero OR zero equals the successor of zero."

      // The list of statements that are considered "provable" for this test.
      let theorems = [
          zeroEqualsZero,
          successorOfZeroEqualsSuccessorOfZero,
          zeroPlusZeroEqualsZero,
          successorOfZeroPlusZero,
          conjunctionOfTruths
      ]
      
      // In this simplified system, a "proof" is just a list of established theorems.
      let proof = Proof(theorems: theorems)

      // Verify that the established theorems are provable.
      XCTAssertTrue(proof.isProvable(formula: zeroEqualsZero))
      XCTAssertTrue(proof.isProvable(formula: successorOfZeroEqualsSuccessorOfZero))
      XCTAssertTrue(proof.isProvable(formula: zeroPlusZeroEqualsZero))
      XCTAssertTrue(proof.isProvable(formula: successorOfZeroPlusZero))
      XCTAssertTrue(proof.isProvable(formula: conjunctionOfTruths))
      
      // Verify that statements not in the theorems list are not provable.
      XCTAssertFalse(proof.isProvable(formula: zeroEqualsSuccessorOfZero))
      XCTAssertFalse(proof.isProvable(formula: successorOfZeroEqualsZero))
      XCTAssertFalse(proof.isProvable(formula: zeroPlusZeroEqualsSuccessorOfZero))
      XCTAssertFalse(proof.isProvable(formula: disjunctionWithFalsehood))
  }
}
