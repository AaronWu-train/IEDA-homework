#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/wavy:0.1.3"
#import "@preview/algorithmic:1.0.7"
#import "@preview/zap:0.4.0"
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))
#show raw.where(lang: "wavy"): it => wavy.render(it.text)
#set scale(reflow: true)

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
    & #h(2em) arrow.r.long^(lambda) "robdd_build"(0, 4) \
    & #h(2em) #h(2em) v_0 \
    & #h(2em) v_10 = (b, v_5, v_0) \
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
    edge(<v10>, <zero>, "--latex", stroke: red),
    
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

== // 1. (c)
Since$ exists c. f = f_c + f_(not c) = "ITE"(f_c, 1, f_(not c)) = "ITE"(v_11, 1, v_14) $
we can use the ROBDD in @1b_robdd to compute the ROBDD of $"ITE"(f_c, 1, f_(not c))$. Hence we have:
$
  & "ITE"(f_c, 1, f_(not c)) \
  & = "ITE"(v_11, 1, v_14) \
  & = "ITE"(a, space.third
      "ITE"(v_9, 1, v_12), space.third
      "ITE"(v_10, 1, v_13))) \
  & = "ITE"(a, space.third
      "ITE"(
        b, space.quarter
        "ITE"(v_2, 1, 1), space.quarter
        "ITE"(v_5, 1, v_2)
      ), space.third
      "ITE"(
        b, space.quarter
        "ITE"(v_5, 1, v_2), space.quarter
        "ITE"(0, 1, 0)
      ))
$
since $v_2 = d$ and $v_5 = ¬d$, we have
$
  & "ITE"(v_2, 1, 1) = 1 \
  & "ITE"(v_5, 1, v_2) = "ITE"(¬d, 1, d) = 1 \
  & "ITE"(0, 1, 0) = "ITE"(d, 1, 0) = 0. \
$
Therefore,
$
  & "ITE"(f_c, 1, f_(not c)) \
  & = "ITE"(a, space.third
      "ITE"(b,1,1), space.third
      "ITE"(b,1, 0)
    ) \
  & = "ITE"(a, 1, b) \
  & = a + b
$
The ROBDD of $"ITE"(f_c, 1, f_(not c)) = "ITE"(a, 1, b) = a + b$ is as shown as below (@1c_robdd).

#figure(
  diagram(
    node-stroke: 1.2pt,
    edge-stroke: 1.2pt,
    spacing: 1.5cm,
    node((0.5, 0), align(center)[$a$], name: <va>, shape: "circle"),
    node((0, 1), align(center)[$b$], name: <vb>, shape: "circle"),
    
    edge(<va>, <one>, "-latex"),
    edge(<va>, <vb>, "--latex", stroke: red),
    edge(<vb>, <one>, "-latex"),
    edge(<vb>, <zero>, "--latex", stroke: red),
    
    node((0, 2), align(center)[$0$], name: <zero>, shape: "rect"),
    node((1, 2), align(center)[$1$], name: <one>, shape: "rect"),
  ),
  caption: [The ROBDD of $"ITE"(f_c, 1, f_(not c))$.],
)<1c_robdd>
#pagebreak()
// ---------------------- Problem 2 ----------------------
= SAT Solving
$
  C_1 & = (a + b + c),                & C_2 & = (a + ¬c + ¬d + e),quad & C_3 & = (¬b + c + ¬d + e), \
  C_4 & = (a + ¬c + ¬e),              & C_5 & = (¬c + d + e),          & C_6 & = (¬b + c + d), \
  C_7 & = (a + ¬b + c + ¬d + ¬e),quad & C_8 & = (¬a + b + c + e),      & C_9 & = (¬a + ¬c + d + ¬e). \
$


== // 2. (a)

