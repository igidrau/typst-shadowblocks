#import "shadowblocks.typ": *

#set page(width: auto, height: auto)

#shadow-block(radius: 15pt, fill: blue, inset: 30pt)[This is some text in a box]
#v(1em)
#shadow-block(radius: 15pt, fill: blue, inset: 30pt, dx: -10pt, dy: -10pt, blur: 10pt)[The shadow can be moved]
#shadow-block(radius: 15pt, fill: blue, inset: 30pt, dx: 40pt, blur: 15pt)[Move it too far!]
#shadow-block(radius: 15pt, fill: blue, inset: 30pt, blur: 5pt, col1: red)[Change the color!]

Can even be used #shadow-box(fill: red.lighten(50%), radius: 2pt, outset: (x: 3pt, y: 2pt), dx: 2pt, dy: 2pt, blur: 2pt)[inline]!
