#import "../template.typ": *

#show: project.with(
  title: "Homework 1",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 1",
  theme: palette.gray,
)

#import "@preview/zebraw:0.6.1": *
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))

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

#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout

// -------------------------------------------------------
//                       Start here
// -------------------------------------------------------

// ---------------------- Problem 1 ----------------------
= Design Methodology and Design Flow

== // 1. (a)

#pagebreak()
// ---------------------- Problem 2 ----------------------
= Algorithm and Complexity

== 　 // 2. (a)

Let $g_(n)(x) = x^n$. Then $g_(n)(x)$ satisfies the recurrence relation
$ g_(n)(x) = x dot g_(n - 1)(x), $
with base case
$ g_0(x) = 1. $

By definition,
$ P_n(x) = P_(n - 1)(x) + a_0 g_(n)(x). $

For each recursive step, one multiplication is required to compute $g_(n)(x)$, and one multiplication together with one addition is required to compute $P_n(x)$. Hence, computing $P_n(x)$ takes $2n$ multiplications and $n$ additions overall, so the total time complexity is $O(n)$.

== 　 // 2. (b)

First, for each recursive step of calculating $P'_(i)(x) = x P'_(i-1)(x) + a_i$, one multiplication and one addition are required. Hence, calculating $P'_(n-1)(x)$ takes $n-1$ multiplications and $n-1$ additions overall, so the time complexity is $O(n-1)$.

Next, to calculate $P_(n)(x) = x P'_(n)(x) + a_0$, we need one multiplication and one addition. Hence, calculating $P_(n)(x)$ takes $n$ multiplications and $n$ additions overall, so the time complexity is $O(n)$.

// ---------------------- Problem 3 ----------------------
= NP-Completeness and Polynomial-Time Reduction
== // 3. (a)
To prove that the feasibility problem of 0,1-ILP is NP-complete, it suffices to show that it is in NP and that it is NP-hard.

First, the problem is in NP. Given an assignment to the binary variables, we can verify in polynomial time whether all linear constraints are satisfied by simply substituting the assigned values into each constraint and checking its validity. Since the number of constraints is polynomial in the input size, the verification procedure runs in polynomial time.

Next, we show that the problem is NP-hard by giving a polynomial-time reduction from 3-SAT. Consider an arbitrary 3-SAT instance with variables $x_1, x_2, ..., x_n$ and clauses $C_1, C_2, ..., C_m$. We construct a corresponding 0,1-ILP instance as follows.

- For each Boolean variable $x_i$, introduce a binary variable $y_i in {0, 1}$.
- For each clause $C_j = (a or b or c)$, where $a$, $b$, and $c$ are literals (can be $x_i$ or $not x_i$), introduce the linear constraint
  $
    y_a + y_b + y_c >= 1,
  $
  where $y_a = y_i$ if $a = x_i$, and $y_a = 1 - y_i$ if $a = not x_i$. The definitions of $y_b$ and $y_c$ are analogous.

This construction ensures that each clause is satisfied if and only if the corresponding linear constraint is satisfied. Therefore, the original 3-SAT formula is satisfiable if and only if the constructed 0,1-ILP instance is feasible. Moreover, the transformation clearly requires only polynomial time.

Hence, 0,1-ILP feasibility is NP-hard. Since it is both in NP and NP-hard, it follows that the feasibility problem of 0,1-ILP is NP-complete.

== // 3. (b)
To prove that Circuit-SAT is NP-complete, we show that it is in NP and NP-hard.

First, Circuit-SAT is in NP. Given an assignment to the input variables, we can evaluate the circuit gate by gate in polynomial time and check whether the output is 1.

Next, we prove NP-hardness by reducing 0,1-ILP to Circuit-SAT. Consider an instance of 0,1-ILP:
$A bold(upright(x)) <= bold(upright(b))$,
where each $x_i in {0,1}$.
That is, the instance consists of inequalities
$
  a_(j 1)x_1 + a_(j 2)x_2 + ... + a_(j n)x_n <= b_j,
$
for $j = 1, 2, ..., m$.

For each inequality, we build a subcircuit. Since each $x_i$ is binary, each term $a_(j i)x_i$ is either $0$ or $a_(j i)$, so it can be produced by a small selector subcircuit. We then use binary adder circuits to sum all these terms and obtain the left-hand side of the inequality. After that, we use a comparator circuit to check whether this sum is at most $b_j$. Thus, the subcircuit outputs 1 if and only if the inequality is satisfied.

We repeat this construction for every inequality and connect all resulting outputs to a final AND gate. Therefore, the whole circuit outputs 1 if and only if all inequalities are satisfied, that is, if and only if the original 0,1-ILP instance is feasible.

This transformation can be carried out in polynomial time. Indeed, each selector, adder, and comparator circuit has size polynomial in the bit-length of the coefficients and constants, and the number of inequalities and variables is polynomial in the input size. Therefore, the entire circuit has polynomial size and can be constructed in polynomial time.

