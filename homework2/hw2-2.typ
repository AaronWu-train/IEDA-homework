#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/k-mapper:1.4.0": *
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/zap:0.5.0"
#import "@preview/wavy:0.1.3"
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))
#show raw.where(lang: "wavy"): it => wavy.render(it.text)

#show: project.with(
  title: "Homework 2",
  subtitle: "(Problems 6-8)",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 2 (part 2)",
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

#counter(heading).update(5)
= Two-level Logic Minimization

== 　 // 6.(a)

Use variable order $a b c d e$.

$
  G = a b c e + a b d e + a b macron(c) e + macron(a) b macron(c) e + macron(a) macron(b) macron(c) macron(e) + macron(a) macron(c) macron(d)e + b c macron(d) e + c macron(d) macron(e)
$

$
  D = macron(a) b macron(d) e + a b c macron(d) + a c macron(e)
$

Expanding them into minterms:

$
  G = {0,1,2,4,9,11,12,13,20,25,27,28,29,31}
$

$
  D = {9,13,20,22,28,29,30}
$

Thus, we have the minterms of onset #smallcaps("f") as:
$
  F = G - D = {0,1,2,4,11,12,25,27,31}
$

Therefore,

$
  F union D
  = {0,1,2,4,9,11,12,13,20,22,25,27,28,29,30,31}
$


$
  R & = {0,1,...,31} - (F union D) \
    & = {3,5,6,7,8,10,14,15,16,17,18,19,21,23,24,26}
$

Writing them as product terms:

$
  R = & macron(a) macron(b) macron(c)d e
        + macron(a) macron(b)c macron(d)e
        + macron(a) macron(b)c d macron(e)
        + macron(a) macron(b)c d e
        + macron(a)b macron(c) macron(d) macron(e)
        + macron(a)b macron(c)d macron(e) \
    + & macron(a)b c d macron(e)
        + macron(a)b c d e
        + a macron(b) macron(c) macron(d) macron(e)
        + a macron(b) macron(c) macron(d)e
        + a macron(b) macron(c)d macron(e)
        + a macron(b) macron(c)d e \
    + & a macron(b)c macron(d)e
        + a macron(b)c d e
        + a b macron(c) macron(d) macron(e)
        + a b macron(c)d macron(e)
$
#pagebreak()
== 　 // 6.(b)
First, we apply the Quine--McCluskey tabular method on $F union D$ to generate all prime implicants.

#let tick = text(size: 0.9em)[✓]

#figure(
  table(
    columns: (1.4fr, 1.8fr, 1.4fr),
    inset: 6pt,
    align: left,
    stroke: 0.8pt,

    [Round 1], [Round 2], [Round 3],
    table.hline(),

    [
      $macron(a) macron(b) macron(c) macron(d) macron(e)$ #tick
    ],
    [
      $macron(a) macron(b) macron(c) macron(d)$ \
      $macron(a) macron(b) macron(c) macron(e)$ \
      $macron(a) macron(b) macron(d) macron(e)$
    ],
    [],

    table.hline(),

    [
      $macron(a) macron(b) macron(c) macron(d)e$ #tick \
      $macron(a) macron(b) macron(c)d macron(e)$ #tick \
      $macron(a) macron(b)c macron(d) macron(e)$ #tick
    ],
    [
      $macron(a) macron(c) macron(d)e$ \
      $macron(b)c macron(d) macron(e)$ #tick \
      $macron(a)c macron(d) macron(e)$ #tick
    ],
    [],

    table.hline(),

    [
      $macron(a)b macron(c) macron(d)e$ #tick \
      $macron(a)b c macron(d) macron(e)$ #tick \
      $a macron(b)c macron(d) macron(e)$ #tick
    ],
    [
      $macron(a)b macron(c)e$ #tick $quad$
      $macron(a)b d e$ #tick \
      $b macron(c) macron(d)e$ #tick $quad$
      $macron(a)b c macron(d)$ #tick \
      $b c macron(d) macron(e)$ #tick $quad$
      $a macron(b)c macron(e)$ #tick \
      $a c macron(d) macron(e)$ #tick $quad$
    ],
    [
      $c macron(d) macron(e)$  $quad$
      $b macron(d)e$  \
      $b macron(c)e$  $quad$
      $b c macron(d)$ \
      $a c macron(e)$
    ],

    table.hline(),

    [
      $macron(a)b macron(c)d e$ #tick \
      $macron(a)b c macron(d)e$ #tick \
      $a macron(b)c d macron(e)$ #tick \
      $a b macron(c) macron(d)e$ #tick \
      $a b c macron(d) macron(e)$ #tick
    ],
    [
      $b macron(c)d e$ #tick $quad$
      $b c macron(d)e$ #tick \
      $a c macron(e)$ #tick $quad$
      $a b macron(c)e$ #tick \
      $a b macron(d)e$ #tick \
      $a b c macron(d)$ #tick \
      $a b c macron(e)$ #tick
    ],
    [
      $a b e$ \
      $a b c$
    ],

    table.hline(),

    [
      $a b macron(c)d e$ #tick \
      $a b c macron(d)e$ #tick \
      $a b c d macron(e)$ #tick
    ],
    [
      $a b d e$ #tick \
      $a b c e$ #tick \
      $a b c d$ #tick
    ],
    [],

    table.hline(),

    [
      $a b c d e$ #tick
    ],
    [],
    [],
  ),
  caption: [Quine--McCluskey tabular method for generating prime implicants],
)