#let diagram_2a = diagram(
  node-stroke: 1.5pt,
  edge-stroke: 1.5pt,
  spacing: 0.5cm,
  node((-4, 0), align(center)[$a$], name: <a1>, shape: "circle"),
  
  node((-8, 2), align(center)[$b$], name: <b1>, shape: "circle"),
  node((0, 2), align(center)[$b$], name: <b2>, shape: "circle"),
  
  node((-12, 4), align(center)[$c$], name: <c1>, shape: "circle"),
  node((-4, 4), align(center)[$c$], name: <c2>, shape: "circle"),
  node((1, 4), align(center)[$c$], name: <c3>, shape: "circle"),
  
  node((-14, 6), align(center)[$C_1$], name: <d1>, stroke: 0pt),
  node((-10, 6), align(center)[$d$], name: <d2>, shape: "circle"),
  node((-6, 6), align(center)[$d$], name: <d3>, shape: "circle"),
  node((-2, 6), align(center)[$d$], name: <d4>, shape: "circle"),
  node((1, 6), align(center)[$d$], name: <d5>, shape: "circle"),
  
  
  node((-11, 9), align(center)[$e$], name: <e3>, shape: "circle"),
  node((-9, 9), align(center)[$e$], name: <e4>, shape: "circle"),
  node((-7, 9), align(center)[$C_6$], name: <e5>, shape: "circle", stroke: 0pt),
  node((-5, 9), align(center)[$e$], name: <e6>, shape: "circle"),
  node((-3, 9), align(center)[$e$], name: <e7>, shape: "circle"),
  node((-1, 9), align(center)[$e$], name: <e8>, shape: "circle"),
  node((1, 9), align(center)[$e$], name: <e9>, shape: "circle"),
  
  
  node((-11.5, 13), align(center)[$C_5$], name: <z3>, shape: "circle", stroke: 0pt),
  node((-10.5, 13), align(center)[$C_4$], name: <o3>, shape: "circle", stroke: 0pt),
  node((-9.5, 13), align(center)[$C_2$], name: <z4>, shape: "circle", stroke: 0pt),
  node((-8.5, 13), align(center)[$C_4$], name: <o4>, shape: "circle", stroke: 0pt),
  
  node((-5.5, 13), align(center)[$C_3$], name: <z6>, shape: "circle", stroke: 0pt),
  node((-4.5, 13), align(center)[$C_7$], name: <o6>, shape: "circle", stroke: 0pt),
  node((-3.5, 13), align(center)[$C_5$], name: <z7>, shape: "circle", stroke: 0pt),
  node((-2.5, 13), align(center)[$C_4$], name: <o7>, shape: "circle", stroke: 0pt),
  node((-1.5, 13), align(center)[$C_2$], name: <z8>, shape: "circle", stroke: 0pt),
  node((-0.5, 13), align(center)[$C_4$], name: <o8>, shape: "circle", stroke: 0pt),
  node((0.5, 13), align(center)[$C_8$], name: <z9>, shape: "circle", stroke: 0pt),
  
  node((1.5, 13), align(center)[SAT], name: <o9>, shape: "rect"),
  
  edge(<a1>, <b1>, "--}>"),
  edge(<b1>, <c1>, "--}>"),
  edge(<c1>, <d1>, "--x--}>", stroke: red),
  edge(<c1>, <d2>, "-}>"),
  edge(<d2>, <e3>, "--}>"),
  edge(<e3>, <z3>, "--x--}>", stroke: red),
  edge(<e3>, <o3>, "-x-}>", stroke: red),
  edge(<d2>, <e4>, "-}>"),
  edge(<e4>, <z4>, "--x--}>", stroke: red),
  edge(<e4>, <o4>, "-x-}>", stroke: red),
  
  edge(<b1>, <c2>, "-}>"),
  edge(<c2>, <d3>, "--}>"),
  edge(<d3>, <e5>, "--x--}>", stroke: red),
  edge(<d3>, <e6>, "-}>"),
  edge(<e6>, <z6>, "--x--}>", stroke: red),
  edge(<e6>, <o6>, "-x-}>", stroke: red),
  edge(<c2>, <d4>, "-}>"),
  edge(<d4>, <e7>, "--}>"),
  edge(<e7>, <z7>, "--x--}>", stroke: red),
  edge(<e7>, <o7>, "-x-}>", stroke: red),
  edge(<d4>, <e8>, "-}>"),
  edge(<e8>, <z8>, "--x--}>", stroke: red),
  edge(<e8>, <o8>, "-x-}>", stroke: red),
  
  edge(<a1>, <b2>, "-}>"),
  edge(<b2>, <c3>, "--}>"),
  edge(<c3>, <d5>, "--}>"),
  edge(<d5>, <e9>, "--}>"),
  edge(<e9>, <z9>, "--x--}>", stroke: red),
  edge(<e9>, <o9>, "-}>"),
)