Hence, we have a polynomial-time reduction from 0,1-ILP to Circuit-SAT. Therefore, Circuit-SAT is NP-hard. Since it is also in NP, it follows that Circuit-SAT is NP-complete.

#pagebreak()
// ---------------------- Problem 4 ----------------------
= SAT and Integer Linear Programming
#colorbox(color: palette.olive)[
  In this  $k$-coloring problem, the graph $G(V,E)$ is shown as @k-coloring-graph below, where $V = {1, 2, 3, 4, 5, 6, 7}$ and $E= {(1,2),(2,3),(3,4),(4,5),(5,1),(1,6),(3,6),(2,7),(4,7)}$.

  #figure(
    canvas({
      import draw: *

      // Vertex positions
      let p1 = (0, 0)
      let p2 = (2, 2)
      let p3 = (5, 2)
      let p4 = (7, 0)
      let p5 = (3.5, -2)

      let p6 = (2.5, 0.5)
      let p7 = (4.5, 0.5)

      // Edges
      line(p1, p2)
      line(p2, p3)
      line(p3, p4)
      line(p4, p5)
      line(p5, p1)

      line(p1, p6)
      line(p3, p6)

      line(p2, p7)
      line(p4, p7)

      // Vertices
      let vertex(pos, label) = {
        fill(white)
        stroke(black)
        circle(pos, radius: 0.32)
        content(pos, box(inset: 0pt, align(center + horizon, text(label))))
      }

      vertex(p1, [1])
      vertex(p2, [2])
      vertex(p3, [3])
      vertex(p4, [4])
      vertex(p5, [5])
      vertex(p6, [6])
      vertex(p7, [7])
    }),
    caption: "Graph for the 𝑘-coloring problem",
  )<k-coloring-graph>

]

== 　 // 4. (a)
To reduce the $k$-coloring problem to SAT, we introduce Boolean variables and construct a Boolean formula that is satisfiable if and only if the graph can be colored with k colors.

=== Case $k=2$

First, considering $k = 2$ case. Let $c_i$ be a Boolean variable indicating the color assigned to vertex $i$, where $c_i in {0, 1}$.

For every edge $(i,j) in E$, the two endpoints must have different colors, so we require $c_i != c_j$.
This is equivalent to the CNF formula
$ (c_i or c_j) and (not c_i or not c_j). $

Therefore, the Boolean formula for the 2-coloring problem is:
$ f_2 = and.big_((i, j) in E) ((c_i or c_j) and (not c_i or not c_j)). $

Refering to one #link("https://willyc20.github.io/2016/12/18/sat-problem-2/")[reference article] about `MiniSat`, we need to express the formula in a specific format file, so called `DIMACS CNF`. The first is the header line, which specifies the number of variables and clauses in the formula. From the 2nd line onwards, we list all the clauses in the formula. The following is my input file for the 2-coloring problem and the result is show in @2-coloring-result below.

#let color_2_sat_input = read("assets/2colorsat.txt")
#zebraw(
  numbering: false,
  highlight-lines: (
    (header: [*2-coloring problem MiniSat input file*]),
  ),
  raw(color_2_sat_input, block: true),
)

#figure(
  image("assets/2colorsat.png", width: 80%),
  caption: "SAT solver result for the 2-coloring problem",
)<2-coloring-result>

=== *Case $k=3$*
For the $k = 3$ case, we use a different encoding. Let $c_(i, c)$ be a Boolean variable indicating whether vertex $i$ is colored with color $c$, where $c in {0, 1, 2}$.

We need to ensure that each vertex is assigned at least one color, that is, for each vertex $i$, we require
$ (c_(i, 0) or c_(i, 1) or c_(i, 2)). $

We also need to ensure that each vertex is assigned at most one color, that is, for each vertex $i$ and for each pair of distinct colors $c$ and $c'$, we require
$ (not c_(i, c) or not c_(i, c')). $

Finally, we need to ensure that adjacent vertices have different colors. For each edge $(i, j) in E$ and for each color $c$, we require
$ (not c_(i, c) or not c_(j, c)). $

Hence, the Boolean formula for the 3-coloring problem is:

$
  f_3 = (
    and.big_(i in V) (x_(i,0) or x_(i,1) or x_(i,2))
  ) \
  and (
    and.big_(i in V) (
      (not x_(i,0) or not x_(i,1))
      and (not x_(i,0) or not x_(i,2))
      and (not x_(i,1) or not x_(i,2))
    )
  ) \
  and (
    and.big_((i,j) in E) and.big_(c = 0)^2 (not x_(i,c) or not x_(j,c))
  )
$

I also create the input file for the 3-coloring problem ($x_(i,c)$ is assign to $3 i-c$ in the DIMACS CNF format) and the result is show in @3-coloring-result below.

#let color_3_sat_input = read("assets/3colorsat.txt")
#zebraw(
  numbering: false,
  highlight-lines: (
    (header: [*3-coloring problem MiniSat input file*]),
  ),
  raw(color_3_sat_input, block: true),
)

#figure(
  image("assets/3colorsat.png", width: 80%),
  caption: "SAT solver result for the 3-coloring problem",
)<3-coloring-result>


