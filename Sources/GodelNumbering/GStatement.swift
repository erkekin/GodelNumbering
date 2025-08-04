import ExpressionTree

public struct GStatement {
  let proof: Proof
  let gn: [Int]

  public func isProvable() -> Bool {
    let substituted = ExpressionTree.sub(gn: gn, variable: .y, term: gn)
    return proof.isProvable(formula: substituted)
  }
}
