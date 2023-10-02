import ExpressionTree
import BinaryTree

extension ExpressionTree where Descendent == BinaryChildren<Token>  {
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
}