== // 4. (b)
To reduce the $k$-coloring problem to Integer Linear Programming (ILP), we introduce the following variables. For each vertex $i in V$ and each color $c in {1, 2, ..., k}$, we introduce a binary variable $x_(i,c)$, where $x_(i,c) = 1$ if vertex $i$ is colored with color $c$, and $0$ otherwise.

We need to ensure that each vertex is assigned exactly one color, which can be expressed as the following constraints:
$ sum_(c=1)^k x_(i,c) = 1, forall i in V. $

We also need to ensure that adjacent vertices have different colors. For each edge $(i, j) in E$ and for each color $c in {1, 2, ..., k}$, we can express this constraint as:
$ x_(i,c) + x_(j,c) <= 1. $

The above constraints can be combined to form the ILP formulation of the $k$-coloring problem. The objective function can be arbitrary (e.g., minimize 0) since we are only interested in feasibility.

By reading the documentation of `lp_solve`, we can write the ILP formulation in its input format. The following is my input file for the 2-coloring problem and the result is show in @2-coloring-ilp-result below.
#let color_2_ilp_input = read("assets/2color.lp")
#zebraw(
  numbering: false,
  highlight-lines: (
    (header: [*2-coloring problem lp_solve input file*]),
  ),
  raw(color_2_ilp_input, block: true),
)
#figure(
  image("assets/2colorilp.png", width: 40%),
  caption: "ILP solver result for the 2-coloring problem",
)<2-coloring-ilp-result>

The following is my input file for the 3-coloring problem and the result is show in @3-coloring-ilp-result below.
#let color_3_ilp_input = read("assets/3color.lp")
#zebraw(
  numbering: false,
  highlight-lines: (
    (header: [*3-coloring problem lp_solve input file*]),
  ),
  raw(color_3_ilp_input, block: true),
)
#figure(
  image("assets/3colorilp.png", width: 50%),
  caption: "ILP solver result for the 3-coloring problem",
)<3-coloring-ilp-result>

#pagebreak()
// ---------------------- Problem 5 ----------------------
= Model of Computation
== // 5. (a)
For the regular expression
$
  (01^*0)^*1,
$
we construct a DFA as follows.
State $q_0$ is the start state.
Reading `0` starts a loop and moves the automaton to $q_1$, where it may read any number of `1`'s.
Reading `0` from $q_1$ completes the loop and returns to $q_0$.
Reading `1` from $q_0$ corresponds to the final symbol of the string, so the automaton moves to the accepting state $q_2$.

Since a DFA must define a transition for every input symbol at every state, we add a trap state $q_t$. Any input read after reaching $q_2$ leads to $q_t$, and $q_t$ loops on both `0` and `1`.

#v(0.5em)
#figure(
  automaton(
    (
      q0: (q1: 0, q2: 1),
      q1: (q0: 0, q1: 1),
      q2: (qt: (0, 1)),
      qt: (qt: (0, 1)),
    ),
    layout: (
      q0: (0, 0),
      q1: (0, -2),
      q2: (3, 0),
      qt: (6, 0),
    ),
    style: (
      q1-q1: (anchor: bottom),
      qt-qt: (anchor: right),
    ),
    initial: "q0",
    final: ("q2",),
  ),
  caption: [DFA for the regular expression $(01^*0)^*1$],
)<dfa-5a>

== // 5. (b)
#colorbox(color: olive)[
  #figure(
    automaton(
      (
        q0: (q0: 0, q1: 1),
        q1: (q1: 1, q2: 0),
        q2: (q0: 0, q1: 1),
      ),
      layout: (
        q0: (0, 0),
        q1: (3, 1.75),
        q2: (3, -1.75),
      ),
      style: (
        q0-q0: (anchor: top),
        q1-q1: (anchor: top),
        q2-q0: (curve: 0.8),
        q0-q1: (curve: 0.8),
      ),
      initial: "q0",
      final: ("q2",),
    ),
    caption: [The finite automaton give in the problem statement],
  )
]
To derive the regular expression for the language accepted by the given automaton, we analyze the paths:
- First time from $q_0$ to $q_2$:
  + zero or many `0`
  + one or many `1`
  + one `0`
  - The regex for this part is $0^*1^+0$.
- Loop back from $q_2$ to $q_0$ to $q_2$:
  + one or many `0`
  + one or many `1`
  + one `0`
  - The regex for this part is $0^+1^+0$.
- Loop back from $q_2$ to $q_1$ to $q_2$:
  + one or many `1`
  + one `0`
  - The regex for this part is $1^+0$.

Combining the looping back parts, we have
$
  (0^+1^+0) union (1^+0) = 0^*1^+0,
$
so the regex for the language accepted by the automaton is
$
  0^*1^+0 (0^*1^+0)^* = (0^*1^+0)^+
$

#pagebreak()
// ---------------------- Problem 6 ----------------------
= Scheduling

