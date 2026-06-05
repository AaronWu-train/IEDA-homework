#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/wavy:0.1.3"
#import "@preview/algorithmic:1.0.7"
#import "@preview/zap:0.4.0"
#import "@preview/subpar:0.2.2"

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

#set heading(numbering: ((..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    [#numbering("1", ..nums) #h(0.6em)]
  } else if nums.len() == 2 {
    [#numbering("1", nums.first()). (#numbering("a", nums.last())) #h(0.6em)]
  } else {
    [#h(-0.4em)]
  }
}))

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

  hat(g)_1 &= g_(b f) = 7, \
  hat(g)_2 &= g_(a e) = 0, \
  hat(g)_3 &= g_(c d) = -7
$

The partial sums are:

$

  G_1 &= sum_(j=1)^1 hat(g)_j = 7, \
  G_2 &= sum_(j=1)^2 hat(g)_j = 7, \
  G_3 &= sum_(j=1)^3 hat(g)_j = 0

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

  hat(g)_1 &= g_(a e) = 0, \
  hat(g)_2 &= g_(f b) = -1, \
  hat(g)_3 &= g_(c d) = 1

$

The partial sums are:

$
  G_1 &= sum_(j=1)^1 hat(g)_j = 0, \
  G_2 &= sum_(j=1)^2 hat(g)_j = -1, \
  G_3 &= sum_(j=1)^3 hat(g)_j = 0
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

#pagebreak()
// ---------------------- Problem 3 ----------------------
= Wire-length Estimation

#figure(
  canvas(length: 0.8cm, {
    // grid
    draw.grid((0, 0), (7, 6), step: 1, stroke: gray + 0.4pt)

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
  caption: [Pins of net $N$ on a grid layout surface.]
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
  canvas(length: 0.8cm, {
    // grid
    draw.grid((0, 0), (7, 6), step: 1, stroke: gray + 0.4pt)

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
  caption: [The Minimum Spanning Tree.]
)
The length of the minimum spanning tree is $3 + 4 + 4 = 11$.

== Minimum Steiner Tree Length // 3. (d)

#figure(
  canvas(length: 0.8cm, {
    // grid
    draw.grid((0, 0), (7, 6), step: 1, stroke: gray + 0.4pt)

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
  caption: [The Minimum Steiner Tree.]
)
The length of the minimum Steiner tree is $2 + 4 + 4 = 10$.




#pagebreak()
// ---------------------- Problem 4 ----------------------
= Force-Directed Placement

#pagebreak()
// ---------------------- Problem 5 ----------------------
= Maze Routing

#pagebreak()
// ---------------------- Problem 6 ----------------------
= Channel Routing

#pagebreak()
// ---------------------- Problem 7 ----------------------
= Testing
