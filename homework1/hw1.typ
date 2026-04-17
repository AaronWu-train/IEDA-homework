#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/wavy:0.1.3"
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))
#show raw.where(lang: "wavy"): it => wavy.render(it.text)

#show: project.with(
  title: "Homework 1",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 1",
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
= Design Methodology and Design Flow

== // 1. (a)
=== Modeling

- *Brain signal model:* Model normal brain signals and seizure-related signals. This helps the system identify abnormal activity.
- *Seizure progression model:* Model how a seizure starts and develops over time. This helps the device detect seizure early and respond at the correct time.
- *Electrode-tissue interaction model:* Model how the electrodes sense neural signals and how electrical stimulation affects brain tissue.
- *Power and thermal model:* Model power consumption and heat generation, because the device is implanted in the brain and must remain safe.

=== Design

- *Sensing design:* Design electrodes and low-noise circuits to acquire weak brain signals clearly and reliably.
- *Detection design:* Design an algorithm or decision logic to determine whether seizure activity is happening or about to happen.
- *Control design:* Design when stimulation should be triggered and determine the proper pulse parameters, such as amplitude, duration, and frequency.
- *Implant hardware design:* Design the stimulator, battery, chip size, and package so the device can work safely for a long time inside the body.

=== Analysis

- *Detection performance analysis:*
  Analyze detection accuracy, false alarm rate, and detection latency.
- *Stimulation effectiveness and safety analysis:*
  Analyze whether stimulation can suppress seizure without damaging brain tissue.
- *Power analysis:*
  Analyze energy consumption and battery lifetime.
- *System-level analysis:*
  Analyze whether sensing, detection, control, and stimulation can operate correctly together in real time.


== 　// 1. (b)
For each components of the CNN system, I suggest components should be implemented as follows:

+ *Image pre-processing (Software / CPU):*

  This stage includes image capture handling, resizing, normalization, and format conversion. It is better placed in software because it requires flexibility and is easier to modify when the input format or application setting changes. Its computation cost is also lower than the main CNN layers.

+ *Convolutional layers (Hardware / FPGA or ASIC):*

  Convolutional layers should be implemented in hardware because they dominate the computation of the CNN. They require a large number of multiply-accumulate operations and have strong parallelism. Hardware acceleration can greatly improve throughput, reduce latency, and save power.

+ *Activation functions, ReLU (Hardware / FPGA or ASIC):*

  ReLU is simple and highly regular. It is applied many times after convolutional layers, so placing it in hardware is efficient.

+ *Pooling layers (Hardware / FPGA or ASIC):*

  Pooling layers should also be implemented in hardware because they are part of the repeated feature extraction pipeline. Their operations are simple and regular, which makes them suitable for efficient streaming hardware design. This helps maintain high throughput.

+ *Fully connected layers (Hardware / FPGA or ASIC):*

  Fully connected layers involve many dense arithmetic operations, especially when the layer size is large. Therefore, they are also suitable for hardware acceleration. Implementing them in hardware improves inference speed and energy efficiency under real-time constraints.

+ *Output stage, softmax + classification (Software / CPU):*

  The output stage has much lower computation cost than convolutional and fully connected layers. It also includes final decision logic, which may need to be adjusted depending on the application. Therefore, it is more suitable to place this part in software for better flexibility and easier debugging.

+ *Overall control and scheduling (Software / CPU):*

  The CPU should manage system control, memory/buffer handling, task scheduling, and communication between modules. These tasks involve control logic rather than massive parallel computation, so software is the more suitable choice.

== // 1. (c)

Main synthesis tasks in VLSI design flow include system specification, functional design, logic synthesis, circuit design, physical design and verification, fabrication, and packaging. In each of the tasks, the design is represented as follows:

+ *System specification:*
  The design is represented as specification. At this stage, it describes system requirements, functions, performance goals, and interfaces at a very high level.

+ *Functional design:*
  The design is represented as behavioral representation. At this stage, the system is described by functional blocks, algorithms, FSM, datapath, or behavioral HDL.

+ *Logic synthesis:*
  The design is converted into structural representation at the logic level. The result is a gate-level netlist, composed of logic gates and flip-flops.

+ *Circuit design:*
  The design is still a structural representation, but now at the transistor level. The result is a transistor-level circuit / schematic built with MOS transistors and their connections.

+ *Physical design and verification:*
  The design is converted into physical representation. At this stage, it becomes chip layout data, including floorplan, placement, routing, and verification such as DRC/LVS.

+ *Fabrication:*
  The physical layout is transferred into silicon manufacturing. The design is represented as masks / wafer patterns used to fabricate the chip.

