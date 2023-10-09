import ExpressionTree
import BinaryTree

extension ExpressionTree where Descendent == BinaryChildren<Token>  {
  private static let primesBig: [Int] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
  
  fileprivate static func subst(_ expresions: [ExpressionTree]) -> ExpressionTree {
    var treeFactors = Array(expresions.enumerated())
    let firstFactor = treeFactors.removeFirst()
    let firstFactorTree = ExpressionTree.node(value: .funct(.exponential), .init(.leaf(.num(Self.primesBig[firstFactor.offset])), firstFactor.element))

    return treeFactors
      .map{ index, exponential in
          .node(value: .funct(.exponential), .init(.leaf(.num(Self.primesBig[index])), exponential))
      }
      .reduce(firstFactorTree) { partialResult, tree in
          .node(value: .funct(.multiply), .init(partialResult, tree))
      }
  }

  public init(_ exponentials: [Int]) {
    self = ExpressionTree(exponentials.map{ ExpressionTree.leaf(.num($0)) })
  }
  
  public init( _ exponentials: [ExpressionTree]) {
    var factors = Array(exponentials.enumerated())
    let firstFactor = factors.removeFirst()
    let firstFactorTree = ExpressionTree.node(value: .funct(.exponential), .init(.leaf(.num(Self.primesBig[firstFactor.offset])), firstFactor.element))
    
    self = factors
      .map{ index, exponential in
          .node(value: .funct(.exponential), .init(.leaf(.num(Self.primesBig[index])), exponential))
      }
      .reduce(firstFactorTree) { partialResult, tree in
          .node(value: .funct(.multiply), .init(partialResult, tree))
      }
  }
  
  func hasPrefix(factor branch: ExpressionTree) -> Bool {
    guard self != branch else { return true }
    guard case .funct(.multiply) = value, let descendent = descendent else { return false }
    switch descendent {
    case .init(branch, descendent.right), .init(descendent.left, branch):
      return true
      
    default:
      if descendent.left.hasPrefix(factor: branch) { return true }
      if descendent.right.hasPrefix(factor: branch) { return true }
      return false
    }
  }
  
  public static func substitute(self: [Int], int: Int, proof: [Int]) -> ExpressionTree {
    let expressions: [ExpressionTree] = self.map { exponential in
      int == exponential ? ExpressionTree(proof) : .leaf(.num(exponential))
    }
    
    return ExpressionTree.subst(expressions)
  }
  
  public static func selfSubstitute(self: [Int], int: Int) -> ExpressionTree {
    let expressions: [ExpressionTree] = self.map { exponential in
      int == exponential ? ExpressionTree(self) : .leaf(.num(exponential))
    }
    
    return ExpressionTree.subst(expressions)
  }
}

