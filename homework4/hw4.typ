#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/wavy:0.1.3"
#import "@preview/algorithmic:1.0.7"
#import "@preview/zap:0.4.0"
#import "@preview/subpar:0.2.2"
#import "@preview/tdtr:0.5.5": *

#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))
#show raw.where(lang: "wavy"): it => wavy.render(it.text)
#set scale(reflow: true)

#show: project.with(
  title: "Homework 4",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 4",
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
= Partition

=== Initial partition

$ A = {a, b, c}, quad B = {d, e, f} $

$
  "Initial cut cost"= (3 + 3 + 2) + (2 + 4 + 1) + (0 + 2 + 2) = 19
$

=== Iteration 1

$ A = {a, b, c}, quad B = {d, e, f} $

$ "Current cut cost"= 19 $

==== Step 1

Current $I$, $E$, and $D$ values:

#table(
  columns: 5,
  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],
  [$a$], [$2 + 1 = 3$], [$3 + 3 + 2 = 8$], [$8 - 3 = 5$], [no],
  [$b$], [$2 + 0 = 2$], [$2 + 4 + 1 = 7$], [$7 - 2 = 5$], [no],
  [$c$], [$1 + 0 = 1$], [$0 + 2 + 2 = 4$], [$4 - 1 = 3$], [no],
  [$d$], [$1 + 0 = 1$], [$3 + 2 + 0 = 5$], [$5 - 1 = 4$], [no],
  [$e$], [$1 + 1 = 2$], [$3 + 4 + 2 = 9$], [$9 - 2 = 7$], [no],
  [$f$], [$0 + 1 = 1$], [$2 + 1 + 2 = 5$], [$5 - 1 = 4$], [no],
)

Candidate gains:

$
  g_(a d) = D_a + D_d - 2 c_(a d) = 5 + 4 - 2 dot 3 = 3
$

$
  g_(a e) = D_a + D_e - 2 c_(a e) = 5 + 7 - 2 dot 3 = 6
$

$
  g_(a f) = D_a + D_f - 2 c_(a f) = 5 + 4 - 2 dot 2 = 5
$

$
  g_(b d) = D_b + D_d - 2 c_(b d) = 5 + 4 - 2 dot 2 = 5
$

$
  g_(b e) = D_b + D_e - 2 c_(b e) = 5 + 7 - 2 dot 4 = 4
$

$
  g_(b f) = D_b + D_f - 2 c_(b f) = 5 + 4 - 2 dot 1 = 7
$

$
  g_(c d) = D_c + D_d - 2 c_(c d) = 3 + 4 - 2 dot 0 = 7
$

$
  g_(c e) = D_c + D_e - 2 c_(c e) = 3 + 7 - 2 dot 2 = 6
$

$
  g_(c f) = D_c + D_f - 2 c_(c f) = 3 + 4 - 2 dot 2 = 3
$

Therefore, the maximum gain is

$ hat(g)_1 = g_(b f) = 7 $

Temporarily swap $b$ and $f$, and lock them.

==== Step 2

Current $I$, $E$, and $D$ values:

#table(
  columns: 5,
  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],
  [$a$], [$1 + 2 = 3$], [$2 + 3 + 3 = 8$], [$8 - 3 = 5$], [no],
  [$b$], [$2 + 4 = 6$], [$2 + 0 + 1 = 3$], [$3 - 6 = -3$], [yes],
  [$c$], [$1 + 2 = 3$], [$0 + 0 + 2 = 2$], [$2 - 3 = -1$], [no],
  [$d$], [$2 + 1 = 3$], [$3 + 0 + 0 = 3$], [$3 - 3 = 0$], [no],
  [$e$], [$4 + 1 = 5$], [$3 + 2 + 1 = 6$], [$6 - 5 = 1$], [no],
  [$f$], [$2 + 2 = 4$], [$1 + 0 + 1 = 2$], [$2 - 4 = -2$], [yes],
)

Candidate gains:

$
  g_(a d) = D_a + D_d - 2 c_(a d) = 5 + 0 - 2 dot 3 = -1
