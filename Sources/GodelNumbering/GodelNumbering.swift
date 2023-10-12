import ExpressionTree
import BinaryTree

enum Proposition: CustomDebugStringConvertible {
  init?(_ char: Character) {
    let output = CONSTANT_SIGNS(rawValue: char).map(Self.constant) ??
    NUMERICAL_VARIABLES(rawValue: char).map(Self.numerical) ??
    SENTNTIAL_VARIABLES(rawValue: char).map(Self.sentinential) ??
    PREDICATE_VARIABLES(rawValue: char).map(Self.predicate)
    
    if let output { self = output } else { return nil }
  }
  
  var debugDescription: String {
    switch self {
    case let .constant(value):
      return String(value.rawValue)
    case let .numerical(value):
      return String(value.rawValue)
    case let .sentinential(value):
      return String(value.rawValue)
    case let .predicate(value):
      return String(value.rawValue)
    }
  }
  
  case constant(CONSTANT_SIGNS)
  case numerical(NUMERICAL_VARIABLES)
  case sentinential(SENTNTIAL_VARIABLES)
  case predicate(PREDICATE_VARIABLES)
  
  var godelNumber: Int {
    switch self {
    case let .constant(val):
      return val.godelNumber
    case let .numerical(val):
      return val.godelNumber
    case let .sentinential(val):
      return val.godelNumber
    case let .predicate(val):
      return val.godelNumber
    }
  }
  
  enum CONSTANT_SIGNS: Character {
    case not = "~"
    case or = "∨"
    case if_then = "⊃"
    case there_is_an = "∃"
    case equals = "="
    case zero = "0"
    case the_successor_of = "s"
    case open_brace = "("
    case close_brace = ")"
    case comma = ","
    
    var godelNumber: Int {
      switch self {
      case .not:
        return 1
      case .or:
        return 2
      case .if_then:
        return 3
      case .there_is_an:
        return 4
      case .equals:
        return 5
      case .zero:
        return 6
      case .the_successor_of:
        return 7
      case .open_brace:
        return 8
      case .close_brace:
        return 9
      case .comma:
        return 10
      }
    }
  }
  
  public enum NUMERICAL_VARIABLES: Character {
    case x = "x", y = "y", z = "z"
    
    var godelNumber: Int {
      switch self {
      case .x:
        return 11
      case .y:
        return 13
      case .z:
        return 17
      }
    }
  }
  
  public enum SENTNTIAL_VARIABLES: Character {
    case p = "p", q = "q", r = "r"
    
    var godelNumber: Int {
      switch self {
      case .p:
        return 11*11
      case .q:
        return 13*13
      case .r:
        return 17*17
      }
    }
  }
  
  public enum PREDICATE_VARIABLES: Character {
    case P = "P", Q = "Q", R = "R"
    
    var godelNumber: Int {
      switch self {
      case .P:
        return 11*11*11
      case .Q:
        return 13*13*13
      case .R:
        return 17*17*17
      }
    }
  }
}

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
  
  public static func substitute(self: [Int], int: Int, proof: [Int]) -> ExpressionTree {
    ExpressionTree(self.map { exponential in
      int == exponential ? ExpressionTree(proof) : .leaf(.num(exponential))
    })
  }
  
  public static func selfSubstitute(self: [Int], int: Int) -> ExpressionTree {
    substitute(self: self, int: int, proof: self)
  }
}
