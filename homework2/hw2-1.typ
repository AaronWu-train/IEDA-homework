#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/k-mapper:1.4.0": *
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/wavy:0.1.3"
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))
#show raw.where(lang: "wavy"): it => wavy.render(it.text)

#show: project.with(
  title: "Homework 2",
  subtitle: "(Problems 1-5)",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 2 (part 1)",
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
= Cofactor
== 　 // 1. (a)
The equalities does not hold for $u$ and $v$ is a literal for the same variable. For example, let $f(x) = x$, $u = x$, and $v = not x$. Then, $f_u = 1$ and $(f_u)_v = 1$, but $f_v = 0$ and $(f_v)_u = 0$.

== 　 // 1. (b)

Let $v$ be a literal of variable $x$.
If $v=x$, then
$
  (not f)_v = (not f)|_(x=1) = not (f|_(x=1)) = not (f_v)
$

If $v=not x$, then
$
  (not f)_v = (not f)|_(x=0) = not (f|_(x=0)) = not (f_v)
$
Hence, $(not f)_v = not (f_v)$ for any literal $v$.

== 　 // 1. (c)

Let $v$ be a literal of variable $x$.
By Shannon expansion,
$
  f = x f_x + not x f_(not x)
$
and
$
  g = x g_x + not x g_(not x).
$

We first prove the case $v = x$.
Using Shannon expansion on the function $f ⊕ g$, we have
$
  f ⊕ g
  = x (f ⊕ g)_x + not x (f ⊕ g)_(not x).
$
On the other hand, substituting the Shannon expansions of $f$ and $g$ into
$f ⊕ g$, we get
$
  f ⊕ g
  = (x f_x + not x f_(not x)) ⊕ (x g_x + not x g_(not x)).
$
When $x = 1$, this becomes
$
  (f ⊕ g)_(v) = (f ⊕ g)|_(x=1) = f_x ⊕ g_x
$

Next, when $v = not x$, setting $x = 0$ in the same expansion gives
$
  (f ⊕ g)_(v) = (f ⊕ g)|_(x=0) = f_(not x) ⊕ g_(not x) = f_v ⊕ g_v.
$

Therefore, in both cases,
$
  (f ⊕ g)_v = f_v ⊕ g_v.
$
Hence $(f ⊕ g)_v = (f_v) ⊕ (g_v)$ is true.

= Quantified Boolean Formula
By De Morgan's law, we have
$
  not (exists x f(x)) = forall x (not f(x)) \
  not (forall x f(x)) = exists x (not f(x))
$

== 　 // 2. (a)
For $=>$, we have
$
  not(forall x, exists y. f(x, y, z))
  equiv exists x. not(exists y. f(x, y, z))
  equiv exists x. forall y. not f(x, y, z).
$

For $arrow.l.double$, we have
$
  exists x. forall y. not f(x, y, z)
  equiv not(forall x. not(forall y. not f(x, y, z)))
  equiv not(forall x. exists y. f(x, y, z)).
$

Therefore, both directions hold, and hence the equivalence is true.


== 　 // 2. (b)
For $(=>)$, consider the following counterexample:
$
  f(x, y, z) = (x ∧ y) ∨ (x ∧ ¬y).
$

Then $exists x. forall y. f(x, y, z)$
is true, since by choosing $x = 1$, we have
$
  f(1, y, z) = (1 ∧ y) ∨ (1 ∧ ¬y) = y ∨ ¬y = 1
$
for all $y$.

However, $forall x. exists y. f(x, y, z)$
is false, since when $x = 0$, we have
$
  f(0, y, z) = (0 ∧ y) ∨ (0 ∧ ¬y) = 0
$
for every $y$.
Hence, there is no value of $y$ that makes $f$ true.

For $(arrow.l.double)$, consider the following counterexample:
$
  f(x, y, z) = (x ∧ y) ∨ (¬x ∧ ¬y).
$

Then
$forall x. exists y. f(x, y, z)$
is true, since:
- when $x = 1$, choosing $y = 1$ makes $f$ true;
- when $x = 0$, choosing $y = 0$ makes $f$ true.

However,
$exists x. forall y. f(x, y, z)$
is false, since:
- if $x = 1$, then $f(x, y, z) = y$, which is not true for all $y$;
- if $x = 0$, then $f(x, y, z) = ¬y$, which is not true for all $y$.

Hence, neither direction holds in general.

== 　 // 2. (c)
For $(=>)$, assume
$exists x. forall y. f(x, y, z)$
is true. Then there exists some fixed $x$ such that $f(x, y, z)$ is true for all $y$. Let this $x$ be $s$. Then, for every $y$, we have $f(s, y, z)$ is true.
Hence, for every $y$, we can choose that same $x=s$, so
$forall y. exists x. f(x, y, z)$
is true.

