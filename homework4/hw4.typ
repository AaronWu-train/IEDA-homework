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

#pagebreak()
// ---------------------- Problem 2 ----------------------
= Floorplanning

#pagebreak()
// ---------------------- Problem 3 ----------------------
= Wire-length Estimation

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
