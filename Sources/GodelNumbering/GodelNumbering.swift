import ExpressionTree
import BinaryTree

extension ExpressionTree where Descendent == BinaryChildren<Token>  {
  static let primesBig: [Int] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
  
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
  
  public init(formula: String) {
    self = ExpressionTree(
      formula
      .compactMap(Proposition.init)
      .map(\.godelNumber)
    )
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
  
  static func substituteNumberWithFormulaEncoding(self: [Int], int: Int, proof: [Int]) -> ExpressionTree {
    ExpressionTree(self.map { exponential in
      int == exponential ? ExpressionTree(proof) : .leaf(.num(exponential))
    })
  }
  
  static func selfSubstitute(self: [Int], int: Int) -> ExpressionTree {
    substituteNumberWithFormulaEncoding(self: self, int: int, proof: self)
  }

  static func substituteVariable(gn: [Int], variable: Proposition.NUMERICAL_VARIABLES, term: [Int]) -> ExpressionTree {
    let newGN = gn.flatMap { $0 == variable.godelNumber ? term : [$0] }
    return ExpressionTree(newGN)
  }
}