#figure(
  scale(88%, diagram_2a),
  caption: [The search tree in solving the above CNF formula without implication and conflict-based learning.],
)

== // 2. (b)
Graphical tree are hard to show both the search process and implication, hence we use the following text-based tree to show the search process and implication in solving the above CNF formula without implication and conflict-based learning. In the tree, each node represents a variable assignment, and each edge represents an implication. The leaf nodes with "✓ SAT" represent a satisfying assignment, and the leaf nodes with "✗ conflict at $C_x$" represent a conflict at clause $C_x$.

```
root
├── a=0
│   ├── b=0  => c=1(C1), e=0(C4), d=0(C2)  ✗ conflict at C5
│   └── b=1
│       ├── c=0  => d=1(C6), e=1(C3)  ✗ conflict at C7
│       └── c=1  => e=0(C4), d=0(C2)  ✗ conflict at C5
└── a=1
    └── b=0
        └── c=0  => e=1(C8)
            ├── d=0  ✓ SAT
            └── d=1  ✓ SAT
```

== // 2. (c)
The search tree in solving the above CNF formula with implication and conflict-based learning is shown as below.

#pagebreak()
// ---------------------- Problem 3 ----------------------
= Combinational Equivalence Checking
== // 3. (a)

#figure(
  image("assets/3a.png", width: 80%),
  caption: [The corresponding miter circuit for equivalence checking.],
)<3a_miter>

== // 3. (b)
Since we have 3 primary inputs, the total possible input combinations are $2^3 = 8$. So we only need one iteration of 8-bit parallelsimulation to achieve exhaustive simulation on
the miter circuit of @3a_miter.

$
  a &= 10101010 quad("0xAA"); \
  b &= 11001100 quad("0xCC"); \
  c &= 11110000 quad("0xF0"); \
$$
  d &= a and b &=& 10101010 space amp space 11001100 = 10001000 quad("0x88"); \
  e &= b and not c &=& 11001100 space amp space 00001111 = 00001100 quad("0x0C"); \
  f &= c and a &=& 11110000 space amp space 10101010 = 10100000 quad("0xA0"); \
  g &= d or e or f &=& 10001000  |  00001100  |  10100000 = 10101100 quad("0xAC"); \
  \
  h &= a and c &=& 11110000 space amp space 10101010 = 10100000 quad("0xA0"); \
  i &= b and not c &=& 11001100 space amp space 00001111 = 00001100 quad("0x0C"); \
  j &= h or j &=& 10100000  |  00001100 = 10101100 quad("0xAC"); \
  \
  "Final Output" &= g xor j &=& 10101100 space amp space 10101100 = 00000000 quad("0x00"). \
$

Since the final output is always 0, we can conclude that the two circuits are combinationally equivalent.

== // 3. (c)
The miter output is z. To formulate the equivalence checking problem as a SAT
instance, we force the miter output to be 1. Therefore, the SAT instance is the
CNF formula Phi and z, where Phi encodes all gates in the miter circuit.

From the circuit, the gate relations are

$
d = a and b \
e = b and not c \
f = a and c \
g = d or e or f \
h = a and c \
i = b and not c \
j = h or i \
z = g xor j
$

Each gate is translated into CNF as follows.

$
d = a and b
quad => quad
(not d or a)
and (not d or b)
and (not a or not b or d)
$

$
e = b and not c
quad => quad
(not e or b)
and (not e or not c)
and (not b or c or e)
$

$
f = a and c
quad => quad
(not f or a)
and (not f or c)
and (not a or not c or f)
$

$
g = d or e or f
quad => quad
(not d or g)
and (not e or g)
and (not f or g)
and (not g or d or e or f)
$

$
h = a and c
quad => quad
(not h or a)
and (not h or c)
and (not a or not c or h)
$

$
i = b and not c
quad => quad
(not i or b)
and (not i or not c)
and (not b or c or i)
$

$
j = h or i
quad => quad
(not h or j)
and (not i or j)
and (not j or h or i)
$

$
z = g xor j
quad => quad
(g or j or not z)
and (g or not j or z)
and (not g or j or z)
and (not g or not j or not z)
$

Therefore, the final SAT instance is