For $(arrow.l.double)$, consider the following counterexample:
$
  f(x, y, z) = (x ∧ y) ∨ (¬x ∧ ¬y).
$
Then
$forall y. exists x. f(x, y, z)$
is true, since:
- when $y = 1$, choose $x = 1$;
- when $y = 0$, choose $x = 0$.
However,
$exists x. forall y. f(x, y, z)$
is false, since:
- if $x = 1$, then $f(x, y, z) = y$, which is not true for all $y$;
- if $x = 0$, then $f(x, y, z) = ¬y$, which is not true for all $y$.

Hence, only $(=>)$ holds in general.

== 　 // 2. (d)
For $(=>)$, we use the following implication steps:

+ $forall x. (f(x, y) and g(x, z))$  (premise)
+ $f(u, y) and g(u, z)$  (UI, 1, with $x = u$ is arbitrary)
+ $f(u, y)$  (simplification, 2)
+ $forall x. f(x, y)$  (UG, 3)
+ $g(u, z)$  (simplification, 2)
+ $forall x. g(x, z)$  (UG, 5)
+ $forall x. f(x, y) and forall x. g(x, z)$ (conjunction, 4 and 6)

Hence, $forall x. (f(x, y) and g(x, z))$ implies $forall x. f(x, y) and forall x. g(x, z)$.

For $(arrow.l.double)$, we use the following implication steps:
+ $forall x. f(x, y) and forall x. g(x, z)$  (premise)
+ $forall x. f(x, y)$  (simplification, 1)
+ $f(u, y)$  (UI, 2, with $x = u$ is arbitrary)
+ $forall x. g(x, z)$  (simplification, 1)
+ $g(u, z)$  (UI, 4, with $x = u$ is arbitrary)
+ $f(u, y) and g(u, z)$  (conjunction, 3 and 5)
+ $forall x. (f(x, y) and g(x, z))$  (UG, 6)

Hence, $forall x. f(x, y) and forall x. g(x, z)$ implies $forall x. (f(x, y) and g(x, z))$. Thus, the equivalence is true.

== 　 // 2. (e)

For $(=>)$, consider the following counterexample:
$ f(x, y) = x or y quad "and" quad g(x, z) = not x or z $
Then $forall x. (f(x, y) or g(x, z))$ is true, since
$ f(x, y) or g(x, z) = (x or y) or (not x or z) = x or not x or y or z = 1 or y or z = 1 $ for every $x$.
However, $forall x. f(x, y) or forall x. g(x, z)$ is false, since consider $x = 0$, we have $f(x, y) = y$ and $g(x, z) = z$, which are not true for all $y$ and $z$.

For $(arrow.l.double)$:

Assume
$
  forall x. f(x, y) or forall x. g(x, z).
$

Case 1:
$
  forall x. f(x, y)
$
Then for arbitrary $u$:
$
  f(u, y)
$
Hence
$
  f(u, y) or g(u, z)
$
Thus
$
  forall x. (f(x, y) or g(x, z)).
$

Case 2:
$
  forall x. g(x, z)
$
Similarly:
$
  forall x. (f(x, y) or g(x, z)).
$

Therefore,
$
  forall x. f(x, y) or forall x. g(x, z)
  ->
  forall x. (f(x, y) or g(x, z)).
$

Hence, only $(arrow.l.double)$ holds in general.

= Boolean Function Representation
#colorbox(color: olive)[
  Consider the majority function $f (x_1, x_2, x_3, x_4, x_5) = (x_1 + x_2 + x_3 + x_4 + x_5 >= 3)$.
]

== 　 // 3. (a)
The K-map of $f$:

#columns(2)[
  - *Case 1*: $x_5 = 1$.
    // @typstyle off
    #karnaugh(
    "4x4",
    labels: ($x_1$, $x_2$, $x_3$, $x_4$),
    manual-terms: (
      0, 0, 0, 1,
      0, 1, 1, 1,
      0, 1, 1, 1,
      1, 1, 1, 1,
    ),
    implicants: ((5, 15), (7, 14), (13, 11), (15, 10), (12, 14),(3, 11)),
    corner-implicants: false,
  )

  #colbreak()

  - *Case 2*: $x_5 = 0$.
    // @typstyle off
    #karnaugh(
    "4x4",
    labels: ($x_1$, $x_2$, $x_3$, $x_4$),
    manual-terms: (
      0, 0, 0, 0,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 1, 1, 1,
    ),
    implicants: ((15, 11), (13, 15), (15, 14), (7, 15)),
    // colors: (rgb(150, 150, 150, 50), )
  )
]
Hence, the minimal sum-of-products form of $f$ is
$
  f & = x_1 x_2 x_3 + x_1 x_2 x_4 + x_1 x_2 x_5 \
    & + x_1 x_3 x_4 + x_1 x_3 x_5 + x_1 x_4 x_5 \
    & + x_2 x_3 x_4 + x_2 x_3 x_5 + x_2 x_4 x_5 \
    & + x_3 x_4 x_5.
