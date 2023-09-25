import XCTest
import ExpressionTree
@testable import GodelNumbering

final class GodelNumberingTests: XCTestCase {

  func test_hasFactorSimple() {
    let tree = ExpressionTree(prefixExpression: "^ 2 3")
    
    XCTAssertTrue(tree.has(factor: tree))
  }

  func test_hasFactor() {
    let tree = ExpressionTree(prefixExpression: "* ^ 2 3 ^ 3 2")
    let left = ExpressionTree(prefixExpression: "^ 2 3")
    let right = ExpressionTree(prefixExpression: "^ 3 2")
    
    XCTAssertTrue(tree.has(factor: left))
    XCTAssertTrue(tree.has(factor: right))
  }

  func test_hasFactorComplex() {
    let tree = ExpressionTree(prefixExpression: "* * * ^ 2 3 ^ 3 2 ^ 5 4 ^ 7 1")
    let _7 = ExpressionTree(prefixExpression: "^ 7 1")
    let _2 = ExpressionTree(prefixExpression: "^ 2 3")
    let _3 = ExpressionTree(prefixExpression: "^ 3 2")
    let _5 = ExpressionTree(prefixExpression: "^ 5 4")
    
    let _2and3 = ExpressionTree(prefixExpression: "* ^ 2 3 ^ 3 2")
    
    XCTAssertTrue(tree.has(factor: _7))
    XCTAssertTrue(tree.has(factor: _2))
    XCTAssertTrue(tree.has(factor: _3))
    XCTAssertTrue(tree.has(factor: _5))
    
    XCTAssertTrue(tree.has(factor: _2and3))
  }

}
