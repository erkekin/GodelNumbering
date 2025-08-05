import ExpressionTree

struct Proof {
  let theorems: [ExpressionTree]

  func isProvable(formula: ExpressionTree) -> Bool {
    theorems.contains(formula)
  }
}
