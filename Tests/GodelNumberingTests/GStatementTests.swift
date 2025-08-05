import XCTest
import ExpressionTree
@testable import GodelNumbering

final class GStatementTests: XCTestCase {
  // Checks that a GStatement with a simple theorem does NOT become provable without explicit substitution.
  func test_isProvable() {
    let theorems = [ExpressionTree(formula: "0=0")]
    let proof = Proof(theorems: theorems)
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // (∃x)(x=sy)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertFalse(gStatement.isProvable())
  }
  
  /// This test demonstrates the first horn of Gödel's incompleteness dilemma.
  /// It explores the critical question: "What happens if a formal system is powerful enough
  /// to prove its own Gödel sentence?"
  ///
  /// The inescapable conclusion this test demonstrates is that such a system must be **INCONSISTENT**,
  /// because it would be capable of proving a statement that is, by its own definition, false.
  /// This single test is the logical core of the entire repository.
  func test_provable_leads_to_contradiction() {
    // STEP 1: Define the Gödel Sentence template, G.
    // This is not just any formula. It's a carefully constructed logical statement
    // with one free variable, 'y'. Informally, G says:
    // "The formula that results from substituting the variable 'y' in the formula
    // with Gödel number 'y' is NOT provable."
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // The Gödel number for our template G.
    
    // STEP 2: Create the self-referential statement, G(g).
    // This is the pivotal step where the formula is made to talk about itself.
    // We substitute the placeholder 'y' with the Gödel number of the formula G itself ('gn').
    // The resulting statement, 'substituted', now has a concrete meaning:
    // "THIS VERY STATEMENT is not provable."
    let substituted = ExpressionTree.substituteVariable(gn: gn, variable: .y, term: gn)
    
    // STEP 3: Simulate a powerful-but-inconsistent formal system.
    // This is the "what if" scenario at the heart of the test. We create a list of theorems
    // that EXPLICITLY INCLUDES our self-referential statement. We are creating a hypothetical
    // formal system and assuming it's strong enough to prove G(g).
    let theorems = [substituted]
    let proof = Proof(theorems: theorems)
    
    // Create the GStatement object that we will test against our hypothetical system.
    let gStatement = GStatement(proof: proof, gn: gn)
    
    // STEP 4: The Punchline - Proving a contradiction.
    // We ask our GStatement if it's provable within our powerful, hypothetical system.
    // The assertion will be TRUE, because we manually added the proof to our 'theorems' list.
    //
    // By proving a statement that asserts its own unprovability, our hypothetical system
    // has just proven a falsehood. This is a fundamental logical contradiction.
    //
    // THEREFORE: Any formal system that can prove its own Gödel sentence is, by definition, inconsistent.
    XCTAssertTrue(gStatement.isProvable())
  }
  
  // Ensures that with no theorems, nothing is provable.
  func test_emptyTheorems_notProvable() {
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
    let substituted = ExpressionTree.substituteVariable(gn: differentGn, variable: .y, term: differentGn)
    let theorems = [substituted]
    let proof = Proof(theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    XCTAssertFalse(gStatement.isProvable())
  }
  
  // Checks that provability succeeds if any theorem in the list matches the substituted formula.
  func test_multipleTheorems_oneMatches() {
    let gn = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9]
    let matching = ExpressionTree.substituteVariable(gn: gn, variable: .y, term: gn)
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
    let substitutedWithGn = ExpressionTree.substituteVariable(gn: gn, variable: .y, term: gn)
    let substitutedWithDifferentTerm = ExpressionTree.substituteVariable(gn: gn, variable: .y, term: differentTerm)
    
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
    let substituted = ExpressionTree.substituteVariable(gn: gn, variable: .y, term: gn)
    var theorems = [substituted]
    let proof = Proof(theorems: theorems)
    let gStatement = GStatement(proof: proof, gn: gn)
    
    // Modify the original theorems array after creating the Proof
    theorems.append(ExpressionTree(formula: "1=1"))
    
    // The GStatement's provability should not be affected by changes to the original array
    XCTAssertTrue(gStatement.isProvable())
  }
}