$

$
  g_(a e) = D_a + D_e - 2 c_(a e) = 5 + 1 - 2 dot 3 = 0
$

$
  g_(c d) = D_c + D_d - 2 c_(c d) = -1 + 0 - 2 dot 0 = -1
$

$
  g_(c e) = D_c + D_e - 2 c_(c e) = -1 + 1 - 2 dot 2 = -4
$

Therefore, the maximum gain is

$ hat(g)_2 = g_(a e) = 0 $

Temporarily swap $a$ and $e$, and lock them.

==== Step 3

Current $I$, $E$, and $D$ values:

#table(
  columns: 5,
  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],
  [$a$], [$2 + 3 = 5$], [$1 + 3 + 2 = 6$], [$6 - 5 = 1$], [yes],
  [$b$], [$2 + 2 = 4$], [$0 + 4 + 1 = 5$], [$5 - 4 = 1$], [yes],
  [$c$], [$2 + 2 = 4$], [$1 + 0 + 0 = 1$], [$1 - 4 = -3$], [no],
  [$d$], [$3 + 2 = 5$], [$0 + 1 + 0 = 1$], [$1 - 5 = -4$], [no],
  [$e$], [$2 + 1 = 3$], [$3 + 4 + 1 = 8$], [$8 - 3 = 5$], [yes],
  [$f$], [$2 + 1 = 3$], [$2 + 1 + 0 = 3$], [$3 - 3 = 0$], [yes],
)

Candidate gains:

$
  g_(c d) = D_c + D_d - 2 c_(c d) = -3 + -4 - 2 dot 0 = -7
$

Therefore, the maximum gain is

$ hat(g)_3 = g_(c d) = -7 $

Temporarily swap $c$ and $d$, and lock them.

==== Summary of Iteration 1

$
  hat(g)_1 & = g_(b f) = 7, \
  hat(g)_2 & = g_(a e) = 0, \
  hat(g)_3 & = g_(c d) = -7
$

The partial sums are:

$
  G_1 & = sum_(j=1)^1 hat(g)_j = 7, \
  G_2 & = sum_(j=1)^2 hat(g)_j = 7, \
  G_3 & = sum_(j=1)^3 hat(g)_j = 0
$

Thus,

$ max_k G_k = 7 quad "at" quad k = 1 $

Since the largest partial sum is positive, apply the first 1 swap(s):

- Swap $b$ and $f$.

After applying the selected swap(s),

$ A = {a, c, f}, quad B = {b, d, e} $

$ "New cut cost" = 12 $

=== Iteration 2

==== Step 1

Current $I$, $E$, and $D$ values:

#table(
  columns: 5,
  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],
  [$a$], [$1 + 2 = 3$], [$2 + 3 + 3 = 8$], [$8 - 3 = 5$], [no],
  [$b$], [$2 + 4 = 6$], [$2 + 0 + 1 = 3$], [$3 - 6 = -3$], [no],
  [$c$], [$1 + 2 = 3$], [$0 + 0 + 2 = 2$], [$2 - 3 = -1$], [no],
  [$d$], [$2 + 1 = 3$], [$3 + 0 + 0 = 3$], [$3 - 3 = 0$], [no],
  [$e$], [$4 + 1 = 5$], [$3 + 2 + 1 = 6$], [$6 - 5 = 1$], [no],
  [$f$], [$2 + 2 = 4$], [$1 + 0 + 1 = 2$], [$2 - 4 = -2$], [no],
)

Candidate gains:

$
  g_(a b) = D_a + D_b - 2 c_(a b) = 5 + -3 - 2 dot 2 = -2
$

$
  g_(a d) = D_a + D_d - 2 c_(a d) = 5 + 0 - 2 dot 3 = -1
$

$
  g_(a e) = D_a + D_e - 2 c_(a e) = 5 + 1 - 2 dot 3 = 0
$

$
  g_(c b) = D_c + D_b - 2 c_(c b) = -1 + -3 - 2 dot 0 = -4
$

$
  g_(c d) = D_c + D_d - 2 c_(c d) = -1 + 0 - 2 dot 0 = -1
