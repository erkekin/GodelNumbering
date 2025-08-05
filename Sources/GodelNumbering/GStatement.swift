import ExpressionTree

struct GStatement {
  let proof: Proof
  let gn: [Int]

  func isProvable() -> Bool {
    let substituted = ExpressionTree.substituteVariable(gn: gn, variable: .y, term: gn)
    return proof.isProvable(formula: substituted)
  }
}
