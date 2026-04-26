#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))

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

= Technology Mapping