$

$
  g_(c e) = D_c + D_e - 2 c_(c e) = -1 + 1 - 2 dot 2 = -4
$

$
  g_(f b) = D_f + D_b - 2 c_(f b) = -2 + -3 - 2 dot 1 = -7
$

$
  g_(f d) = D_f + D_d - 2 c_(f d) = -2 + 0 - 2 dot 0 = -2
$

$
  g_(f e) = D_f + D_e - 2 c_(f e) = -2 + 1 - 2 dot 1 = -3
$

Therefore, the maximum gain is

$ hat(g)_1 = g_(a e) = 0 $

Temporarily swap $a$ and $e$, and lock them.

==== Step 2

Current $I$, $E$, and $D$ values:

#table(
  columns: 5,
  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],
  [$a$], [$2 + 3 = 5$], [$1 + 3 + 2 = 6$], [$6 - 5 = 1$], [yes],
  [$b$], [$2 + 2 = 4$], [$0 + 4 + 1 = 5$], [$5 - 4 = 1$], [no],
  [$c$], [$2 + 2 = 4$], [$1 + 0 + 0 = 1$], [$1 - 4 = -3$], [no],
  [$d$], [$3 + 2 = 5$], [$0 + 1 + 0 = 1$], [$1 - 5 = -4$], [no],
  [$e$], [$2 + 1 = 3$], [$3 + 4 + 1 = 8$], [$8 - 3 = 5$], [yes],
  [$f$], [$2 + 1 = 3$], [$2 + 1 + 0 = 3$], [$3 - 3 = 0$], [no],
)

Candidate gains:

$
  g_(c b) = D_c + D_b - 2 c_(c b) = -3 + 1 - 2 dot 0 = -2
$

$
  g_(c d) = D_c + D_d - 2 c_(c d) = -3 + -4 - 2 dot 0 = -7
$

$
  g_(f b) = D_f + D_b - 2 c_(f b) = 0 + 1 - 2 dot 1 = -1
$

$
  g_(f d) = D_f + D_d - 2 c_(f d) = 0 + -4 - 2 dot 0 = -4
$

Therefore, the maximum gain is

$ hat(g)_2 = g_(f b) = -1 $

Temporarily swap $f$ and $b$, and lock them.

==== Step 3

Current $I$, $E$, and $D$ values:

#table(
  columns: 5,
  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],
  [$a$], [$3 + 2 = 5$], [$2 + 1 + 3 = 6$], [$6 - 5 = 1$], [yes],
  [$b$], [$0 + 4 = 4$], [$2 + 2 + 1 = 5$], [$5 - 4 = 1$], [yes],
  [$c$], [$0 + 2 = 2$], [$1 + 0 + 2 = 3$], [$3 - 2 = 1$], [no],
  [$d$], [$3 + 0 = 3$], [$2 + 0 + 1 = 3$], [$3 - 3 = 0$], [no],
  [$e$], [$4 + 2 = 6$], [$3 + 1 + 1 = 5$], [$5 - 6 = -1$], [yes],
  [$f$], [$2 + 0 = 2$], [$1 + 2 + 1 = 4$], [$4 - 2 = 2$], [yes],
)

Candidate gains:

$
  g_(c d) = D_c + D_d - 2 c_(c d) = 1 + 0 - 2 dot 0 = 1
$

Therefore, the maximum gain is

$ hat(g)_3 = g_(c d) = 1 $

Temporarily swap $c$ and $d$, and lock them.

==== Summary of Iteration 2

$
  hat(g)_1 & = g_(a e) = 0, \
  hat(g)_2 & = g_(f b) = -1, \
  hat(g)_3 & = g_(c d) = 1
$

The partial sums are:

$
  G_1 & = sum_(j=1)^1 hat(g)_j = 0, \
  G_2 & = sum_(j=1)^2 hat(g)_j = -1, \
  G_3 & = sum_(j=1)^3 hat(g)_j = 0
$

Thus,

$ max_k G_k = 0 quad "at" quad k = 1 $

