#import "../template.typ": *

#show: project.with(
  title: "Homework 1",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 1",
  theme: palette.cyan,
)

#import "@preview/zebraw:0.6.1": *
#show: zebraw.with(copy-button: true, lang: true)

// -------------------------------------------------------
//                     Start here
// -------------------------------------------------------

#problem(title: "1.(a)")[
  test
]

#solution()[
  這裡是解答。
]

#colorbox(color: palette.teal)[
  補充說明。
]


#lorem(51)

#v(1.5em)
```rust
pub fn main() {
    println!("Hello, world!");
}
```