+ *Packaging:*
  The fabricated die is packaged into a usable IC. The design is represented as the final packaged chip ready for testing and system use.

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
== 　 // 5. (a)
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

== 　 // 5. (b)
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

== 　 // 5. (c)
The required timed automaton is as follows. The label RE stands for "Requesting" and AG stands for "Access Granted".
#figure(
  automaton(
    (
      Idle: (RE: "a"),
      RE: (RE: "c", AG: "d"),
      AG: (Idle: "e"),
    ),
    input-labels: (
      a: [press `a` | `NULL` | $x:=0$],
      c: [press `a` | $x <= 2$ | $x:=0$],
      d: [press `b` | $x >= 1$ | $x:=0$],
      e: [$epsilon$],
    ),
    style: (
      state: (radius: 0.7),
      Idle-Idle: (anchor: top),
    ),
    layout: (
      Idle: (0, 0),
      RE: (6, 2),
      AG: (12, 0),
    ),
  ),
  caption: [Timed automaton for the timed access control system],
)

== 　 // 5. (d)
#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,

    // -- High Priority Producers --
    node((0, 0), align(center)[HP1 Idle \ #sym.circle.filled], shape: "circle", name: <hp1_idle>, radius: 1cm),
    node((0, 1), [Request], shape: "rect", name: <t_hp1_req>),
    node((0, 2), align(center)[HP1 Ready], shape: "circle", name: <hp1_ready>, radius: 1cm),
    node((0, 3), [Produce], shape: "rect", name: <t_hp1_prod>),

    node((3, 0), align(center)[HP2 Idle \ #sym.circle.filled], shape: "circle", name: <hp2_idle>, radius: 1cm),
    node((3, 1), [Request], shape: "rect", name: <t_hp2_req>),
    node((3, 2), align(center)[HP2 Ready], shape: "circle", name: <hp2_ready>, radius: 1cm),
    node((3, 3), [Produce], shape: "rect", name: <t_hp2_prod>),

    // -- Low Priority Producers --
    node((1.5, 0), align(center)[LP Idle \ #sym.circle.filled], shape: "circle", name: <lp1_idle>, radius: 1cm),
    node((1.5, 1), [Request], shape: "rect", name: <t_lp1_req>),
    node((1.5, 2), align(center)[LP Ready], shape: "circle", name: <lp1_ready>, radius: 1cm),
    node((1.5, 3), [Produce], shape: "rect", name: <t_lp1_prod>),

    // -- Bounded Buffer --
    node((1, 4), align(center)[Empty 1 \ #sym.circle.filled], shape: "circle", name: <empty1>, radius: 1cm),
    node((2, 4), align(center)[Full 1], shape: "circle", name: <full1>, radius: 1cm),
    node((1.5, 4.5), [　　], shape: "rect", name: <qt1>),

    node((1, 5), align(center)[Empty 2 \ #sym.circle.filled], shape: "circle", name: <empty2>, radius: 1cm),
    node((2, 5), align(center)[Full 2], shape: "circle", name: <full2>, radius: 1cm),

    node((1.5, 5.5), [　　], shape: "rect", name: <qt2>),

    node((1, 6), align(center)[Empty 3 \ #sym.circle.filled], shape: "circle", name: <empty3>, radius: 1cm),
    node((2, 6), align(center)[Full 3], shape: "circle", name: <full3>, radius: 1cm),

    // -- Consumers --
    node((3, 5), [Consumer \ Arrive], shape: "rect", name: <t_arrive>),

    node(
      (3, 6),
      align(center)[C Wait \ #sym.circle.filled#sym.circle.filled],
      shape: "circle",
      name: <c_wait>,
      radius: 1cm,
    ),
    node((1.5, 6.75), [Consume], shape: "rect", name: <t_consume>),

    // ==========================
    // ARCS & ROUTING
    // ==========================
    edge(<hp1_idle>, <t_hp1_req>, "-|>"),
    edge(<t_hp1_req>, <hp1_ready>, "-|>"),
    edge(<hp1_ready>, <t_hp1_prod>, "-|>"),
    edge(<t_hp1_prod>, <hp1_idle>, "-|>", bend: 45deg),

    edge(<hp2_idle>, <t_hp2_req>, "-|>"),
    edge(<t_hp2_req>, <hp2_ready>, "-|>"),
    edge(<hp2_ready>, <t_hp2_prod>, "-|>"),
    edge(<t_hp2_prod>, <hp2_idle>, "-|>", bend: -45deg),

    edge(<lp1_idle>, <t_lp1_req>, "-|>"),
    edge(<t_lp1_req>, <lp1_ready>, "-|>"),
    edge(<lp1_ready>, <t_lp1_prod>, "-|>"),
    edge(<t_lp1_prod>, <lp1_idle>, "-|>", bend: 45deg),

    edge(<hp1_idle>, (0.8, 0), (0.8, 2.7), <t_lp1_prod>, "-|>"),
    edge(<hp1_idle>, (0.7, 0.3), (0.7, 3), <t_lp1_prod>, "<|-"),
    edge(<hp2_idle>, (2.2, 0), (2.2, 2.7), <t_lp1_prod>, "-|>"),
    edge(<hp2_idle>, (2.3, 0.3), (2.3, 3), <t_lp1_prod>, "<|-"),

    edge(<t_lp1_prod>, <full1>, "-|>"),
    edge(<t_hp1_prod>, <full1>, "-|>"),
    edge(<t_hp2_prod>, <full1>, "-|>"),
    edge(<empty1>, <t_lp1_prod>, "-|>"),
    edge(<empty1>, <t_hp1_prod>, "-|>"),
    edge(<empty1>, <t_hp2_prod>, "-|>"),

    edge(<full1>, <qt1>, "-|>"),
    edge(<qt1>, <empty1>, "-|>"),
    edge(<empty2>, <qt1>, "-|>"),
    edge(<qt1>, <full2>, "-|>"),
    edge(<full2>, <qt2>, "-|>"),
    edge(<qt2>, <empty2>, "-|>"),
    edge(<empty3>, <qt2>, "-|>"),
    edge(<qt2>, <full3>, "-|>"),
    edge(<full3>, <t_consume>, "-|>"),
    edge(<c_wait>, <t_consume>, "-|>", bend: 15deg),
    edge(<t_consume>, <empty3>, "-|>"),
    edge(<t_arrive>, <c_wait>, "-|>"),
  ),
  caption: [ Petri net of the producer-consumer system. For each producer, a token in `Idle` indicates that the producer is inactive and has not received a production request. The `Request` transition is triggered externally and nondeterministically, representing an arbitrary arrival of a production request. Once triggered, the producer moves to `Ready` and becomes eligible to produce. After firing `Produce`, the producer returns to `Idle`. The low-priority producer can fire `Produce` only when both high-priority producers are in `Idle`. The bounded buffer is modeled as a queue of size 3 using the places `Empty 1-3` and `Full 1-3`. The consumer removes items from the front of the queue, preserving FIFO order.],
)

#pagebreak()
// ---------------------- Problem 6 ----------------------
= Scheduling
== Data-Flow Graph (DFG) // 6. (a)
#let semicircle = (node, extrude, ..args) => {
  let w = node.size.at(0) + 2 * extrude
  let r = w

  {
    draw.arc(
      (-r, -0.5 * r),
      start: 180deg,
      stop: 0deg,
      radius: r,
    )
    draw.line((-r, -0.5 * r), (r, -0.5 * r))
  }
}

#let downsemicircle = (node, extrude, ..args) => {
  let w = node.size.at(0) + 2 * extrude
  let r = w

  {
    draw.arc(
      (r, 0.5 * r),
      start: 360deg,
      stop: 180deg,
      radius: r,
    )
    draw.line((-r, 0.5 * r), (r, 0.5 * r))
  }
}

#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,
    node((0, 0), align(center)[$a$], name: <a>, shape: downsemicircle),
    node((1, 0), align(center)[$b$], name: <b>, shape: downsemicircle),
    node((2, 0), align(center)[$c$], name: <c>, shape: downsemicircle),
    node((3, 0), align(center)[$d$], name: <d>, shape: downsemicircle),
    node((4, 0), align(center)[$e$], name: <e>, shape: downsemicircle),
    node((5, 0), align(center)[$f$], name: <f>, shape: downsemicircle),

    node((0.5, 1), align(center)[$+$], name: <add1>, shape: "circle"),
    node((2.5, 1), align(center)[$+$], name: <add2>, shape: "circle"),
    node((4.5, 1), align(center)[$times$], name: <mul1>, shape: "circle"),

    node((1, 1), align(center)[$g_1$], stroke: 0pt),
    node((3, 1), align(center)[$g_2$], stroke: 0pt),
    node((5, 1), align(center)[$g_3$], stroke: 0pt),

    node((1.5, 2), align(center)[$times$], name: <mul2>, shape: "circle"),
    node((2, 2), align(center)[$g_4$], stroke: 0pt),
    node((2.5, 3), align(center)[$+$], name: <add3>, shape: "circle"),
    node((3, 3), align(center)[$g_5$], stroke: 0pt),


    node((2.5, 4), align(center)[$z$], name: <z>, shape: semicircle),

    edge(<a>, <add1>, "-|>"),
    edge(<b>, <add1>, "-|>"),
    edge(<add1>, <mul2>, "-|>"),

    edge(<c>, <add2>, "-|>"),
    edge(<d>, <add2>, "-|>"),
    edge(<add2>, <mul2>, "-|>"),

    edge(<e>, <mul1>, "-|>"),
    edge(<f>, <mul1>, "-|>"),
    edge(<mul1>, <add3>, "-|>"),

    edge(<mul2>, <add3>, "-|>"),

    edge(<add3>, <z>, "-|>"),
  ),
  caption: [The corresponding DFG of $z=(a+b) times (c+d)+(e times f)$],
)

== ASAP Scheduling // 6. (b)

After ASAP scheduling, we need total 4 clock cycles to finish the computation. Addtionally, we need 2 adders and 2 multipliers to achieve this schedule.

#figure(
  wavy.render(
    ```
      {
        signal:
        [
          {name:'clk',wave:'p...'},
          {name:'Adder 1',wave:'2x.2',data:'g1 g5'},
          {name:'Adder 2',wave:'2x..',data:'g2'},
          {name:'Multiplier 1',wave:'2.x.',data:'g3'},
          {name:'Multiplier 2',wave:'x2.x',data:'g4'},
        ],
        config: { hscale: 2 },
      }
    ```.text,
  ),
  caption: [ASAP scheduling result time chart],
)

== ALAP Scheduling // 6. (c)

After ALAP scheduling, we need total 4 clock cycles to finish the computation. Addtionally, we need 2 adders and 2 multipliers to achieve this schedule.
#figure(
  wavy.render(
    ```
      {
        signal:
        [
          {name:'clk',wave:'p...'},
          {name:'Adder 1',wave:'2x.2',data:'g1 g5'},
          {name:'Adder 2',wave:'2x..',data:'g2'},
          {name:'Multiplier 1',wave:'x2.x',data:'g3'},
          {name:'Multiplier 2',wave:'x2.x',data:'g4'},
        ],
        config: { hscale: 2 },
      }
    ```.text,
  ),
  caption: [ALAP scheduling result time chart],
)

#pagebreak()
== Mobility-based Scheduling // 6. (d)

- $g_1$: ASAP = 1, ALAP = 1, mobility = 0
- $g_2$: ASAP = 1, ALAP = 1, mobility = 0
- $g_3$: ASAP = 1, ALAP = 2, mobility = 1
- $g_4$: ASAP = 2, ALAP = 2, mobility = 0
- $g_5$: ASAP = 4, ALAP = 4, mobility = 0

For this mobility, we cannot further reduce the number of functional units, so we still need 2 adders and 2 multipliers. However, we can schedule $g_3$ at either cycle 1 or cycle 2, so there are two possible schedules.
#figure(
  wavy.render(
    ```
      {
        signal:
        [
          {name:'clk',wave:'p...'},
          {name:'Adder 1',wave:'2x.2',data:'g1 g5'},
          {name:'Adder 2',wave:'2x..',data:'g2'},
          {name:'Multiplier 1',wave:'x2.x',data:'g3'},
          {name:'Multiplier 2',wave:'x2.x',data:'g4'},
        ],
        config: { hscale: 2 },
      }
    ```.text,
  ),
  caption: [Mobility-based scheduling result time chart],
)

== Critical-path list scheduling

- Priority: ($P(dot)$ denotes the priority of a node, and $d(dot)$ denotes the delay of a node)
  - $P(g_1) = d(g_1) + d(g_4) + d(g_5) = 4$
  - $P(g_2) = d(g_2) + d(g_4) + d(g_5) = 4$
  - $P(g_3) = d(g_3) + d(g_5) = 3$
  - $P(g_4) = d(g_4) + d(g_5) = 3$
  - $P(g_5) = d(g_5) = 1$

- Schedule:
  - Cycle 1: Ready: $g_1, g_2, g_3$. Schedule $g_1$ and $g_2$  to $A_1$ and $A_2$.
  - Cycle 2: Ready: $g_3, g_4$. Schedule $g_3$ to $A_1$.
  - Cycle 4: Ready: $g_4$. Schedule $g_4$ to $A_1$.
  - Cycle 5: Ready: $g_5$. Schedule $g_5$ to $A_1$.

#figure(
  wavy.render(
    ```
      {
        signal:
        [
          {name:'clk',wave:'p.....'},
          {name:'A1',wave:'22.2.2',data:'g1 g3 g4 g5'},
          {name:'A2',wave:'2x....',data:'g2'},
        ],
        config: { hscale: 2 },
      }
    ```.text,
  ),
  caption: [Critical-path list scheduling result time chart],
)
