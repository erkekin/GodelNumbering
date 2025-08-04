# Unraveling Gödel's Incompleteness with Swift: A Deep Dive

## Introduction: The Limits of Logic

Kurt Gödel's incompleteness theorems are monumental results in mathematical logic that fundamentally changed our understanding of formal systems. In essence, they state that any consistent axiomatic system powerful enough to describe arithmetic will inevitably contain true statements that cannot be proven within the system itself. Furthermore, such a system cannot prove its own consistency.

This project, "GodelNumbering," is a Swift-based exploration and implementation of the core concepts behind Gödel's first incompleteness theorem. It aims to provide a tangible, code-driven demonstration of how a self-referential statement can be constructed within a formal system, leading to the profound implications of incompleteness.

## Project Overview

"GodelNumbering" is a Swift package that allows for the encoding of logical propositions into Gödel numbers, performing substitutions on these numbered formulas, and constructing a simplified "proof system" to explore the concept of provability. The project leverages the `ExpressionTree` library (from the `swift-tree` ecosystem) to handle the symbolic manipulation and large number arithmetic required for Gödel numbering.

The primary goal is to illustrate the construction of the famous Gödel sentence (G), a statement that, within its own system, asserts its unprovability.

## Key Components Explained

### 1. `Proposition.swift`: The Language of Numbers

At the heart of Gödel numbering is the idea of mapping every symbol and formula in a formal language to a unique integer. In `Proposition.swift`, we define the basic building blocks of our formal language and assign them their respective Gödel numbers.

```swift
enum Proposition: CustomDebugStringConvertible {
  // ... (init, debugDescription, cases)

  var godelNumber: Int {
    switch self {
    case let .constant(val):
      return val.godelNumber
    case let .numerical(val):
      return val.godelNumber
    // ...
    }
  }

  enum CONSTANT_SIGNS: Character {
    case not = "~" // Gödel number 1
    case or = "∨"  // Gödel number 2
    // ...
    case equals = "=" // Gödel number 5
    case zero = "0" // Gödel number 6
    case the_successor_of = "s" // Gödel number 7
    // ...
  }

  public enum NUMERICAL_VARIABLES: Character {
    case x = "x" // Gödel number 11
    case y = "y" // Gödel number 13
    case z = "z" // Gödel number 17
  }
  // ... other variable types
}
```

Each symbol (like `~` for negation, `=` for equality, `0` for zero, `s` for successor, and variables like `x`, `y`, `z`) is assigned a unique Gödel number. This allows us to represent entire formulas as sequences of integers.

### 2. `GodelNumbering.swift`: Encoding and Substitution

This file contains the core logic for working with Gödel numbers and performing crucial operations.

*   **Formula Encoding:** The `ExpressionTree` extension provides initializers to convert a string representation of a formula (e.g., `"(∃x)(x=sy)"`) into its corresponding Gödel number sequence.

*   **`sub` Function (Substitution):** This is a critical component for Gödel's proof. The `sub` function allows us to substitute a specific variable within a Gödel-numbered formula with another term (also represented by its Gödel number).

    ```swift
    public static func sub(gn: [Int], variable: Proposition.NUMERICAL_VARIABLES, term: [Int]) -> ExpressionTree {
      let newGN = gn.flatMap { $0 == variable.godelNumber ? term : [$0] }
      return ExpressionTree(newGN)
    }
    ```
    Here, `gn` is the Gödel number of the formula, `variable` is the numerical variable to be replaced (e.g., `y`), and `term` is the Gödel number of the term to substitute in. The use of `Proposition.NUMERICAL_VARIABLES` for the `variable` parameter ensures type safety and clarity, avoiding magic numbers.

### 3. `Proof.swift`: A Simplified Proof System

To demonstrate incompleteness, we need a concept of "provability." `Proof.swift` introduces a simplified system where we define a set of `axioms` and `theorems`.

