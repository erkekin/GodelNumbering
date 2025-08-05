# Gödel's Incompleteness Theorem in Swift

This repository is a Swift implementation demonstrating the core concepts behind one of the most profound results in mathematical logic: **Kurt Gödel's First Incompleteness Theorem**.

It's not a formal proof, but rather a programmatic exploration of how a system of logic can give rise to a statement that is true but unprovable within that same system.

---

## The Journey to Gödel 🧠

My fascination with this theorem has been a long and winding road. It began with a practical interest in **functional programming**, which naturally led me down the rabbit hole of **Type Theory**. From there, I became intrigued by the structure of proofs themselves and jumped into **Gentzen's Proof Theory**.

Eventually, every path seemed to lead back to Gödel.

This journey brought me back to a book on Gödel's proof I had bought over a decade ago. When I first tried to read it, I understood almost nothing. But after exploring these related fields, the pieces finally started to click into place. The abstract concepts of logic, provability, and self-reference began to feel concrete, almost like components in a system I could build.

This project is the result of that "aha!" moment—an attempt to translate the theorem's elegant, abstract machinery into working Swift code.

---

## Technical Approach: Handling Immense Numbers

A central challenge in implementing Gödel's proof is representing the "Gödel numbers" themselves. These numbers, which uniquely encode formulas and proofs, can become astronomically large, far exceeding the capacity of standard 64-bit integers.

To solve this, I used `ExpressionTree`, a custom data structure I had previously developed for symbolic mathematics.

Instead of calculating a number like `$2^{5} \times 3^{8} \times 5^{13}$` into a single, massive integer, `ExpressionTree` holds it as a symbolic tree of operations. This allows the program to reason about these numbers, compare them, and perform substitutions without ever needing to compute their final, unwieldy values.

---

## How It Works: Key Components

The repository is split into a few key components that mirror the structure of Gödel's proof:

* **`Proposition.swift`**: Defines the symbols of our formal language (`~`, `∨`, `∃`, `=`, `x`, `y`, etc.) and assigns each a unique Gödel number.
* **`GodelNumbering.swift`**: Contains the logic for taking a sequence of symbols (a formula) and encoding it into an `ExpressionTree`. It also handles the crucial mechanism of substitution.
* **`GStatement.swift`**: Represents the self-referential Gödel sentence, "G," which asserts its own unprovability. This is where the magic of self-reference is implemented.
* **`GStatementTests.swift`**: This is where the theorem is truly demonstrated. The unit tests act as a simulation of a formal system, exploring the consequences of a system being able to prove (or not prove) its own Gödel sentence.

---

## The Punchline: The Core Demonstration

The heart of this project can be found in a single unit test:

**`test_provable_leads_to_contradiction()`**

This test programmatically demonstrates that any formal system capable of proving the Gödel sentence must be **inconsistent** (i.e., it can prove a falsehood). The other tests in the suite demonstrate the alternative: if the system is **consistent**, then it must be **incomplete**, because the Gödel sentence is a true statement that it cannot prove.
