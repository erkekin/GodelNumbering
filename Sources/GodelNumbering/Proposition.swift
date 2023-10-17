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