Thus, the prime implicants are

$
  {
    macron(a) macron(b) macron(c) macron(d),
    macron(a) macron(b) macron(c) macron(e),
    macron(a) macron(b) macron(d) macron(e),
    macron(a) macron(c) macron(d)e,
    c macron(d) macron(e),
    b macron(d)e,
    b macron(c)e,
    b c macron(d),
    a c macron(e),
    a b e,
    a b c
  }.
$

Next, we use the Column covering of Boolean matrix to find the essential prime implicants. The Boolean matrix is as follows:

#let m0 = $m_0 = macron(a) macron(b) macron(c) macron(d) macron(e)$
#let m1 = $m_1 = macron(a) macron(b) macron(c) macron(d) e$
#let m2 = $m_2 = macron(a) macron(b) macron(c) d macron(e)$
#let m4 = $m_4 = macron(a) macron(b) c macron(d) macron(e)$
#let m11 = $m_11 = macron(a) b macron(c) d e$
#let m12 = $m_12 = macron(a) b c macron(d) macron(e)$
#let m25 = $m_25 = a b macron(c) macron(d) e$
#let m27 = $m_27 = a b macron(c) d e$
#let m31 = $m_31 =a b c d e$
#figure(
  table(
    columns: (3cm,) + (1.2cm,) * 11,
    inset: 5pt,
    align: center,
    stroke: 0.6pt,

    [],
    [$macron(a) macron(b) macron(c) macron(d)$],
    [$macron(a) macron(b) macron(c) macron(e)$],
    [$macron(a) macron(b) macron(d) macron(e)$],
    [$macron(a) macron(c) macron(d) e$],
    [$c macron(d) macron(e)$],
    [$b macron(d)e$],
    [$b macron(c)e$],
    [$b c macron(d)$],
    [$a c macron(e)$],
    [$a b e$],

    [$a b c$],

    [#m0 ], [1], [1], [1], [0], [0], [0], [0], [0], [0], [0], [0],
    [#m1 ], [1], [0], [0], [1], [0], [0], [0], [0], [0], [0], [0],
    [#m2 ], [0], [1], [0], [0], [0], [0], [0], [0], [0], [0], [0],
    [#m4 ], [0], [0], [1], [0], [1], [0], [0], [0], [0], [0], [0],
    [#m11], [0], [0], [0], [0], [0], [0], [1], [0], [0], [0], [0],
    [#m12], [0], [0], [0], [0], [1], [0], [0], [1], [0], [0], [0],
    [#m25], [0], [0], [0], [0], [0], [1], [1], [0], [0], [1], [0],
    [#m27], [0], [0], [0], [0], [0], [0], [1], [0], [0], [1], [0],
    [#m31], [0], [0], [0], [0], [0], [0], [0], [0], [0], [1], [1],
  ),
  caption: "Boolean matrix",
)

== 　// 6.(c)
Rows $m_2$ and $m_11$ each have only one 1, so $macron(a) macron(b) macron(c) macron(e)$ and $b macron(c) e$ are essential prime implicants.
So we remove the rows $m_2$, $m_11$  and the columns of $macron(a) macron(b) macron(c) macron(e)$ and $b macron(c) e$. We also remove the rows that have 1 in the removed columns, which are $m_0$, $m_25$, $m_27$. After removing these rows, the columns $a c macron(e)$ and $b macron(d) e$ contain only zeros, so we remove them as well. The resulting Boolean matrix is as follows:

#figure(
  table(
    columns: (3cm,) + (1.2cm,) * 7,
    inset: 5pt,
    align: center,
    stroke: 0.6pt,

    [],
    [$macron(a) macron(b) macron(c) macron(d)$],
    [$macron(a) macron(b) macron(d) macron(e)$],
    [$macron(a) macron(c) macron(d) e$],
    [$c macron(d) macron(e)$],

    [$b c macron(d)$], [$a b e$], [$a b c$],

    [#m1 ], [1], [0], [1], [0], [0], [0], [0],
    [#m4 ], [0], [1], [0], [1], [0], [0], [0],
    [#m12], [0], [0], [0], [1], [1], [0], [0],
    [#m31], [0], [0], [0], [0], [0], [1], [1],
  ),
  caption: "Reduced Boolean matrix",
)

== 　// 6.(d)
Column $c macron(d) macron(e)$ covers rows $m_4$ and $m_12$.
It dominates both columns $macron(a) macron(b) macron(d) macron(e)$ and $b c macron(d)$,
so we remove these two dominated columns. The resulting Boolean matrix is as follows:

#figure(
  table(
    columns: (3cm,) + (1.2cm,) * 5,
    inset: 5pt,
    align: center,
    stroke: 0.6pt,

    [],
    [$macron(a) macron(b) macron(c) macron(d)$],
    [$macron(a) macron(c) macron(d) e$],
    [$c macron(d) macron(e)$],
    [$a b e$],
    [$a b c$],

    [#m1 ], [1], [1], [0], [0], [0],
    [#m4 ], [0], [0], [1], [0], [0],
    [#m12], [0], [0], [1], [0], [0],
    [#m31], [0], [0], [0], [1], [1],
  ),
  caption: "Reduced Boolean matrix",
)

Since rows $m_4$ and $m_12$ have only one 1, the prime implicant $c macron(d) macron(e)$ is an induced essential prime implicant. Therefore, we select it and remove rows $m_4$ and $m_12$.

#figure(
  table(
    columns: (3cm,) + (1.2cm,) * 4,
    inset: 5pt,
    align: center,
    stroke: 0.6pt,

    [], [$macron(a) macron(b) macron(c) macron(d)$], [$macron(a) macron(c) macron(d) e$], [$a b e$], [$a b c$],

    [#m1 ], [1], [1], [0], [0],
    [#m31], [0], [0], [1], [1],
  ),
  caption: "Reduced Boolean matrix",
)

== 　// 6.(e)

After the reductions in (d), there is no cyclic core to solve, since the remaining matrix is decomposed into two independent single-row choices:

$
  m_1: {macron(a) macron(b) macron(c) macron(d), macron(a) macron(c) macron(d) e}
$

$
  m_31: {a b e, a b c}
$

Thus, the independent set heuristic is not applicable. We only need to choose one prime implicant from each set. For example, we choose

$
  macron(a) macron(b) macron(c) macron(d)
  quad "and" quad
  a b e.
$

Therefore, the selected prime implicants are

$
  macron(a) macron(b) macron(c) macron(e),
  quad
  b macron(c) e,
  quad
  c macron(d) macron(e),
  quad
  macron(a) macron(b) macron(c) macron(d),
  quad
  a b e.
$
== 　// 6.(f)
There are four minimum covers with 5 prime implicants:
#columns(2)[


  $
    G^*_1
    =
    macron(a) macron(b) macron(c) macron(e)
    +
    b macron(c) e
    +
    c macron(d) macron(e)
    +
    macron(a) macron(b) macron(c) macron(d)
    +
    a b e.
  $

  $
    G^*_3
    =
    macron(a) macron(b) macron(c) macron(e)
    +
    b macron(c) e
    +
    c macron(d) macron(e)
    +
    macron(a) macron(b) macron(c) macron(d)
    +
    a b c.
  $
  #colbreak()
  $
    G^*_2
    =
    macron(a) macron(b) macron(c) macron(e)
    +
    b macron(c) e
    +
    c macron(d) macron(e)
    +
    macron(a) macron(c) macron(d) e
    +
    a b e.
  $

  $
    G^*_4
    =
    macron(a) macron(b) macron(c) macron(e)
    +
    b macron(c) e
    +
    c macron(d) macron(e)
    +
    macron(a) macron(c) macron(d) e
    +
    a b c.
  $
]

= Static Timing Analysis
== 　 // 7.(a)
In this part, we constuct the circuit as a DAG, where each node $v in V$ represents a gate and each edge $e in E subset.eq V times V$ represents a connection between gates.
Let $R(v)$ donate the required time at the input of node $v$, $A(v)$ donate the arrival time at the output of node $v$, and $d_(u,v)$ donates the delay from node $u$'s output to node $v$'s output.
Also, we define the slack of node $v$ as
$
  S(v) = R(v) - A(v).
$

Suppose there is a node $v$ such that
$
  S(v) = R(v) - A(v) <= c
$

We want to show that there exists a path satifying every node on the path has slack at most $c$ from some primary input to $v$ and from $v$ to some primary output.

=== 1. From some primary input to $v$
First, if $v$ is a primary input, then we are done. Otherwise,
since
$
  A(v) = max_(u: (u,v) in E) (A(u) + d_(u,v))
$
there exist a node $u$ such that there is an edge from $u$ to $v$ and
$
  A(v) = A(u) + d_(u,v).
$
And since
$
  R(u) = min_(w: (u,w) in E) (R(w) - d_(u,w)) <= R(v) - d_(u,v),
$
we have
$
  S(u) = R(u) - A(u) <= R(v) - d_(u,v) - A(u) = R(v) - A(v) = S(v) <= c.
$
Thus, we can apply the same argument on $u$ and repeat this process until we reach a primary input.

=== 2. From $v$ to some primary output
First, if $v$ is a primary output, then we are done. Otherwise,
since
$ R(v) = min_(w: (v,w) in E) (R(w) - d_(v,w)) $
there exist a node $w$ such that there is an edge from $v$ to $w$ and
$ R(v) = R(w) - d_(v,w). $
And since
$ A(w) = max_(x: (x,w) in E) (A(x) + d_(x,w)) >= A(v) + d_(v,w), $
we have
$ S(w) = R(w) - A(w) <= R(v) + d_(v,w) - A(v) - d_(v,w) = R(v) - A(v) = S(v) <= c. $
Thus, we can apply the same argument on $w$ and repeat this process until we reach a primary output.

Hence, there exists a path from some primary input to $v$ and from $v$ to some primary output such that the slack of each node on these paths is at most $c$.

== 　// 7.(b)
The equivalence DAG of the giver circuit is as @dag below. The delay of each gate is labled on the corresponding node. Arrival time, required time and slack of each node are also labled on the corresponding node in the format of $(a, r, s)$, where $a$ is the arrival time, $r$ is the required time and $s$ is the slack. The critical path is highlighted in red.

#figure(
  diagram(
    node-stroke: 1.3pt,
    edge-stroke: 0.75pt,
    spacing: 1cm,

    node((-0.7, 0), align(center)[$x_1$], name: <x1>, stroke: 0pt),

    node((-0.7, 2), align(center)[$x_2$], name: <x2>, stroke: 0pt),

    node((2, 0), align(center)[$3$], name: <g1>),
    node((2, 4), align(center)[$3$], name: <g2>),
    node((4.3, 2), align(center)[$3$], name: <g3>),
    node((5, 0), align(center)[$1$], name: <g4>),
    node((5.5, 2), align(center)[$4$], name: <g5>),
    node((8, 0), align(center)[$4$], name: <g6>),
    node((8, 4), align(center)[$3$], name: <g7>),


    node((10, 0), align(center)[$z_1$], name: <z1>, stroke: 0pt),

    node((5, 6), align(center)[$\ quad quad 1 quad quad \ $], name: <ff>, shape: "rect"),


    edge(<x1>, <g1>, "-|>", label-pos: 0.4, label: [$(0,1,1)$], label-sep: 1pt),
    edge(
      <x2>,
      (1.45, 2),
      marks: (
        (inherit: "*", pos: 1, fill: black, stroke: black),
      ),
      stroke: red,
      label-pos: 0.46,
      label: [$(2,1,-1)$],
      label-sep: 1pt,
      layer: 10,
    ),
    edge((1.4, 2), (1.4, 0.5), <g1>, "-|>", label: [$(2,1,-1)$], stroke: red, label-sep: 1pt, label-pos: 0.3),
    edge(
      (1.4, 2),
      (1.4, 3.5),
      <g2>,
      "-|>",
      label-side: left,
      label: [$(2,1,-1)$],
      stroke: red,
      label-pos: 0.3,
      label-sep: 1pt,
    ),
    edge(<g1>, (4, 0), "-", label-pos: 0.45, label: [$(5,4,-1)$], stroke: red, label-sep: 1pt),
    edge(
      (4, 0.0),
      (4, 1.5),
      <g3>,
      "-|>",
      label: [$(5,4,-1)$],
      stroke: red,
      label-sep: 1pt,
      label-side: left,
      label-pos: 0.35,
    ),
    edge((4, 4.0), (4, 2.5), <g3>, "-|>", label-pos: 0.3, label: [$(5,4,-1)$], stroke: red, label-sep: 1pt),
    edge(<g3>, <g5>, "-|>", label: [$(8,7,-1)$], stroke: red, label-sep: 1pt, label-pos: 0.45),
    edge(<g4>, <g6>, "-|>", label: [$(6,12,6)$], label-sep: 1pt),
    edge(<g5>, (7.3, 2), "-", label: [$(12,11,-1)$], stroke: red, label-sep: 1pt),
    edge(
      (7.3, 2),
      (7.3, 3.5),
      <g7>,
      "-|>",
      label-pos: 0.3,
      label: [$(12,11,-1)$],
      stroke: red,
      label-sep: 1pt,
      label-side: left,
    ),
    edge((5.2, 4.05), (5.2, 2.5), <g5>, "*-|>", label-pos: 0.3, label: [$(5,7,2)$], label-sep: 1pt),
    edge(<g2>, (4, 4), "-", label: [$(5,4,-1)$], stroke: red, label-sep: 1pt),
    edge((3.95, 4), (5.2, 4), "*-", label: [$(5,7,2)$], label-sep: 1pt),
    edge((5.2, 4), <g7>, "-|>", label: [$(5,11,6)$], label-sep: 1pt),
    edge((7.3, 2.05), (7.3, 0.5), <g6>, "*-|>", label-pos: 0.3, label: [$(12,12,0)$], label-sep: 1pt),


    edge(<g6>, <z1>, "-|>", label-pos: 0.45, label: [$(16,16,0)$], label-sep: 1pt),
    edge(<g7>, (9, 4), (9, 6), <ff>, "-|>", label-pos: 0.8, label: [$(15,14,-1)$], stroke: red, label-sep: 1pt),
    edge(<ff>, (0.7, 6), (0.7, 4), <g2>, "-|>", label-pos: 0.2, label: [$(1,1,0)$], label-sep: 1pt),
    edge((3.95, 0), <g4>, "*-|>", label-pos: 0.5, label: [$(5,11,6)$], label-sep: 1pt),

    node((rel: (275deg, 6mm), to: <g1>), align(center)[$g_1$], stroke: 0pt),
    node((rel: (90deg, 7.5mm), to: <g2>), align(center)[$g_2$], stroke: 0pt),
    node((rel: (176deg, 7mm), to: <g3>), align(center)[$g_3$], stroke: 0pt),
    node((rel: (275deg, 6mm), to: <g4>), align(center)[$g_4$], stroke: 0pt),
    node((rel: (90deg, 7.5mm), to: <g5>), align(center)[$g_5$], stroke: 0pt),
    node((rel: (275deg, 6mm), to: <g6>), align(center)[$g_6$], stroke: 0pt),
    node((rel: (90deg, 7.5mm), to: <g7>), align(center)[$g_7$], stroke: 0pt),
    node((rel: (90deg, 7.5mm), to: <ff>), align(center)[D-flip-flop], stroke: 0pt),
  ),
  caption: "static timing analysis result",
)<dag>

#pagebreak()
= Technology Mapping

In this problem, I wrote two versions of the program.
The first one is the basic DAGON mapping algorithm.
The second one is an improved version, where I insert two inverters on every
original edge before running DAGON.
This gives the mapper more chance to use `INV` and `buf`.

The node numbering I used in my input file is shown in @tm-numbering.

#figure(
  image("figure1.png", width: 80%),
  caption: [Node numbering used in `input.txt`],
) <tm-numbering>

First, for the basic version without improvement, the result is:

#figure(
  table(
    columns: (1fr, 1.4fr, 1.6fr),
    inset: 6pt,
    align: center,
    stroke: 0.7pt,

    [Node], [Minimum cost], [Selected cell],
    table.hline(),
    [8], [2], [`nand2`],
    [9], [1], [`inv`],
    [10], [5], [`nand2`],
    [11], [2], [`nand2`],
    [12], [1], [`inv`],
    [13], [5], [`nand2`],
    [14], [12], [`nand2`],
    [15], [2], [`nand2`],
    [16], [3], [`inv`],
    [17], [15], [`nand3`],
  ),
  caption: [Optimal cost and selected cell of each subject node],
)

Thus, the final cover without improvement is obtained by tracing back from
output node 17:

$
  {8: "nand2", 9: "inv", 10: "nand2", 11: "nand2", 12: "inv", 13: "nand2", 14: "nand2", 17: "nand3"}.
$

The `nand3` at node 17 covers nodes 15, 16, and 17 together.
Therefore, the minimum total area is

$
  2 + 1 + 2 + 2 + 1 + 2 + 2 + 3 = 15.
$

Next, for the improved version, the output on original nodes is:

#figure(
  table(
    columns: (1fr, 1.4fr, 1.6fr),
    inset: 6pt,
    align: center,
    stroke: 0.7pt,

    [Node], [Minimum cost], [Selected cell],
    table.hline(),
    [8], [2], [`nand2`],
    [9], [1], [`inv`],
    [10], [5], [`nand2`],
    [11], [2], [`nand2`],
    [12], [1], [`inv`],
    [13], [5], [`nand2`],
    [14], [10], [`nand2`],
    [15], [2], [`nand2`],
    [16], [3], [`inv`],
    [17], [12], [`oai21`],
  ),
  caption: [Improved result on original subject nodes],
)

The minimum total area becomes $12$.
This is smaller than $15$ because the inserted inverter pairs create extra
matching choices.
In particular, node 17 can be matched by `oai21` in the improved graph, so the
final cost is reduced.
However, if we only apply the original DAGON algorithm directly on the given
subject graph, the answer is still $15$.

The c++ code of both versions and the input/output files are included in the appendix.


=== Appendix: `dagon.cpp`

#text(size: 7pt, raw(read("dagon/dagon.cpp"), lang: "cpp", block: true))

=== Appendix: `dagon_improve.cpp`

#text(size: 7pt, raw(read("dagon/dagon_improve.cpp"), lang: "cpp", block: true))

=== Appendix: `input.txt`

#text(size: 6pt, raw(read("dagon/input.txt"), lang: "txt", block: true))

=== Appendix: `output.txt`

#text(size: 7pt, raw(read("dagon/output.txt"), lang: "txt", block: true))

=== Appendix: `output_improve.txt`

#text(size: 7pt, raw(read("dagon/output_improve.txt"), lang: "txt", block: true))