Since the largest partial sum is not positive, the algorithm stops.

=== Final result

$ A = {a, c, f}, quad B = {b, d, e} $

$ "Final cut cost" = 12 $

#pagebreak()
// ---------------------- Problem 2 ----------------------
= Floorplanning

== // 2. (a)
The expression
$
  E = 1 2 3 V H 4 H 5 6 V V 7 8 H H.
$
is a valid Polish expression since:
- every operand $j$, $1 ≤ j ≤ 8$, appears exactly once in E
- for every prefix of E, $E_i = e_1… e_i, 1 ≤ i ≤
  2n-1$, the number of operators is less than the number of operands.


#table(
  columns: 16,
  [],
  [$E_1$],
  [$E_2$],
  [$E_3$],
  [$E_4$],
  [$E_5$],
  [$E_6$],
  [$E_7$],
  [$E_8$],
  [$E_9$],
  [$E_(10)$],
  [$E_(11)$],
  [$E_(12)$],
  [$E_(13)$],
  [$E_(14)$],
  [$E_(15)$],

  [\# of Operands],
  [1],
  [2],
  [3],
  [3],
  [3],
  [4],
  [4],
  [5],
  [6],
  [6],
  [6],
  [7],
  [8],
  [8],
  [8],

  [\# of Operators],
  [0],
  [0],
  [0],
  [1],
  [2],
  [2],
  [3],
  [3],
  [3],
  [4],
  [5],
  [5],
  [5],
  [6],
  [7],
)

== // 2. (b)
The Polish expression E is not normalized because E contains consecutive operators of the same type: VV and HH.
#figure(
  tidy-tree-graph(
    spacing: (20pt, 20pt),
    node-inset: 4pt,
  )[
    - H
      - V
        - H
          - H
            - 1
            - V
              - 2
              - 3
          - 4
        - V
          - 5
          - 6
      - H
        - 7
        - 8
  ],
  caption: [The slicing tree of the given floorplan.],
)<2b_tree>
By Figure 1, we can see the slicing tree represented by E. To change the expression into a normalized one, which also means to change the slicing tree into a skewed one, we can apply the following transformation:
- For every node, if its right child is the same type of operator $X$ as itself, left-rotate the subtree rooted at that node.
  #subpar.grid(
    figure(
      tidy-tree-graph(
        spacing: (20pt, 20pt),
        node-inset: 4pt,
      )[
        - X
          - A
          - X
            - B
            - C
      ],
      caption: [],
    ),
    figure(
      tidy-tree-graph(
        spacing: (20pt, 20pt),
        node-inset: 4pt,
      )[
        - X
          - X
            - A
            - B
          - C
      ],
      caption: [],
    ),

    columns: (1fr, 1fr),
    caption: [Left rotation of a subtree with the same type of operator as its parent.],
  )
Applying the above transformation to the slicing tree in Figure 1, we can get the following slicing tree:

#figure(
  tidy-tree-graph(
    spacing: (20pt, 20pt),
    node-inset: 4pt,
  )[
    - H
      - H
        - V
          - V
            - H
              - H
                - 1
                - V
                  - 2
                  - 3
              - 4
            - 5
          - 6
        - 7
      - 8
  ],
  caption: [The slicing tree after applying left rotations to all consecutive same-type operator chains.],
)
The normalized Polish expression corresponding to the above slicing tree is
$
  E' = 1 2 3 V H 4 H 5 V 6 V 7 H 8 H
$
which is a valid Polish expression and is normalized since it does not contain consecutive operators of the same type. Also, the normalized Polish expression is canonical in representing the floorplan.

== // 2.(c)

== // 2.(d)

#pagebreak()
// ---------------------- Problem 3 ----------------------
= Wire-length Estimation

