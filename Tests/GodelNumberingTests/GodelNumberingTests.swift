import XCTest
import ExpressionTree
@testable import GodelNumbering

final class GodelNumberingTests: XCTestCase {
  private var tree: ExpressionTree!
  
  override func setUp() {
    super.setUp()
    tree = ExpressionTree("* ^ 2 3 ^ 3 2")
  }
  
  override func tearDown() {
    tree = nil
    super.tearDown()
  }
  
  func test_hasPrefix_simple() {
    let tree = ExpressionTree("^ 2 3")
    
    XCTAssertTrue(tree.hasPrefix(factor: tree))
  }
  
  func test_hasPrefix() {
    let left = ExpressionTree("^ 2 3")
    let right = ExpressionTree("^ 3 2")
    
    XCTAssertTrue(tree.hasPrefix(factor: left))
    XCTAssertTrue(tree.hasPrefix(factor: right))
  }
  
  func test_hasPrefix_complex() {
    let tree = ExpressionTree("* * * ^ 2 3 ^ 3 2 ^ 5 4 ^ 7 1")
    let _7 = ExpressionTree("^ 7 1")
    let _2 = ExpressionTree("^ 2 3")
    let _3 = ExpressionTree("^ 3 2")
    let _5 = ExpressionTree("^ 5 4")
    
    let _2and3 = tree
    
    XCTAssertTrue(tree.hasPrefix(factor: _7))
    XCTAssertTrue(tree.hasPrefix(factor: _2))
    XCTAssertTrue(tree.hasPrefix(factor: _3))
    XCTAssertTrue(tree.hasPrefix(factor: _5))
    XCTAssertTrue(tree.hasPrefix(factor: _2and3))
  }
  
  func test_complex_hasPrefix() {
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
  
  func test_substitute() {
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

  func test_sub() {
    let formula = [8, 4, 11, 9, 8, 11, 5, 7, 13, 9] // (∃x)(x=sy)
    let term = [6] // 0
    let expected = ExpressionTree(formula: "(∃x)(x=s0)")
    let actual = ExpressionTree.sub(gn: formula, variable: .y, term: term)
    XCTAssertEqual(actual, expected)
  }
  
  func test_proof() {
    let tree1 = ExpressionTree([
      ExpressionTree("* ^ 2 1 ^ 3 1"),
      ExpressionTree("* ^ 2 2 ^ 3 2"),
      ExpressionTree("* ^ 2 3 ^ 3 3")
    ])
    
    let tree2 = ExpressionTree(
      ExpressionTree([1, 1]),
      ExpressionTree([2, 2]),
      ExpressionTree([3, 3])
    )
    
    XCTAssertEqual(tree1, tree2)
    
    XCTAssertTrue(tree1.hasPrefix(factor: ExpressionTree(
      ExpressionTree([1, 1]),
      ExpressionTree([2, 2]),
      ExpressionTree([3, 3])
    )))
    XCTAssertTrue(tree1.hasPrefix(factor: ExpressionTree(
      ExpressionTree([1, 1]),
      ExpressionTree([2, 2])
    )))
    XCTAssertTrue(tree1.hasPrefix(factor: ExpressionTree(
      ExpressionTree([1, 1])
    )))
    XCTAssertTrue(tree1.hasPrefix(factor: ExpressionTree("^ 5 * ^ 2 3 ^ 3 3")))
  }
  
  func test_formula_zero_equals_zero() {
    XCTAssertEqual(ExpressionTree(formula: "0=0").evaluate, 243_000_000)
  }
  
  func test_formula1_no_arithmetic_overflow() async throws {
    tree = ExpressionTree(formula: "(∃x)(x=sy)")
    
    XCTAssertEqual(tree, ExpressionTree([8, 4, 11, 9, 8, 11, 5, 7, 13, 9]))
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(tree)
    
    XCTAssertNotNil(String(data: data, encoding: .utf8))
  }
  
  func test_can_encode() async throws {
    tree = ExpressionTree(formula: "(∃x)(x=sy)")
    let encoder = JSONEncoder()
    let data = try encoder.encode(tree)
    
    XCTAssertNotNil(String(data: data, encoding: .utf8))
  }
}

import BinaryTree

extension ExpressionTree where Descendent == BinaryChildren<Token>  {
  init(_ trees: ExpressionTree ...) {
    self = .init(trees)
  }
}