$
Phi
&=
(not d or a)
and (not d or b)
and (not a or not b or d) \

&quad and
(not e or b)
and (not e or not c)
and (not b or c or e) \

&quad and
(not f or a)
and (not f or c)
and (not a or not c or f) \

&quad and
(not d or g)
and (not e or g)
and (not f or g)
and (not g or d or e or f) \

&quad and
(not h or a)
and (not h or c)
and (not a or not c or h) \

&quad and
(not i or b)
and (not i or not c)
and (not b or c or i) \

&quad and
(not h or j)
and (not i or j)
and (not j or h or i) \

&quad and
(g or j or not z)
and (g or not j or z)
and (not g or j or z)
and (not g or not j or not z) \

&quad and
z
$

The last clause z forces the miter output to be 1. Thus, the SAT solver searches
for an assignment such that the two circuit outputs are different. If this CNF
formula is satisfiable, then the satisfying assignment is a counterexample to
equivalence. If this CNF formula is unsatisfiable, then no such counterexample
exists, and the two circuits are equivalent.


== // 3. (d)
I translate the above CNF formula into DIMACS format as follows. note that we use the following variable mapping:
$a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10, z = 11$.

#let cnf = read("assets/miter_equivalence.cnf")

#text(size: 11pt, 
zebraw(
  numbering: false,
  highlight-lines: (
    (header: [DIMACS format for the miter equivalence checking problem], lines: 1),
  ),
  raw(cnf, block: true),
))

The result of running `minisat` on the above CNF file is `UNSAT`, which means that the two circuits are combinationally equivalent.

#figure(
  image("assets/3d.png", width: 70%),
  caption: [The result of running `minisat` on the above CNF file.],
)


#pagebreak()
// ---------------------- Problem 4 ----------------------
= Characteristic Function

== // 4. (a)
The set of states each of which has no direct transition to itself has characteristic function of $ F(bold(s)) = not T(bold(s), bold(s)) $

== // 4. (b)
The set of states that can be reached from C in exactly two transitions has characteristic function of
$
  G(bold(s)) = exists bold(s_1), bold(s_2). C(bold(s_1)) and T(bold(s_1), bold(s_2)) and T(bold(s_2), bold(s)) \
$

== // 4. (c)
The set of states that  each have a unique next state has characteristic function of
$
  H(bold(s)) = exists bold(s_1). (T(bold(s), bold(s_1)) and forall
    bold(s_2). ((T(bold(s), bold(s_1)) and T(bold(s), bold(s_2))) -> bold(s_1) = bold(s_2))
  )
$

// ---------------------- Problem 5 ----------------------
= Sequential Equivalence Checking

== // 5. (a)
Transition function of $C_1$:
  $
    s_1' = not((not (x_1 and x_2)) and (not s_1)) = (x_1 and x_2) or s_1 
  $
Output function of $C_1$:
  $
    z_1 = s_1 
  $
Transition functions of $C_2$:
$
  s_2' &= x_1 \
  s_3' &= x_2 \
  s_4' &= (s_2 and s_3) or s_4 \
$
Output function of $C_2$:
$
  z_2 = (s_2 and s_3) or s_4 
$
Since a characteristic function is 1 exactly on the corresponding initial state, and the initial values are
$r_1 = 0, r_2 = 1, r_3 = 0, r_4 = 0$, we have:

Characteristic function of the initial state of $C_1$:
$
I_1(s_1) = not s_1
$

Characteristic function of the initial state of $C_2$:
$
I_2(s_2, s_3, s_4) = s_2 and not s_3 and not s_4
$

== // 5. (b)

Transition functions of product machine $C_(1 times 2)$:

$
s'_1 = (x_1 and x_2) or s_1
$

$
s'_2 = x_1
$

$
s'_3 = x_2
$

$
s'_4 = (s_2 and s_3) or s_4
$

Output functions of product machine $C_(1 times 2)$:

$
z_1 = s_1
$

$
z_2 = (s_2 and s_3) or s_4
$

$
z = z_1 xor z_2
  = s_1 xor ((s_2 and s_3) or s_4)
$

Since the initial values are $r_1 = 0, r_2 = 1, r_3 = 0, r_4 = 0$, the initial state of $C_(1 times 2)$ is