#figure(
  canvas(length: 0.6cm, {
    // grid
    draw.grid(
      (0, 0),
      (7, 6),
      step: 1,
      stroke: gray + 0.4pt,
    )

    // axes
    draw.line((0, 0), (7.3, 0), stroke: black + 1pt, mark: (end: ">"))
    draw.line((0, 0), (0, 6.3), stroke: black + 1pt, mark: (end: ">"))

    // axis labels
    draw.content((7.45, 0), [$x$])
    draw.content((0, 6.6), [$y$])

    // tick labels
    for x in range(0, 8) {
      draw.content((x, -0.25), str(x), anchor: "north")
    }

    for y in range(0, 7) {
      draw.content((-0.25, y), str(y), anchor: "east")
    }

    // points
    let pts = (
      (1, 3, [$p_1(1,3)$]),
      (2, 5, [$p_2(2,5)$]),
      (4, 2, [$p_3(4,2)$]),
      (6, 0, [$p_4(6,0)$]),
    )

    for (x, y, label) in pts {
      draw.circle((x, y), radius: 0.08, fill: black)
      draw.content((x + 0.15, y + 0.25), label, anchor: "south-west")
    }
  }),
  caption: [Pins of net $N$ on a grid layout surface.],
)

== Semi-perimeter Length // 3. (a)
The semi-perimeter length is $(6-1)+(5-0)=5+5=10$

== Complete Graph Length // 3. (b)
#import "@preview/cetz:0.3.4": canvas, draw

$
  "wirelength" approx 2/n sum_(i, j in "net") "dist"(i, j) = 2/4 (3+ 4+8+5+9+4) = 16.5
$

== Minimum Spanning Tree Length // 3. (c)


#let p1 = (1, 3)
#let p2 = (2, 5)
#let p3 = (4, 2)
#let p4 = (6, 0)

#figure(
  canvas(length: 0.6cm, {
    // grid
    draw.grid(
      (0, 0),
      (7, 6),
      step: 1,
      stroke: gray + 0.4pt,
    )

    // axes
    draw.line((0, 0), (7.3, 0), stroke: black + 1pt, mark: (end: ">"))
    draw.line((0, 0), (0, 6.3), stroke: black + 1pt, mark: (end: ">"))

    // axis labels
    draw.content((7.45, 0), [$x$])
    draw.content((0, 6.6), [$y$])

    // tick labels
    for x in range(0, 8) {
      draw.content((x, -0.25), str(x), anchor: "north")
    }
    for y in range(0, 7) {
      draw.content((-0.25, y), str(y), anchor: "east")
    }

    // --------------------------------------------------
    // Manhattan shortest paths
    // 每一對點各畫一條 shortest Manhattan path
    // --------------------------------------------------

    // p1 <-> p2
    draw.line(p1, (1, 5), stroke: red + 1.2pt)
    draw.line((1, 5), p2, stroke: red + 1.2pt)

    // p1 <-> p3
    draw.line(p1, (4, 3), stroke: blue + 1.2pt)
    draw.line((4, 3), p3, stroke: blue + 1.2pt)

    // p3 <-> p4
    draw.line(p3, (6, 2), stroke: red + 1.2pt)
    draw.line((6, 2), p4, stroke: red + 1.2pt)

    // Points
    draw.circle(p1, radius: 0.08, fill: black)
    draw.circle(p2, radius: 0.08, fill: black)
    draw.circle(p3, radius: 0.08, fill: black)
    draw.circle(p4, radius: 0.08, fill: black)

    draw.content((1.15, 3.25), [$p_1(1,3)$], anchor: "south-west")
    draw.content((2.15, 5.25), [$p_2(2,5)$], anchor: "south-west")
    draw.content((4.15, 2.25), [$p_3(4,2)$], anchor: "south-west")
    draw.content((6.15, 0.25), [$p_4(6,0)$], anchor: "south-west")
  }),
  caption: [The Minimum Spanning Tree.],
)
The length of the minimum spanning tree is $3 + 4 + 4 = 11$.

== Minimum Steiner Tree Length // 3. (d)

