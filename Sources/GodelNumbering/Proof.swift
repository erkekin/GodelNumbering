import ExpressionTree

struct Proof {
  let theorems: [ExpressionTree]

  func isProvable(formula: ExpressionTree) -> Bool {
    return theorems.contains(formula)
  }
}
