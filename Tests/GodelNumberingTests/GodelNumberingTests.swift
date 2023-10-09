import XCTest
import ExpressionTree
@testable import GodelNumbering

final class GodelNumberingTests: XCTestCase {
  
  func test_hasFactorSimple() {
    let tree = ExpressionTree("^ 2 3")
    
    XCTAssertTrue(tree.hasPrefix(factor: tree))
  }
  
  func test_hasFactor() {
    let tree = ExpressionTree("* ^ 2 3 ^ 3 2")
    let left = ExpressionTree("^ 2 3")
    let right = ExpressionTree("^ 3 2")
    
    XCTAssertTrue(tree.hasPrefix(factor: left))
    XCTAssertTrue(tree.hasPrefix(factor: right))
  }
  
  func test_hasFactorComplex() {
    let tree = ExpressionTree("* * * ^ 2 3 ^ 3 2 ^ 5 4 ^ 7 1")
    let _7 = ExpressionTree("^ 7 1")
    let _2 = ExpressionTree("^ 2 3")
    let _3 = ExpressionTree("^ 3 2")
    let _5 = ExpressionTree("^ 5 4")
    
    let _2and3 = ExpressionTree("* ^ 2 3 ^ 3 2")
    
    XCTAssertTrue(tree.hasPrefix(factor: _7))
    XCTAssertTrue(tree.hasPrefix(factor: _2))
    XCTAssertTrue(tree.hasPrefix(factor: _3))
    XCTAssertTrue(tree.hasPrefix(factor: _5))
    XCTAssertTrue(tree.hasPrefix(factor: _2and3))
  }
  
  func test_build() {
    let tree = ExpressionTree("* * * * * * * * * ^ 2 8 ^ 3 4 ^ 5 13 ^ 7 9 ^ 11 8 ^ 13 13 ^ 17 5 ^ 19 7 ^ 23 17 ^ 29 9")
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 2 8")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 3 4")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 5 13")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 7 9")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 11 8")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 13 13")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 17 5")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 19 7")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 23 17")))
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 29 9")))
    
    XCTAssertEqual(tree, ExpressionTree([8, 4, 13, 9, 8, 13, 5, 7, 17, 9]))
  }
  
  func test_sub() {
    let expected_substituted3_to_self = ExpressionTree("* ^ 2 * ^ 2 3 ^ 3 2 ^ 3 2")
    let actual = ExpressionTree.substitute(self: [3, 2], int: 3, proof: [3, 2])
    
    XCTAssertEqual(actual, expected_substituted3_to_self)
  }
  
  func test_complex_selfSubstitute() {
    let expected = ExpressionTree("""
* * * * * * * * * ^ 2 8 ^ 3 4 ^ 5 13 ^ 7 9 ^ 11 8 ^ 13 13 ^ 17 5 ^ 19 7 ^ 23 \
* * * * * * * * * ^ 2 8 ^ 3 4 ^ 5 13 ^ 7 9 ^ 11 8 ^ 13 13 ^ 17 5 ^ 19 7 ^ 23 17 ^ 29 9 \
^ 29 9
"""
    )
    
    let actual = ExpressionTree.selfSubstitute(self: [8, 4, 13, 9, 8, 13, 5, 7, 17, 9], int: 17)
    
    XCTAssertEqual(actual, expected)
  }
  
  func test_proof() {
    let tree = ExpressionTree([
      ExpressionTree("* ^ 2 1 ^ 3 1"),
      ExpressionTree("* ^ 2 2 ^ 3 2"),
      ExpressionTree("* ^ 2 3 ^ 3 3")
    ])
    
    XCTAssertTrue(tree.hasPrefix(factor: ExpressionTree("^ 2 * ^ 2 1 ^ 3 1")))
  }
}