$
(s_1, s_2, s_3, s_4) = (0, 1, 0, 0)
$

Its characteristic function is

$
I_(1 times 2)(s_1, s_2, s_3, s_4)
= not s_1 and s_2 and not s_3 and not s_4
$

== // 5(c)

Transition relation of $C_(1 times 2)$ is

$
T(bold(x), bold(s), bold(s')) &= product_i (s_i' equiv delta_i(arrow(x), arrow(s))) \
&=
(s'_1 equiv (s_1 or (x_1 and x_2)))
and (s'_2 equiv x_1)
and (s'_3 equiv x_2)
and (s'_4 equiv ((s_2 and s_3) or s_4)),
$

Quantified Transition Relation:
$
T_exists (bold(s), bold(s')) &= exists bold(x) . T(bold(x), bold(s), bold(s')) \
&= exists x_1 exists x_2 . (s'_1 equiv (s_1 or (x_1 and x_2)))
and (s'_2 equiv x_1)
and (s'_3 equiv x_2)
and (s'_4 equiv ((s_2 and s_3) or s_4))
$

Since

$
exists x . ((x equiv a) and F(x)) equiv F(a),
$

we can eliminate $x_1$ and $x_2$ as follows:

$
T_exists(s, s')
= exists x_1 exists x_2 .
(
  (s'_1 equiv (s_1 or (x_1 and x_2)))
  and (s'_2 equiv x_1)
  and (s'_3 equiv x_2)
  and (s'_4 equiv ((s_2 and s_3) or s_4))
)
$

First eliminate $x_1$:

$
= exists x_2 .
(
  (s'_1 equiv (s_1 or (s'_2 and x_2)))
  and (s'_3 equiv x_2)
  and (s'_4 equiv ((s_2 and s_3) or s_4))
)
$

Then eliminate $x_2$:

$
=
(s'_1 equiv (s_1 or (s'_2 and s'_3)))
and
(s'_4 equiv ((s_2 and s_3) or s_4))
$

Hence, the quantified transition relation is
$
T_exists (s, s') =
(s'_1 equiv (s_1 or (s'_2 and s'_3)))
and
(s'_4 equiv ((s_2 and s_3) or s_4))
$
== // 5(d)

The initial state is

$
(s_1, s_2, s_3, s_4) = (0, 1, 0, 0)
$

Thus the initial-state characteristic function is

$
R_0 = not s_1 and s_2 and not s_3 and not s_4
$

Using $T_exists$, the reached state sets are:

$
R_1 =
not s_4 and (s_1 equiv (s_2 and s_3))
$

$
R_2 =
s_1 equiv ((s_2 and s_3) or s_4)
$

$
R_3 = R_2 = s_1 equiv ((s_2 and s_3) or s_4)
$

Therefore, the fixed point is reached at iteration 2.


Since all reachable states satisfy

$
s_1 equiv ((s_2 and s_3) or s_4)
$

The output functions are

$
z_1 = s_1
$

and

$
z_2 = (s_2 and s_3) or s_4
$

Thus, for all reachable states,

$
z_1 equiv z_2
$

Therefore, $C_1$ and $C_2$ are equivalent under the given initial state.


== // 5(e)

Now the initial state is

$
(s_1, s_2, s_3, s_4) = (0, 1, 1, 0)
$

The initial-state characteristic function is

$
R_0 =
not s_1 and s_2 and s_3 and not s_4
$

Using $T_exists$, the reached state sets are:

$
R_1 &=
R_0
or
(s_4 and (s_1 equiv (s_2 and s_3)))\
&=
(not s_1 and s_2 and s_3 and not s_4)
or
(s_4 and (s_1 equiv (s_2 and s_3)))\

R_2 &=
(not s_1 and s_2 and s_3 and not s_4)
or
(s_4 and (s_1 equiv (s_1 or (s_2 and s_3))))
\
R_3 &= R_2
$

Therefore, the fixed point is reached at iteration 2.

However, the initial state itself is reachable. At

$
(s_1, s_2, s_3, s_4) = (0, 1, 1, 0)
$

we have

$
z_1 = s_1 = 0
$

but

$
z_2 = (s_2 and s_3) or s_4 = 1
$

Thus,

$
z_1 != z_2
$

Therefore, $C_1$ and $C_2$ are not equivalent under the new initial state.