// =================================================================
// Assignment Template
// A lightweight Typst template for homework and course assignments.
// =================================================================


// -----------------------------------------------------------------
// Theme and Configuration
// -----------------------------------------------------------------

#let palette = (
  red: rgb("#FF0000"),
  green: rgb("#00FF00"),
  blue: rgb("#0000FF"),
  cyan: rgb("#02b9f1"),
  magenta: rgb("#FF00FF"),
  yellow: rgb("#FFFF00"),
  black: rgb("#000000"),
  gray: rgb("#808080"),
  white: rgb("#FFFFFF"),
  darkgray: rgb("#404040"),
  lightgray: rgb("#BFBFBF"),
  brown: rgb("#BF8040"),
  lime: rgb("#BFFF00"),
  olive: rgb("#808000"),
  orange: rgb("#FF8000"),
  pink: rgb("#FFBFBF"),
  purple: rgb("#BF0040"),
  teal: rgb("#008080"),
  violet: rgb("#800080"),
)

// Optional aliases
#let cyan = palette.cyan
#let teal = palette.teal
#let olive = palette.olive

#let _theme = state("assignment-template-theme", palette.orange)


// -----------------------------------------------------------------
// Public Blocks
// -----------------------------------------------------------------

#let problem(title: none, body) = context {
  let color = _theme.get()

  block(
    width: 100%,
    fill: color.lighten(85%),
    stroke: (left: 2pt + color),
    inset: (top: 0.5em, bottom: 0.5em, left: 1em, right: 1em),
    breakable: true,
    [
      #text(weight: "bold")[Problem #title]
      #parbreak()
      #body
    ],
  )
}

#let solution(body) = [
  #block(
    width: 100%,
    breakable: true,
    inset: (top: 0.5em, bottom: 0.5em),
    [
      #text(style: "italic", weight: "bold")[Solution:]
      #parbreak()
      #body
    ],
  )
  #v(0.5cm)
]

#let colorbox(color: gray, body) = block(
  width: 100%,
  fill: color.lighten(85%),
  stroke: (left: 2pt + color),
  inset: (x: 10pt, y: 6pt),
  breakable: true,
  body,
)


// -----------------------------------------------------------------
// Main Template
// -----------------------------------------------------------------

#let project(
  title: "",
  class: "",
  student: "",
  id: "",
  department: "",
  header-title: auto,
  header-right: auto,
  theme: palette.orange,
  body,
) = {
  let resolved-title = {
    if header-title == auto { title } else { header-title }
  }

  let resolved-right = {
    if header-right == auto {
      id + " " + student
    } else {
      header-right
    }
  }

  _theme.update(_ => theme)

  set document(
    title: title,
    author: (student,),
  )

  set page(
    paper: "a4",
    margin: 2cm,
    numbering: "1",
    number-align: center,
    header: context [
      #set text(size: 12pt)
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [#resolved-title], [#resolved-right],
      )
      #line(length: 100%, stroke: 0.4pt + black)
    ],
  )

  set text(
    font: ("New Computer Modern", "黑體-繁", "Noto Sans CJK TC"),
    size: 12pt,
  )

  show math.equation: set text(weight: 400)
  show raw: set text(font: "New Computer Modern Mono")

  set par(
    leading: 0.65em,
    spacing: 0.6em,
    justify: true,
  )

  set heading(numbering: "1.1")

  align(center)[
    #text(size: 15pt, weight: "bold")[#class]
    #v(1em)
    #text(size: 18pt, weight: "bold")[#title]
  ]

  v(2em)

  table(
    columns: (auto, 1fr),
    inset: 2pt,
    stroke: none,
    column-gutter: 0.8em,
    [*Student:*], [#student],
    [*ID:*], [#id],
    [*Department:*], [#department],
  )

  v(1em)

  body
}
