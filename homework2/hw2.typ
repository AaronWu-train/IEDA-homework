#import "../template.typ": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/finite:0.5.1": automaton, layout
#import "@preview/zebraw:0.6.1": *
#show: zebraw.with(lang: true, lang-color: aqua.lighten(60%))

#show: project.with(
  title: "Homework 2",
  class: "Introduction to Electronic Design Automation",
  student: "吳亞倫",
  id: "B13901011",
  department: "電機工程學系",
  header-title: "IEDA Homework 2",
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

