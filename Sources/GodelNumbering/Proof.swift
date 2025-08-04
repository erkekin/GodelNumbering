import ExpressionTree

public struct Proof {
  let axioms: [ExpressionTree]
  let theorems: [ExpressionTree]

  public func isProvable(formula: ExpressionTree) -> Bool {
    return theorems.contains(formula)
  }
}
