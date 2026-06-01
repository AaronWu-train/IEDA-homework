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
    & #h(2em) v_6 = (b, v_3, v_4) \
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
Since
$
  f = a b(¬c + d) + (a¬b + ¬a b)(c¬d + ¬c d) \
$
we have
$
  f_c = a b d + (a¬b + ¬a b)(¬d) \
  f_(not c) = a b + (a¬b + ¬a b)(d) \
$

Using procedure `robdd_build` to $f_c$, we have
#columns(1)[
  #set text(size: 10pt)
  $
    & "robdd_build"(a b d + (a¬b + ¬a b)(¬d), 1) \
    & arrow.r.long^(eta) "robdd_build"(b d + ¬b ¬d, 2) \
    & #h(2em) arrow.r.long^(eta) "robdd_build"(d, 4) \
    & #h(2em) #h(2em) v_2 = (d, v_1, v_0) \
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(¬d, 4) \
    & #h(2em) #h(2em) v_5 = (d, v_0, v_1) \
    & #h(2em) v_9 = (b, v_2, v_5) \
    & arrow.r.long^(eta) "robdd_build"(b ¬d, 2) \
    & #h(2em) arrow.r.long^(eta) "robdd_build"(¬d, 4) \
    & #h(2em) #h(2em) v_5 = (d, v_0, v_1) \
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(d, 4) \
    & #h(2em) #h(2em) v_2 = (d, v_1, v_0) \
    & #h(2em) v_10 = (b, v_5, v_2) \
    & v_11 = (a, v_9, v_10) \
  $
]

Using procedure `robdd_build` to $f_(not c)$, we have
#columns(1)[
  #set text(size: 10pt)
  $
    & "robdd_build"(a b + (a¬b + ¬a b)d, 1) \
    & arrow.r.long^(eta) "robdd_build"(b + ¬b d, 2) \
    & #h(2em) arrow.r.long^(eta) "robdd_build"(1, 4) \
    & #h(2em) #h(2em) v_1 \
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(d, 4) \
    & #h(2em) #h(2em) v_2 = (d, v_1, v_0) \
    & #h(2em) v_12 = (b, v_1, v_2) \
    & arrow.r.long^(lambda) "robdd_build"(b d, 2) \
    & #h(2em) arrow.r.long^(eta) "robdd_build"(d, 4) \
    & #h(2em) #h(2em) v_2 = (d, v_1, v_0) \
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(0, 4) \
    & #h(2em) #h(2em) v_0 \
    & #h(2em) v_13 = (b, v_2, v_0) \
    & v_14 = (a, v_12, v_13) \
  $
]
Hence, the shared ROBDDs of $f$, $f_c$ and $f_(not c)$ are as shown as below (@1b_robdd).

#figure(
  diagram(
    node-stroke: 1.2pt,
    edge-stroke: 1.2pt,
    spacing: 2cm,
    
    // (a)
    node((0.5, 0), align(center)[$a$], name: <v8>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v8>), align(center)[$v_8$], stroke: 0pt),
    edge(<v8>, <v6>, "-latex"),
    edge(<v8>, <v7>, "--latex", stroke: red),
    
    node((2.5, 0), align(center)[$a$], name: <v11>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v11>), align(center)[$v_11$], stroke: 0pt),
    edge(<v11>, <v9>, "-latex"),
    edge(<v11>, <v10>, "--latex", stroke: red),
    
    node((4.5, 0), align(center)[$a$], name: <v14>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v14>), align(center)[$v_14$], stroke: 0pt),
    edge(<v14>, <v12>, "-latex"),
    edge(<v14>, <v13>, "--latex", stroke: red),
    
    // (b)
    node((0, 1), align(center)[$b$], name: <v6>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v6>), align(center)[$v_6$], stroke: 0pt),
    edge(<v6>, <v3>, "-latex"),
    edge(<v6>, <v4>, "--latex", stroke: red),
    
    node((1, 1), align(center)[$b$], name: <v7>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v7>), align(center)[$v_7$], stroke: 0pt),
    edge(<v7>, <v4>, "-latex"),
    edge(<v7>, <zero>, "--latex", stroke: red),
    
    node((2, 1), align(center)[$b$], name: <v9>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v9>), align(center)[$v_9$], stroke: 0pt),
    edge(<v9>, <v2>, "-latex"),
    edge(<v9>, <v5>, "--latex", stroke: red),
    
    node((3, 1), align(center)[$b$], name: <v10>, shape: "circle"),
    node((rel: (0deg, 8mm), to: <v10>), align(center)[$v_10$], stroke: 0pt),
    edge(<v10>, <v5>, "-latex"),
    edge(<v10>, <v2>, "--latex", stroke: red),
    
    node((4, 1), align(center)[$b$], name: <v12>, shape: "circle"),
    node((rel: (0deg, 8mm), to: <v12>), align(center)[$v_12$], stroke: 0pt),
    edge(<v12>, <one>, "-latex"),
    edge(<v12>, <v2>, "--latex", stroke: red),
    
    node((5, 1), align(center)[$b$], name: <v13>, shape: "circle"),
    node((rel: (0deg, 8mm), to: <v13>), align(center)[$v_13$], stroke: 0pt),
    edge(<v13>, <v2>, "-latex"),
    edge(<v13>, <zero>, "--latex", stroke: red),
    
    // (c)
    node((0, 2), align(center)[$c$], name: <v3>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v3>), align(center)[$v_3$], stroke: 0pt),
    edge(<v3>, <v2>, "-latex"),
    edge(<v3>, <one>, "--latex", stroke: red),
    
    node((1, 2), align(center)[$c$], name: <v4>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v4>), align(center)[$v_4$], stroke: 0pt),
    edge(<v4>, <v5>, "-latex"),
    edge(<v4>, <v2>, "--latex", stroke: red),
    
    // (d)
    node((0.5, 3), align(center)[$d$], name: <v2>, shape: "circle"),
    node((rel: (180deg, 8mm), to: <v2>), align(center)[$v_2$], stroke: 0pt),
    edge(<v2>, <one>, "-latex"),
    edge(<v2>, <zero>, "--latex", stroke: red),
    
    node((4.5, 3), align(center)[$d$], name: <v5>, shape: "circle"),
    node((rel: (0deg, 8mm), to: <v5>), align(center)[$v_5$], stroke: 0pt),
    edge(<v5>, <zero>, "-latex"),
    edge(<v5>, <one>, "--latex", stroke: red),
    
    
    node((0.5, -0.5), align(center)[$f$], name: <f>, shape: "circle", stroke: 0pt),
    edge(<f>, <v8>, "--latex", stroke: 0.6pt),
    
    
    node((2.5, -0.5), align(center)[$f_c$], name: <fc>, shape: "circle", stroke: 0pt),
    edge(<fc>, <v11>, "--latex", stroke: 0.6pt),
    
    
    node((4.5, -0.5), align(center)[$f_(not c)$], name: <fnc>, shape: "circle", stroke: 0pt),
    edge(<fnc>, <v14>, "--latex", stroke: 0.6pt),
    
    node((2, 4.5), align(center)[$0$], name: <zero>, shape: "rect"),
    node((3, 4.5), align(center)[$1$], name: <one>, shape: "rect"),
  ),
  caption: [The shared ROBDDs of $f$, $f_c$ and $f_(not c)$. \ Red dashed edge represents 0-edge, and black solid edge represents 1-edge.],
)<1b_robdd>

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
