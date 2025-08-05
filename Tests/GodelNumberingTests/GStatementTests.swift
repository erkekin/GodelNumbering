import XCTest
import ExpressionTree
@testable import GodelNumbering

final class GStatementTests: XCTestCase {
  // Checks that a GStatement with a simple axiom and theorem does NOT become provable without explicit substitution.
  func test_isProvable() {
    let theorems = [ExpressionTree(formula: "0=0")]
    let proof = Proof(theorems: theorems)
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // (∃x)(x=sy)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertFalse(gStatement.isProvable())
  }

  // Checks that a GStatement is provable if the theorem list contains the substituted formula.
  func test_provable_leads_to_contradiction() {
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // (∃x)(x=sy)
    let substituted = ExpressionTree.sub(gn: gn, variable: .y, term: gn)
    let theorems = [substituted]
    let proof = Proof(theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertTrue(gStatement.isProvable())
  }
  
  // Ensures that with no axioms or theorems, nothing is provable.
  func test_emptyAxiomsAndTheorems_notProvable() {
    let theorems: [ExpressionTree] = []
    let proof = Proof(theorems: theorems)
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9]
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertFalse(gStatement.isProvable())
  }

  // Ensures that provability fails if the theorem does not match the expected substituted formula.
  func test_differentGodelNumbers_notProvable() {
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9]
    let differentGn = [1, 2, 3, 4]
    let substituted = ExpressionTree.sub(gn: differentGn, variable: .y, term: differentGn)
    let theorems = [substituted]
    let proof = Proof(theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertFalse(gStatement.isProvable())
  }

  // Checks that provability succeeds if any theorem in the list matches the substituted formula.
  func test_multipleTheorems_oneMatches() {
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9]
    let matching = ExpressionTree.sub(gn: gn, variable: .y, term: gn)
    let nonMatching = ExpressionTree(formula: "1=1")
    let theorems = [nonMatching, matching]
    let proof = Proof(theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertTrue(gStatement.isProvable())
  }

  // Validates that the result of provability depends on the specific substitution used.
  func test_substitution_affectsProvability() {
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9]
    let differentTerm = [1, 2, 3]
    let substitutedWithGn = ExpressionTree.sub(gn: gn, variable: .y, term: gn)
    let substitutedWithDifferentTerm = ExpressionTree.sub(gn: gn, variable: .y, term: differentTerm)
    
    let proof1 = Proof(theorems: [substitutedWithGn])
    let gStatement1 = GStatement(proof: proof1, gn: gn)
    XCTAssertTrue(gStatement1.isProvable())
    
    let proof2 = Proof(theorems: [substitutedWithDifferentTerm])
    let gStatement2 = GStatement(proof: proof2, gn: gn)
    XCTAssertFalse(gStatement2.isProvable())
  }

  // Ensures that modifying the original theorems array after creating the Proof does NOT retroactively affect existing GStatement results.
  func test_proofImmutability() {
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9]
    let substituted = ExpressionTree.sub(gn: gn, variable: .y, term: gn)
    var theorems = [substituted]
    let proof = Proof(theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    // Modify the original theorems array after creating the Proof
    theorems.append(ExpressionTree(formula: "1=1"))
    
    // The GStatement's provability should not be affected by changes to the original array
    XCTAssertTrue(gStatement.isProvable())
  }
}
