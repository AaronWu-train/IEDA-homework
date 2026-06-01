#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/wavy:0.1.3"
#import "@preview/algorithmic:1.0.7"
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))
#show raw.where(lang: "wavy"): it => wavy.render(it.text)

#show: project.with(
  title: "Homework 3",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 3",
  theme: palette.gray,
)

#set heading(numbering: (
  (..args) => {
    let nums = args.pos()
    if nums.len() == 1 {
      [#numbering("1", ..nums) #h(0.6em)]
    } else if nums.len() == 2 {
      [#numbering("1", nums.first()). (#numbering("a", nums.last())) #h(0.6em)]
    } else {
      [#h(-0.4em)]
    }
  }
))

// -------------------------------------------------------
//                       Start here
// -------------------------------------------------------

// ---------------------- Problem 1 ----------------------
= BDD Operation

== // 1. (a)
#columns(1)[
  #set text(size: 10pt)
  $
    & "robdd_build"(a b(¬c + d) + (a¬b + ¬a b)(c¬d + ¬c d), 1) \
    & arrow.r.long^(eta) "robdd_build"(b(¬c + d) + ¬b(c¬d + ¬c d), 2) \
    & #h(2em) arrow.r.long^(eta) "robdd_build"(¬c + d, 3) \
    & #h(2em) #h(2em) arrow.r.long^(eta) "robdd_build"(d, 4) \
    & #h(2em) #h(2em) #h(2em) arrow.r.long^(eta) "robdd_build"(1, 5) \
    & #h(2em) #h(2em) #h(2em) #h(2em) v_1 \
    & #h(2em) #h(2em) #h(2em) arrow.r.long^(lambda) "robdd_build"(0, 5) \
    & #h(2em) #h(2em) #h(2em) #h(2em) v_0 \
    & #h(2em) #h(2em) #h(2em) v_2 = (d, v_1, v_0) \
    & #h(2em) #h(2em) arrow.r.long^(lambda) "robdd_build"(1, 4) \
    & #h(2em) #h(2em) #h(2em) v_1 \
    & #h(2em) #h(2em) v_3 = (c, v_2, v_1) \
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(c¬d + ¬c d, 3) \
    & #h(2em) #h(2em) arrow.r.long^(eta) "robdd_build"(¬d, 4) \
    & #h(2em) #h(2em) #h(2em) arrow.r.long^(eta) "robdd_build"(0, 5) \
    & #h(2em) #h(2em) #h(2em) #h(2em) v_0 \
    & #h(2em) #h(2em) #h(2em) arrow.r.long^(lambda) "robdd_build"(1, 5) \
    & #h(2em) #h(2em) #h(2em) #h(2em) v_1 \
    & #h(2em) #h(2em) #h(2em) v_5 = (d, v_0, v_1) \
    & #h(2em) #h(2em) arrow.r.long^(lambda) "robdd_build"(d, 4) \
    & #h(2em) #h(2em) #h(2em) v_2 = (d, v_1, v_0) \
    & #h(2em) #h(2em) v_4 = (c, v_5, v_2) \
    & #h(2em) v_6 = (c, v_3, v_4) \
    & arrow.r.long^(lambda) "robdd_build"(b(c¬d + ¬c d), 2) \
    & #h(2em) arrow.r.long^(eta) "robdd_build"(c¬d + ¬c d, 3) \
    & #h(2em) #h(2em) v_4 = (c, v_5, v_2) \
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(0, 3) \
    & #h(2em) #h(2em) v_0 \
    & #h(2em) v_7 = (b, v_4, v_0) \
    & v_8 = (a, v_6, v_7)
  $
]

== // 1. (b)


#pagebreak()
// ---------------------- Problem 2 ----------------------
= SAT Solving


#pagebreak()
// ---------------------- Problem 3 ----------------------
= Combinational Equivalence Checking


#pagebreak()
// ---------------------- Problem 4 ----------------------
= Characteristic Function




#pagebreak()
// ---------------------- Problem 5 ----------------------
= Sequential Equivalence Checking
