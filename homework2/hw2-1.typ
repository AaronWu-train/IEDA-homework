#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))

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

= Boolean Function Representation

= Application of Quantified Boolean Formula

= Binary Decision Diagram
