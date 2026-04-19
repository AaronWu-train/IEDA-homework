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

    node((2, 0), " ", name: <n1>, shape: "circle"),
    edge(<x1>, <n1>, "-|>"),
    edge(<x2>, <n1>, "-|>"),

    node((2, 1), " ", name: <n2>, shape: "circle"),
    edge(<x1>, <n2>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<x2>, <n2>, marks: (
      (inherit: "circle", pos: 0.45, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((2, 2), " ", name: <n3>, shape: "circle"),
    edge(<x3>, <n3>, "-|>"),
    edge(<x4>, <n3>, "-|>"),

    node((2, 3), " ", name: <n4>, shape: "circle"),
    edge(<x3>, <n4>, marks: (
      (inherit: "circle", pos: 0.3, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<x4>, <n4>, marks: (
      (inherit: "circle", pos: 0.45, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((4, 4), " ", name: <n5>, shape: "circle"),
    edge(<x5>, <n5>, "-|>"),
    edge(<n4>, <n5>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((5, 2), " ", name: <n6>, shape: "circle"),
    edge(<n5>, <n6>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n3>, <n6>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((4, 3), " ", name: <n7>, shape: "circle"),
    edge(<x5>, <n7>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n4>, <n7>, "-|>"),

    node((5, 0), " ", name: <n8>, shape: "circle"),
    edge(<n1>, <n8>, "-|>"),
    edge(<n7>, <n8>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((6, 1), " ", name: <n9>, shape: "circle"),
    edge(<n2>, <n9>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n6>, <n9>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((7, 3), " ", name: <n10>, shape: "circle"),
    edge(<n3>, <n10>, marks: (
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<x5>, <n10>, marks: (
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((7, 0), " ", name: <n11>, shape: "circle"),
    edge(<n8>, <n11>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n9>, <n11>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((8, 2), " ", name: <n12>, shape: "circle"),
    edge(<n10>, <n12>, marks: (
      (inherit: "circle", pos: 0.4, fill: auto),
      (inherit: "|>", pos: 1, fill: auto),
    )),
    edge(<n11>, <n12>, marks: (
      (inherit: "|>", pos: 1, fill: auto),
    )),

    node((10, 2), align(center)[$f$], name: <f>, shape: "rect"),
    edge(<n12>, <f>, "-*-|>"),
  ),
  caption: [The AIG of $f$. Use total 12 nodes.],
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

*Induction step*: Assume the statement holds for any Boolean function for $n = 1, 2, dots, k-1$. We want to show that the statement also holds for $n = k$. Let $f(x_1, x_2, dots, x_k)$ be an n-input Boolean function. By Shannon expansion, we have
$
  f = x_1 f_(x_1) + not x_1 f_(not x_1).
$
By the definition of ROBDD, the root node is decided by the first variable $x_1$. The high child of the root node is the ROBDD of $f_(x_1)$, and the low child of the root node is the ROBDD of $f_(not x_1)$.

By the induction hypothesis,$f_(x_1)$ and $f_(not x_1)$ are $k-1$ input Boolean functions, hence the ROBDDs of $f_(x_1)$ and $f_(not x_1)$ are unique. Therefore, the ROBDD of $f$ is also unique, since the root node is unique and the high and low children are unique. This completes the induction step.

Thus, by induction, the ROBDD of any n-input Boolean function is unique.

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