$

== 　 // 3. (b)
By turnning the minimal sum-of-products form into a product-of-sums form, we have
$
  f & = (x_1 + x_2 + x_3) (x_1 + x_2 + x_4) (x_1 + x_2 + x_5) \
    & (x_1 + x_3 + x_4) (x_1 + x_3 + x_5) (x_1 + x_4 + x_5) \
    & (x_2 + x_3 + x_4) (x_2 + x_3 + x_5) (x_2 + x_4 + x_5) \
    & (x_3 + x_4 + x_5).
$
which is the minimal product-of-sums form of $f$.

== 　 // 3. (c)
#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,
    node((3, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),

    node((2, 1), align(center)[$x_2$], name: <x21>, shape: "circle"),
    node((4, 1), align(center)[$x_2$], name: <x22>, shape: "circle"),

    node((1, 2), align(center)[$x_3$], name: <x31>, shape: "circle"),
    node((3, 2), align(center)[$x_3$], name: <x32>, shape: "circle"),
    node((5, 2), align(center)[$x_3$], name: <x33>, shape: "circle"),

    node((2, 3), align(center)[$x_4$], name: <x41>, shape: "circle"),
    node((4, 3), align(center)[$x_4$], name: <x42>, shape: "circle"),

    node((3, 4), align(center)[$x_5$], name: <x51>, shape: "circle"),

    node((2, 5.5), align(center)[$1$], name: <one>, shape: "rect"),
    node((4, 5.5), align(center)[$0$], name: <zero>, shape: "rect"),

    edge(<x1>, <x21>, "-|>", label: "1"),
    edge(<x1>, <x22>, "--|>", label: "0", stroke: red),

    edge(<x21>, <x31>, "-|>", label: "1"),
    edge(<x21>, <x32>, "--|>", label: "0", stroke: red),

    edge(<x22>, <x32>, "-|>", label: "1"),
    edge(<x22>, <x33>, "--|>", label: "0", stroke: red),

    edge(<x31>, <one>, "-|>", label: "1", label-side: right, bend: -15deg),
    edge(<x31>, <x41>, "--|>", label: "0", stroke: red),
    edge(<x32>, <x41>, "-|>", label: "1"),
    edge(<x32>, <x42>, "--|>", label: "0", stroke: red),
    edge(<x33>, <x42>, "-|>", label: "1"),
    edge(<x33>, <zero>, "--|>", label: "0", label-side: left, bend: 15deg, stroke: red),

    edge(<x41>, <one>, "-|>", label: "1"),
    edge(<x41>, <x51>, "--|>", label: "0", stroke: red),
    edge(<x42>, <x51>, "-|>", label: "1"),
    edge(<x42>, <zero>, "--|>", label: "0", stroke: red),

    edge(<x51>, <one>, "-|>", label: "1", label-side: left, bend: 15deg),
    edge(<x51>, <zero>, "--|>", label: "0", label-side: right, bend: -15deg, stroke: red),
  ),
  caption: [The ROBDD of $f$.],
)