```swift
public struct Proof {
  let axioms: [ExpressionTree]
  let theorems: [ExpressionTree]

  public func isProvable(formula: ExpressionTree) -> Bool {
    return theorems.contains(formula)
  }
}
```
In this simplified model, a formula is considered "provable" if it exists within the `theorems` list. While a real proof system involves inference rules, this abstraction is sufficient to illustrate the core concept for Gödel's theorem.

### 4. `GStatement.swift`: The Self-Referential Sentence

This is where all the pieces come together to construct the Gödel sentence (G). The G-statement is a formula that, when interpreted, asserts its own unprovability.

```swift
public struct GStatement {
  let proof: Proof
  let gn: [Int] // The Gödel number of the formula G

  public func isProvable() -> Bool {
    let y = Proposition.NUMERICAL_VARIABLES.y.godelNumber // Get Gödel number for 'y'
    let substituted = ExpressionTree.sub(gn: gn, variable: .y, term: gn) // Substitute 'y' with G's own Gödel number
    return proof.isProvable(formula: substituted)
  }
}
```
The `isProvable()` method within `GStatement` is crucial. It constructs the self-referential statement by substituting the Gödel number of the formula `gn` itself for the variable `y` within the formula. Then, it checks if this resulting self-referential statement is "provable" within the given `proof` system.

## Demonstrating Incompleteness

The power of Gödel's theorem lies in the contradictions that arise when we assume the provability or disprovability of the G-statement. The project's tests (`GStatementTests.swift`) illustrate this:

1.  **If G is Provable, it Leads to a Contradiction:**
    If we assume that the G-statement *is* provable (i.e., we add its self-substituted form to our `theorems` list), then `gStatement.isProvable()` will return `true`. But by its very construction, G states that it is *not* provable. This creates a direct contradiction.

2.  **If Not-G is Provable, it Also Leads to a Contradiction:**
    Similarly, if we assume that the negation of G (`~G`) is provable, it also leads to a contradiction. If `~G` is provable, then G must be false (i.e., G *is* provable). But if G is provable, we're back to the first contradiction.

These tests highlight that within a consistent system, the G-statement cannot be both provable and unprovable, nor can its negation be provable without leading to a contradiction. Therefore, G must be a true statement that is unprovable within the system, demonstrating incompleteness.

## Theoretical Nuances: The Finiteness Debate

While this project adheres to the conventional understanding of Gödel's proof, it's important to acknowledge deeper theoretical discussions. For instance, the paper "[On the Gödel’s formula](https://arxiv.org/pdf/math/0104025.pdf)" by Jailton C. Ferreira (arXiv:math/0104025v9) raises questions about whether the Gödel number of the self-referential formula G is truly finite under all conditions. Ferreira argues that if G is genuinely self-referential, or if there's an infinite set of provable formulas, the traditional construction might lead to a scenario where G's Gödel number cannot be finite without logical inconsistencies. This project, for practical demonstration, operates under the standard assumption of finiteness, but these discussions underscore the profound and sometimes counter-intuitive nature of Gödel's work.

## How to Run This Project

To explore this project yourself, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/erkekin/GodelNumbering.git
    cd GodelNumbering
    ```

2.  **Run the Tests:**
    The project includes a comprehensive suite of XCTest cases that demonstrate the Gödel numbering, substitution, and the core incompleteness arguments.
    ```bash
    swift test
    ```
    You should see all tests pass, including those in `GStatementTests.swift` that illustrate the contradictions.

3.  **Explore the Code:**
    Dive into the `Sources/GodelNumbering` directory to see the implementations of `Proposition.swift`, `GodelNumbering.swift`, `Proof.swift`, and `GStatement.swift`.

## Conclusion

This Swift project provides a hands-on way to understand the intricate mechanics behind Gödel's first incompleteness theorem. By encoding logical statements into numbers and constructing a self-referential formula, we can observe how even in a seemingly complete system, there exist truths that lie beyond its provable reach. This journey into the limits of formal systems continues to be a source of fascination and profound insight in mathematics, logic, and computer science.