#figure(
  canvas(length: 0.6cm, {
    // grid
    draw.grid(
      (0, 0),
      (7, 6),
      step: 1,
      stroke: gray + 0.4pt,
    )

    // axes
    draw.line((0, 0), (7.3, 0), stroke: black + 1pt, mark: (end: ">"))
    draw.line((0, 0), (0, 6.3), stroke: black + 1pt, mark: (end: ">"))

    // axis labels
    draw.content((7.45, 0), [$x$])
    draw.content((0, 6.6), [$y$])

    // tick labels
    for x in range(0, 8) {
      draw.content((x, -0.25), str(x), anchor: "north")
    }
    for y in range(0, 7) {
      draw.content((-0.25, y), str(y), anchor: "east")
    }

    // --------------------------------------------------
    // Manhattan shortest paths
    // 每一對點各畫一條 shortest Manhattan path
    // --------------------------------------------------

    // p1 <-> p2
    draw.line(p1, (2, 3), stroke: red + 1.2pt)
    draw.line((2, 3), p2, stroke: red + 1.2pt)

    // p1 <-> p3
    draw.line(p1, (4, 3), stroke: blue + 1.2pt)
    draw.line((4, 3), p3, stroke: blue + 1.2pt)

    // p3 <-> p4
    draw.line(p3, (6, 2), stroke: red + 1.2pt)
    draw.line((6, 2), p4, stroke: red + 1.2pt)

    // Points
    draw.circle(p1, radius: 0.08, fill: black)
    draw.circle(p2, radius: 0.08, fill: black)
    draw.circle(p3, radius: 0.08, fill: black)
    draw.circle(p4, radius: 0.08, fill: black)

    draw.content((0.75, 2.25), [$p_1(1,3)$], anchor: "south-west")
    draw.content((2.15, 5.25), [$p_2(2,5)$], anchor: "south-west")
    draw.content((4.15, 2.25), [$p_3(4,2)$], anchor: "south-west")
    draw.content((6.15, 0.25), [$p_4(6,0)$], anchor: "south-west")
  }),
  caption: [The Minimum Steiner Tree.],
)
The length of the minimum Steiner tree is $2 + 4 + 4 = 10$.

#pagebreak()
// ---------------------- Problem 4 ----------------------
= Force-Directed Placement

== // 4. (a)

$
    sum_(i in {B, C, D, E, F}) w_(A, i) (x_A - x_i) = 0 \
    sum_(i in {B, C, D, E, F}) w_(A, i) (y_A - y_i) = 0
$
$
  1(x_A - 0) + 3(x_A - 2) + 1(x_A - 6) + 2(x_A - 8) + 3(x_A - 5) = 0 \
  1(y_A - 0) + 3(y_A - 5) + 1(y_A - 9) + 2(y_A - 1) + 3(y_A - 4) = 0
$
$
  10 x_A - 43 = 0 quad => quad x_A = 4.3 \
  10 y_A - 38 = 0 quad => quad y_A = 3.8
$
Round $(x_A, y_A)$ to the nearest integer grid point, we get the location of $A$ as $(4, 4)$.

== // 4. (b)
The objective function that we want to minimize is the total wire length:
$
  L &= sum_(i in {B, C, D, E, F}) w_(A, i) (abs(x_A - x_i) +abs(y_A - y_i)) \ 
  &=
  1(abs(x_A - 0) + abs(y_A - 0)) + 3(abs(x_A - 2) + abs(y_A - 5)) + 1(abs(x_A - 6) + abs(y_A - 9)) \ &+ 2(abs(x_A - 8) + abs(y_A - 1)) + 3(abs(x_A - 5) + abs(y_A - 4))
$
By using the following python script to enumerate all possible locations of $A$ on the grid that does not overlap with existing points and calculate the corresponding total wire length, we can find the optimal location of $A$ that minimizes the total wire length.

#text(size: 10pt, 
zebraw(
  lang: "python",
  raw(read("assets/4b.py"), block: true),
))

The result shows that the optimal location of $A$ is $(4, 4)$, with cost at 41, which is the same as the result obtained by the force-directed placement method in part (a).


#pagebreak()
// ---------------------- Problem 5 ----------------------
= Maze Routing

== // 5. (a)

