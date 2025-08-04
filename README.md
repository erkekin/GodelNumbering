# GodelNumbering
Godel numbering with Swift

This project is an experimentation on Godel Encoding. Project depends on my other toy swift packages under https://github.com/swift-tree, specifically `ExpressionTree`, which helped me deal with big numbers in this project. Fun stuff, have a look at the tests.

```swift
let godelNumber = ExpressionTree(formula: "(∃x)(x=sy)")
print(godelNumber.description)

        ┌── 9
    ┌── ^
        └── 29
┌── *
    │       ┌── 13
    │   ┌── ^
    │       └── 23
    └── *
    │   │       ┌── 7
    │   │   ┌── ^
    │   │       └── 19
    │   └── *
    │   │   │       ┌── 5
    │   │   │   ┌── ^
    │   │   │       └── 17
    │   │   └── *
    │   │   │   │       ┌── 11
    │   │   │   │   ┌── ^
    │   │   │   │       └── 13
    │   │   │   └── *
    │   │   │   │   │       ┌── 8
    │   │   │   │   │   ┌── ^
    │   │   │   │   │       └── 11
    │   │   │   │   └── *
    │   │   │   │   │   │       ┌── 9
    │   │   │   │   │   │   ┌── ^
    │   │   │   │   │   │       └── 7
    │   │   │   │   │   └── *
    │   │   │   │   │   │   │       ┌── 11
    │   │   │   │   │   │   │   ┌── ^
    │   │   │   │   │   │   │       └── 5
    │   │   │   │   │   │   └── *
    │   │   │   │   │   │   │   │       ┌── 4
    │   │   │   │   │   │   │   │   ┌── ^
    │   │   │   │   │   │   │   │       └── 3
    │   │   │   │   │   │   │   └── *
    │   │   │   │   │   │   │   │   │   ┌── 8
    │   │   │   │   │   │   │   │   └── ^
    │   │   │   │   │   │   │   │   │   └── 2
```


Trying to prove here, that axiomatic set of proofs are not complete and consistent at the same time. That is, that famous statement: "This statement is false."

See these papers and posts to get more information.

- https://arxiv.org/pdf/math/0104025.pdf
- https://www.wired.com/story/how-godels-proof-works/

## A Note on the Gödel Formula's Finiteness

This project, like most standard presentations of Gödel's incompleteness theorems, assumes that the Gödel number of any well-formed formula, including the self-referential Gödel sentence (G), is a finite integer. This assumption is fundamental to the construction of G, where the formula refers to its own Gödel number.

However, it's worth noting that there are alternative perspectives on this aspect of Gödel's proof. For instance, the paper "[On the Gödel’s formula](https://arxiv.org/pdf/math/0104025.pdf)" by Jailton C. Ferreira (arXiv:math/0104025v9) argues that the Gödel number of the formula G might not be a finite number under certain conditions.

Ferreira's argument suggests that if G is comprehended as a self-referential statement, or if there's an infinite set of provable well-formed formulas with one free variable, then the traditional construction of G leads to a contradiction regarding the finiteness of its Gödel number. Specifically, he posits that the "name" (Gödel number) of the formula, when constructed to be self-referential, would necessarily be smaller than the formula it represents, leading to an infinite regress or an unresolvable size discrepancy.

While this project adheres to the conventional understanding for practical implementation and demonstration of the core theorem, it's important to acknowledge these deeper theoretical discussions that explore the foundational assumptions of Gödel's groundbreaking work.
