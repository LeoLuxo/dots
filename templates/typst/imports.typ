
#import "@preview/dashy-todo:0.0.1": todo

#let appendix(body) = {
  set heading(numbering: "A", supplement: [Appendix])
  counter(heading).update(0)
  body
}