#figure(
  image("assets/5a.png", width: 40%),
  caption: [Finding theshortest path between S and U by Lee's approach. The numbers in the grid represent the distance from S. The pink path is the retraced path from U to S.],
)
Lee's propagation labels the reachable grids by their distances from $S$, as shown in the figure.
Retracing from $U$ along adjacent grids with decreasing labels gives the highlighted path.

Hence, the shortest path length from $S$ to $U$ is $14$.

== // 5. (b)

#subpar.grid(
  figure(image("assets/5b1.png"), caption: [
    Way 1
  ]), <5b1>,
  figure(image("assets/5b2.png"), caption: [
    Way 2
  ]), <5b2>,
  columns: (1fr, 1fr),
  caption: [Find a shortest path between S and T by Akers's approach],
  label: <5b>,
)

@5b is the grid after using the Akers's approach to find the shortest path between $S$ and $T$. The highlighted path in each subfigure is the path found by the algorithm. Both paths are shortest paths with length 18.

In @5b1, the grid containing $T$ is labeled 3. Therefore, during retracing, we first move to an adjacent grid labeled 2, then to an adjacent grid labeled 1, then 3, 2, 1, and so on, until reaching $S$.

On the other hand, in @5b2, the grid containing $T$ is labeled as the second 1. Therefore, during retracing, we first move to an adjacent grid labeled 1, then follow the reverse label order $2, 2, 1, 1, 2, 2, dots$ until reaching $S$.

For both Way 1 and Way 2, the retraced path has length 18. Hence, both paths are shortest paths from $S$ to $T$.

== // 5. (c)
#figure(
  image("assets/5c.png", width: 40%),
  caption: [Finding the shortest path between U to T by Hadlock's approach. The number labeled in each grid is the  detour number.],
)<5c>
@5c shows the result of Hadlock's approach for finding a shortest path from $U$ to $T$.
In the propagation step, $U$ is used as the source. For each expansion, moving to a grid closer to $T$
does not increase the detour number, while moving to a grid farther from $T$ increases the detour
number by 1. The grids are expanded in nondecreasing order of detour number until $T$ is reached.

For retracing, we start from $T$ and move backward to $U$. At each step, we choose an adjacent
labeled grid that could be the predecessor under Hadlock's propagation rule. More specifically,
if the backward move goes farther from $T$, the detour number should stay the same; if the
backward move goes closer to $T$, the detour number should decrease by 1.

In @5c, the retraced path from $T$ first goes to the adjacent grid labeled 3 on its left.
Then it follows the sequence of detour numbers
$
3, 3, 3, 3, 3, 2, 1, 1, 1
$
and finally reaches $U$.

Equivalently, the path from $U$ to $T$ is:
go left once, go up four times, go right twice, go down twice, and go right once.
Therefore, the path length is 10.

== // 5. (d)

The minimum distances from $S$ to $U$ is 14, from $S$ to $T$ is 18, and from $U$ to $T$ is 10. Therefore, in the minimum spanning tree, we choose the edges $S-U$ and $U-T$, and do not choose the edge $S-T$. The total length of the minimum spanning tree is $14 + 10 = 24$. The result is shown in @5d.

#figure(
  image("assets/5d.png", width: 40%),
  caption: [The minimum spanning tree connecting S, U, and T. The total length of the tree is 24.],
)<5d>

== // 5. (e)

#figure(
  image("assets/5e.png", width: 40%),
  caption: [The Steiner tree connecting S, U, and T.],
)<5e>

@5e shows a rectilinear Steiner tree connecting $S$, $U$, and $T$.
The black dot is chosen as the Steiner point $P$.

The tree consists of three branches from $P$ to the three terminals.
From $P$ to $S$, the path length is $4 + 7 + 1 = 12$.
From $P$ to $U$, the path length is $3 + 1 = 4$.
From $P$ to $T$, the path length is $1 + 2 + 2 + 1 = 6$.

Therefore, the total net length is
$
12 + 4 + 6 = 22
$.


#pagebreak()
// ---------------------- Problem 6 ----------------------
= Channel Routing

#pagebreak()
// ---------------------- Problem 7 ----------------------
= Testing
