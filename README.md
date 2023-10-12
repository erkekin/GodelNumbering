# GodelNumbering
Godel numbering with Swift

This project is an experimentation on Godel Encoding. Project depends on my other toy swift packages under https://github.com/swift-tree, specifically `ExpressionTree`, which helped me deal with big numbers in this project. Fun stuff, have a look at the tests.

```swift
let godelNumber = ExpressionTree(formula: "(∃x)(x=sy)")
godelNumber.description

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
- https://www.godel-universe.com/godels-theorems/
- https://www.wired.com/story/how-godels-proof-works/