== 　 // 3. (d)
#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,
    node((0, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),
    node((0, 1), align(center)[$x_2$], name: <x2>, shape: "circle"),
    node((0, 2), align(center)[$x_3$], name: <x3>, shape: "circle"),
    node((0, 3), align(center)[$x_4$], name: <x4>, shape: "circle"),
    node((0, 4), align(center)[$x_5$], name: <x5>, shape: "circle"),

    node((2, 0), [$n_1$], name: <n1>, shape: "circle"),
    edge(<x1>, <n1>, "-|>"),
    edge(<x2>, <n1>, "-|>"),

    node((2, 1), [$n_2$], name: <n2>, shape: "circle"),
    edge(<x1>, <n2>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<x2>, <n2>, marks: (
      (inherit: "circle", pos: 0.45, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((2, 2), [$n_3$], name: <n3>, shape: "circle"),
    edge(<x3>, <n3>, "-|>"),
    edge(<x4>, <n3>, "-|>"),

    node((2, 3), [$n_4$], name: <n4>, shape: "circle"),
    edge(<x3>, <n4>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<x4>, <n4>, marks: (
      (inherit: "circle", pos: 0.45, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((4, 2), [$n_5$], name: <n5>, shape: "circle"),
    edge(<n2>, <n5>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n4>, <n5>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((4, 1), [$n_6$], name: <n6>, shape: "circle"),
    edge(<n1>, <n6>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n3>, <n6>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((6, 2), [$n_7$], name: <n7>, shape: "circle"),
    edge(
      <x5>,
      <n7>,
      marks: (
        (inherit: "circle", pos: 0.6, fill: auto),
        (inherit: "|>", pos: 1, fill: auto),
      ),
      bend: -10deg,
    ),
    edge(<n5>, <n7>, marks: (
      (inherit: "circle", pos: 0.5, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((6, 4), [$n_8$], name: <n8>, shape: "circle"),
    edge(<x5>, <n8>, "-|>"),
    edge(<n5>, <n8>, "-|>"),


    node((7, 1), [$n_9$], name: <n9>, shape: "circle"),
    edge(<n6>, <n9>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n7>, <n9>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((8, 2), [$n_10$], name: <n10>, shape: "circle"),
    edge(<n8>, <n10>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n9>, <n10>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((10, 2), align(center)[$f$], name: <f>, shape: "rect"),
    edge(<n10>, <f>, "-*-|>"),
  ),
  caption: [The AIG of $f$. Use total 10 nodes.],
)

#pagebreak()
== 　 // 3. (e)

We can express $f$ as:
$
  f = M(x_1, space M(x_2, x_3, x_5), space M(x_4, x_5, M(x_1, x_2, x_3)))
$

#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,
    node((0, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),
    node((0, 1), align(center)[$x_2$], name: <x2>, shape: "circle"),
    node((0, 2), align(center)[$x_3$], name: <x3>, shape: "circle"),
    node((0, 3), align(center)[$x_4$], name: <x4>, shape: "circle"),
    node((0, 4), align(center)[$x_5$], name: <x5>, shape: "circle"),

    node((2, 1), "M", name: <m1>, shape: "rect"),
    edge(<x1>, <m1>, "-|>"),
    edge(<x2>, <m1>, "-|>"),
    edge(<x3>, <m1>, "-|>"),

    node((3, 2), "M", name: <m2>, shape: "rect"),
    edge(<m1>, <m2>, "-|>"),
    edge(<x4>, <m2>, "-|>"),
    edge(<x5>, <m2>, "-|>"),

    node((3, 3), "M", name: <m3>, shape: "rect"),
    edge(<x2>, <m3>, "-|>"),
    edge(<x3>, <m3>, "-|>"),
    edge(<x5>, <m3>, "-|>"),

    node((4, 1), "M", name: <m4>, shape: "rect"),
    edge(<x1>, <m4>, "-|>"),
    edge(<m2>, <m4>, "-|>"),
    edge(<m3>, <m4>, "-|>"),

    node((5, 1), align(center)[$f$], name: <f>, shape: circle, stroke: 0pt),
    edge(<m4>, <f>, "-|>"),
  ),
  caption: [The circuit of $f$ using  3-input majority gates. Use total 4 gates.],
)



= Application of Quantified Boolean Formula

== 　 // 4. (a)
First of all, this game only has five stones, so it must terminate within at most five rounds. Hence, we can encode the winning condition of player 1 as the following QBF:

$
  exists M_1. forall M_2. exists M_3. forall M_4. exists M_5. quad Phi
$

where $M_t$ denotes the Boolean variables describing the move at round $t$, and $Phi$ is a Boolean formula encoding legality, state transition, and winning condition.


We now define the move variables. Let $m_(t,i,a)$ denote “at round $t$, the player removes $a$ stones from pile $i$”. The possible moves are:

$
  m_(t,1,1), m_(t,1,2), m_(t,2,1), m_(t,2,2), m_(t,3,1)
$

Thus, $M_t$ is simply a shorthand for the set of move variables
$
  {m_(t,1,1), m_(t,1,2), m_(t,2,1), m_(t,2,2), m_(t,3,1)}.
$

Since each round consists of exactly one move, we impose a one-hot constraint:

$
  "ONE"_t = & (m_(t,1,1) or m_(t,1,2) or m_(t,2,1) or m_(t,2,2) or m_(t,3,1)) \
            & and.big_(x != y in M_t) not (x and y)
$

which enforces that exactly one move is chosen at round $t$.

Next, we encode the state. Instead of using integers, we use Boolean variables to represent whether each stone is still present. Let

$
  a_1^t, a_2^t, b_1^t, b_2^t, c^t
$

denote the existence of each stone after round $t$. Here, $a_1, a_2$ are the two stones in pile $1$, $b_1, b_2$ are the two stones in pile $2$, and $c$ is the unique stone in pile $3$.

Initially, all stones are present:

$
  "I" = a_1^0 and a_2^0 and b_1^0 and b_2^0 and c^0
$

To avoid invalid encodings, we enforce monotonicity within each pile:

$
  "O" = & and.big_(t=0)^5 (a_2^t -> a_1^t) \
        & and.big_(t=0)^5 (b_2^t -> b_1^t)
$
This ensures that the second stone in a pile cannot exist if the first stone has already been removed. Hence, in each two-stone pile, the first stone cannot be absent while the
second stone is still present.

Next, we ensure move legality. A move can only be applied if enough stones remain:

$
  "L"_t = & (m_(t,1,1) -> a_1^(t-1)) \
          & (m_(t,1,2) -> a_2^(t-1)) \
          & (m_(t,2,1) -> b_1^(t-1)) \
          & (m_(t,2,2) -> b_2^(t-1)) \
          & (m_(t,3,1) -> c^(t-1))
$

Now we define the state transition. Let $"T"_t$ encode how the state changes after round $t$. The chosen pile loses stones, while the others remain unchanged.

#text(size: 10pt)[
  $
    "T"_t = & (m_(t,1,1) -> (
                  (a_2^(t-1) -> (a_1^t and not a_2^t)) and
                  (not a_2^(t-1) -> (not a_1^t and not a_2^t)) and
                  (b_1^t <-> b_1^(t-1)) and
                  (b_2^t <-> b_2^(t-1)) and
                  (c^t <-> c^(t-1))
                )) \
            & and (m_(t,1,2) -> (
                  (not a_1^t and not a_2^t) and
                  (b_1^t <-> b_1^(t-1)) and
                  (b_2^t <-> b_2^(t-1)) and
                  (c^t <-> c^(t-1))
                )) \
            & and (m_(t,2,1) -> (
                  (b_2^(t-1) -> (b_1^t and not b_2^t)) and
                  (not b_2^(t-1) -> (not b_1^t and not b_2^t)) and
                  (a_1^t <-> a_1^(t-1)) and
                  (a_2^t <-> a_2^(t-1)) and
                  (c^t <-> c^(t-1))
                )) \
            & and (m_(t,2,2) -> (
                  (not b_1^t and not b_2^t) and
                  (a_1^t <-> a_1^(t-1)) and
                  (a_2^t <-> a_2^(t-1)) and
                  (c^t <-> c^(t-1))
                )) \
            & and (m_(t,3,1) -> (
                  (not c^t) and
                  (a_1^t <-> a_1^(t-1)) and
                  (a_2^t <-> a_2^(t-1)) and
                  (b_1^t <-> b_1^(t-1)) and
                  (b_2^t <-> b_2^(t-1))
                ))
  $
]

Finally, define the empty condition:

$
  "E"_t = not a_1^t and not a_2^t and not b_1^t and not b_2^t and not c^t
$

Thus, $"E"_t$ means that all stones have been removed after round $t$.

Since player $1$ moves at rounds $1$, $3$, and $5$, player $1$ wins exactly when the game first becomes empty at one of these rounds:

$
  "W" = & "E"_1
          or (not "E"_1 and not "E"_2 and "E"_3)
          or (not "E"_1 and not "E"_2 and not "E"_3 and not "E"_4 and "E"_5)
$

Therefore, the final Boolean formula is

$
  Phi & = "I" and "O" and ("ONE"_1 and "L"_1 and "T"_1) and \
      & quad (("ONE"_2 and "L"_2) -> (
        "T"_2 and ("ONE"_3 and "L"_3 and "T"_3) and \
      & quad quad (("ONE"_4 and "L"_4) -> (
            "T"_4 and ("ONE"_5 and "L"_5 and "T"_5) and "W"
          )))
$
Note that rounds 2 and 4 are guarded by implications because they are
universally quantified. Hence illegal moves of player 2 do not falsify the QBF
directly, while player 1 is still required to choose legal moves at rounds 1, 3,
and 5.

This completes the QBF encoding of the winning condition for player $1$.

== 　 // 4. (b)
By manual reasoning, the formula is true. In part (a), the quantified variables are the move variables inside each $M_t$. Thus, to show the formula is true, it suffices to give a winning assignment strategy for player $P_1$.

For the first move, let $P_1$ choose
$
  m_(1,3,1) = 1
$
and set all other variables in $M_1$ to $0$. This means that player $P_1$ removes the only stone from pile $3$. After this move, the state becomes
$
  (2,2,0).
$

Now the two remaining nonempty piles have the same number of stones. We claim that $P_1$ can always maintain this property. More precisely, the existential assignments for $M_3$ and $M_5$ are chosen according to the universally chosen move of $P_2$:

- if $P_2$ chooses $m_(t,1,1) = 1$, then $P_1$ chooses $m_(t+1,2,1) = 1$;
- if $P_2$ chooses $m_(t,1,2) = 1$, then $P_1$ chooses $m_(t+1,2,2) = 1$;
- if $P_2$ chooses $m_(t,2,1) = 1$, then $P_1$ chooses $m_(t+1,1,1) = 1$;
- if $P_2$ chooses $m_(t,2,2) = 1$, then $P_1$ chooses $m_(t+1,1,2) = 1$.

In each case, all other move variables in that round are set to $0$, so the one-hot constraint is satisfied.

Therefore, after every move of $P_2$, player $P_1$ makes the same move on the other nonempty pile. Hence the two piles remain equal after each move of $P_1$. Since the game starts from $(2,2,0)$ after the first move of $P_1$, this mirror strategy guarantees that whenever $P_2$ makes the piles unequal, $P_1$ immediately restores equality. As a result, $P_2$ can never take the last stone first, and eventually $P_1$ takes the last stone.

Therefore, the QBF is true, and the corresponding winning strategy is:
$
  m_(1,3,1) = 1
$
for the first move, and afterwards choose the matching move on the other pile in response to player $P_2$'s move.


#pagebreak()
= Binary Decision Diagram

== 　 // 5. (a)
Let $f(x_1, x_2, dots, x_n)$ be a any n-input Boolean function. WLOG, we can assume the variable ordering is $x_1 < x_2 < dots < x_n$. We want to show that the ROBDD of $f$ is unique. We prove this by induction on $n$.

*Base case*: $n = 1$. In this case, f can only be one of the following four functions:
+ $f(x_1) = 0$;
+ $f(x_1) = 1$;
+ $f(x_1) = x_1$;
+ $f(x_1) = not x_1$.
The ROBDD of each of these functions is unique as shown below:
#columns(4)[
  #align(center)[
    #diagram(
      node-stroke: 1pt,
      edge-stroke: 1pt,
      spacing: 1cm,
      node((0, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),
      node((0, 1), align(center)[$0$], name: <zero>, shape: "rect"),
      edge(<x1>, <zero>, "-|>", label: "1", bend: -15deg),
      edge(<x1>, <zero>, "--|>", label: "0", stroke: red, bend: 15deg),
    )

    $f(x_1) = 0$
  ]

  #colbreak()
  #align(center)[
    #diagram(
      node-stroke: 1pt,
      edge-stroke: 1pt,
      spacing: 1cm,
      node((0, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),
      node((0, 1), align(center)[$1$], name: <zero>, shape: "rect"),
      edge(<x1>, <zero>, "-|>", label: "1", bend: -15deg),
      edge(<x1>, <zero>, "--|>", label: "0", stroke: red, bend: 15deg),
    )

    $f(x_1) = 1$
  ]

  #colbreak()
  #align(center)[
    #diagram(
      node-stroke: 1pt,
      edge-stroke: 1pt,
      spacing: 1cm,
      node((0.5, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),
      node((0, 1), align(center)[$1$], name: <one>, shape: "rect"),
      node((1, 1), align(center)[$0$], name: <zero>, shape: "rect"),
      edge(<x1>, <zero>, "--|>", label: "0", stroke: red),
      edge(<x1>, <one>, "-|>", label: "1"),
    )

    $f(x_1) = x_1$
  ]

  #colbreak()
  #align(center)[
    #diagram(
      node-stroke: 1pt,
      edge-stroke: 1pt,
      spacing: 1cm,
      node((0.5, 0), align(center)[$x_1$], name: <x1>, shape: "circle"),
      node((0, 1), align(center)[$1$], name: <one>, shape: "rect"),
      node((1, 1), align(center)[$0$], name: <zero>, shape: "rect"),
      edge(<x1>, <one>, "--|>", label: "0", stroke: red),
      edge(<x1>, <zero>, "-|>", label: "1"),
    )

    $f(x_1) = not x_1$
  ]
]

*Induction step:* Assume the statement holds for any arbitrary Boolean function with
$n = 1, 2, dots, k - 1$. We want to show that the statement also holds for
$n = k$.

Let
$f(x_1, x_2, dots, x_k)$
be a $k$-input Boolean function. By Shannon expansion, we have
$
  f = x_1 f_(x_1) + not x_1 f_(not x_1).
$

By the fixed variable ordering, the root node is labeled by $x_1$. Its high child
must represent $f_(x_1)$, and its low child must represent $f_(not x_1)$.

By the induction hypothesis, both $f_(x_1)$ and $f_(not x_1)$ are $(k-1)$-input Boolean functions, so
the ROBDD of $f_(x_1)$ and the ROBDD
of $f_(not x_1)$ is unique. Let these two unique ROBDDs be $D_1$ and
$D_0$, respectively.

If $D_1 = D_0$, then the root has two identical children, so by the reduction
rule of ROBDD, the root is eliminated. Hence the ROBDD of $f$ is exactly
$D_1$, which is unique.

If $D_1 != D_0$, then the root remains. Now consider any rooted subgraph in
$D_1$ and any rooted subgraph in $D_0$. If they represent the same Boolean
function, then by the induction hypothesis each of them must be the unique
ROBDD of that function. Therefore they are isomorphic and must be merged by
the reduction rule. Hence, after all possible merges are performed, the resulting
ROBDD is uniquely determined.

Therefore, the ROBDD of $f$ is unique. This completes the induction step.
#pagebreak()
== 　 // 5. (b)
$
  f = and.big_(i=1)^n (x_i or y_i)
$
=== Case 1: $O(n) "nodes"$
Consider the order of variables to be $x_1 < y_1 < x_2 < y_2 < dots < x_n < y_n$. We can construct an ROBDD of $f$ having $O(n)$ nodes as shown below:

#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,
    node((0, 7), align(center)[$1$], name: <one>, shape: "rect", radius: 0.5cm),
    node((2, 7), align(center)[$0$], name: <zero>, shape: "rect", radius: 0.5cm),

    node((0, 0), align(center)[$x_1$], name: <x1>, shape: "circle", radius: 0.5cm),
    node((2, 0.5), align(center)[$y_1$], name: <y1>, shape: "circle", radius: 0.5cm),
    edge(<x1>, <y1>, "--|>", stroke: red, label: "0"),
    edge(<y1>, <zero>, "--|>", stroke: red, label: "0", label-pos: 0.05, label-side: left, bend: 30deg),
    edge(<x1>, <x2>, "-|>", label: "1"),
    edge(<y1>, <x2>, "-|>", label: "1"),


    node((0, 1), align(center)[$x_2$], name: <x2>, shape: "circle", radius: 0.5cm),
    node((2, 1.5), align(center)[$y_2$], name: <y2>, shape: "circle", radius: 0.5cm),
    edge(<x2>, <y2>, "--|>", stroke: red, label: "0"),
    edge(<y2>, <zero>, "--|>", stroke: red, label: "0", label-pos: 0.05, label-side: left, bend: 30deg),
    edge(<x2>, <x3>, "-|>", label: "1"),
    edge(<y2>, <x3>, "-|>", label: "1"),

    node((0, 2), align(center)[$x_3$], name: <x3>, shape: "circle", radius: 0.5cm),
    node((2, 2.5), align(center)[$y_3$], name: <y3>, shape: "circle", radius: 0.5cm),
    edge(<x3>, <y3>, "--|>", stroke: red, label: "0"),
    edge(<y3>, <zero>, "--|>", stroke: red, label: "0", label-pos: 0.05, label-side: left, bend: 30deg),
    edge(<x3>, <x4>, "-|>", label: "1"),
    edge(<y3>, <x4>, "-|>", label: "1"),

    node((0, 3), align(center)[$x_4$], name: <x4>, shape: "circle", radius: 0.5cm),
    edge(<x4>, <xd>, "-"),
    node((0, 4), align(center)[$dots.v$], name: <xd>, shape: "circle", radius: 0.5cm, stroke: 0pt),
    edge(<xd>, <xn>, "-|>"),
    node((0, 5), align(center)[$x_n$], name: <xn>, shape: "circle", radius: 0.5cm),
    node((2, 5.5), align(center)[$y_n$], name: <yn>, shape: "circle", radius: 0.5cm),
    edge(<xn>, <yn>, "--|>", stroke: red, label: "0"),
    edge(<yn>, <zero>, "--|>", stroke: red, label: "0", label-pos: 0.45, label-side: right, bend: 20deg),
    edge(<xn>, <one>, "-|>", label: "1"),
    edge(<yn>, <one>, "-|>", label: "1"),
  ),
  caption: [An ROBDD of $f$ with $O(n)$ nodes.],
)

=== Case 2: $O(2^n) "nodes"$
Consider the variable order
$x_1 < x_2 < dots < x_n < y_1 < y_2 < dots < y_n .$
We show that the ROBDD of
$f = and.big_(i=1)^n (x_i or y_i)$
has $O(2^n)$ nodes.

First, consider the part of the ROBDD before any $y$-variable is tested. Since the variables $x_1, dots, x_n$ are tested first,   this part forms a binary decision tree of height $n$. Hence it contains
$2^n - 1$
nodes.

Next, after all $x_1, dots, x_n$ are assigned, the remaining function is determined by the set of indices $i$ such that $x_i = 0$. For each assignment
$(x_1, dots, x_n) = (a_1, dots, a_n) in {0,1}^n,$
the residual function is
$and.big_(i : a_i = 0) y_i .$
Since there are only $2^n$ possible subsets of ${1, dots, n}$, there are at most $2^n$ distinct residual functions. Because an ROBDD merges identical subgraphs, the part below the $x_n$-level contains at most $2^n$ distinct subgraphs.

Therefore, the total number of nodes is at most
$(2^n - 1) + 2^n = 2^(n+1) - 1 = O(2^n).$
Hence the ROBDD has $O(2^n)$ nodes.

An example of such an ROBDD with $n=3$ is shown below:
#figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: 1cm,
    node((3, 0), align(center)[$x_1$], name: <x1>, shape: "circle", radius: 0.5cm),
    node((1, 1), align(center)[$x_2$], name: <x21>, shape: "circle", radius: 0.5cm),
    node((5, 1), align(center)[$x_2$], name: <x22>, shape: "circle", radius: 0.5cm),
    node((0, 2), align(center)[$x_3$], name: <x31>, shape: "circle", radius: 0.5cm),
    node((2, 2), align(center)[$x_3$], name: <x32>, shape: "circle", radius: 0.5cm),
    node((4, 2), align(center)[$x_3$], name: <x33>, shape: "circle", radius: 0.5cm),
    node((6, 2), align(center)[$x_3$], name: <x34>, shape: "circle", radius: 0.5cm),

    edge(<x1>, <x21>, "-|>"),
    edge(<x1>, <x22>, "--|>", stroke: red),
    edge(<x21>, <x31>, "-|>"),
    edge(<x21>, <x32>, "--|>", stroke: red),
    edge(<x22>, <x33>, "-|>"),
    edge(<x22>, <x34>, "--|>", stroke: red),

    node((3, 3), align(center)[$y_1$], name: <y11>, shape: "circle", radius: 0.5cm),
    node((4.333, 3), align(center)[$y_1$], name: <y12>, shape: "circle", radius: 0.5cm),
    node((5.666, 3), align(center)[$y_1$], name: <y13>, shape: "circle", radius: 0.5cm),
    node((7, 3), align(center)[$y_1$], name: <y14>, shape: "circle", radius: 0.5cm),

    edge(<x33>, <y11>, "--|>", stroke: red),
    edge(<x33>, <y12>, "-|>"),
    edge(<x34>, <y13>, "--|>", stroke: red),
    edge(<x34>, <y14>, "-|>"),

    node((2, 4), align(center)[$y_2$], name: <y21>, shape: "circle", radius: 0.5cm),
    node((4, 4), align(center)[$y_2$], name: <y22>, shape: "circle", radius: 0.5cm),

    edge(<x32>, <y21>, "--|>", stroke: red),
    edge(<x32>, <y22>, "-|>", bend: -30deg),
    edge(<y11>, <y21>, "-|>"),
    edge(<y12>, <y22>, "-|>"),

    node((2, 5), align(center)[$y_3$], name: <y31>, shape: "circle", radius: 0.5cm),
    edge(<x31>, <y31>, "--|>", stroke: red),
    edge(<y21>, <y31>, "-|>"),
    edge(<y13>, <y31>, "-|>", bend: 30deg),

    node((2, 8), align(center)[$1$], name: <one>, shape: "rect", radius: 0.5cm),
    node((4, 8), align(center)[$0$], name: <zero>, shape: "rect", radius: 0.5cm),

    edge(<x31>, <one>, "-|>"),
    edge(<y31>, <one>, "-|>"),
    edge(<y22>, <one>, "-|>"),
    edge(<y14>, <one>, "-|>"),

    edge(<y11>, <zero>, "--|>", stroke: red),
    edge(<y12>, <zero>, "--|>", stroke: red, bend: 10deg),
    edge(<y13>, <zero>, "--|>", stroke: red),
    edge(<y14>, <zero>, "--|>", stroke: red),
    edge(<y21>, <zero>, "--|>", stroke: red),
    edge(<y22>, <zero>, "--|>", stroke: red),
    edge(<y31>, <zero>, "--|>", stroke: red),
  ),
  caption: [A ROBDD of $f$ with $O(2^n)$ nodes. In this example, $n=3$ and the ROBDD has 15 nodes.],
)
