#let find-arg(source, ..args, default: none) = {
  for arg in args.pos() {
    if (source.keys().contains(arg)) {
      return source.at(arg)
    }
  }
  return default
}

#let parse-outset(outset) = {
  if (type(outset) == length) {
    (left: outset, right: outset, top: outset, bottom: outset)
  } else {
    (
      left: find-arg(outset, "left", "x", "other", default: 0pt),
      right: find-arg(outset, "right", "x", "other", default: 0pt),
      top: find-arg(outset, "top", "y", "other", default: 0pt),
      bottom: find-arg(outset, "bottom", "y", "other", default: 0pt),
    )
  }
}

#let shadow-block(
  width: auto, height: auto, radius: 0pt, outset: 0pt,
  blur: 0pt, dx: 10pt, dy: 10pt, col1: rgb(0,0,0).lighten(30%), col2: rgb(255,255,255,255),
  ..args, body
) = {
  let bwidth = if (type(width) == ratio) {100%} else {width}
  let bheight = if (type(height) == ratio) {100%} else {height}
  let outset = parse-outset(outset)
  let shadow-outset = (
      left: -dx+outset.left,
      right: dx+outset.right,
      top: -dy+outset.top,
      bottom: dy+outset.bottom,
    )
  block(
    radius: radius,
    width: width,
    height: height,
    outset: shadow-outset,
    fill: if (blur == 0pt) {col1} else {none},
    inset: 0pt,
    layout(size => style(st => {
      let bwidth = if (type(width) == ratio) {size.width} else {width}
      let bheight = if (type(height) == ratio) {size.height} else {height}
      let body = (block(width: bwidth, height: bheight, radius: radius, outset: outset, ..args, body))
      let bsize = measure(body, st)
      let radius = calc.max(radius, 2*blur)

      if (blur != 0pt) {
        let ddx = blur
        let blur = 100% - (2*blur / radius) * 100%
        let dx = dx 
        let dy = dy
        let bwidth = bsize.width - 2*radius + outset.left + outset.right
        let bheight = bsize.height - 2*radius + outset.top + outset.bottom
        let corn-grad = gradient.radial.with(col1, col2, radius: 100%, focal-radius: blur)
        
        place(top+left, dx: -shadow-outset.left, dy: -shadow-outset.top,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(100%, 100%))))
        place(top+right, dx: shadow-outset.right, dy: -shadow-outset.top,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(0%,100%))))
        place(bottom+right, dx: shadow-outset.right, dy: shadow-outset.bottom,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(0%,0%))))
        place(bottom+left, dx: -shadow-outset.left, dy: shadow-outset.bottom,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(100%,0%))))
        
        place(top+center, dx: dx, dy:  -shadow-outset.top,
          rect(height: radius * (100% - blur), width: bwidth,
            fill: gradient.linear(dir: btt, col1, col2)))
        place(horizon+right, dx: shadow-outset.right, dy: dy,
          rect(width: radius * (100% - blur), height: bheight,
            fill: gradient.linear(dir: ltr, col1, col2)))
        place(bottom+center, dx: dx, dy: shadow-outset.bottom,
          rect(height: radius * (100% - blur), width: bwidth,
            fill: gradient.linear(dir: ttb, col1, col2)))
        place(horizon+left, dx: -shadow-outset.left, dy: dy,
          rect(width: radius * (100% - blur), height: bheight,
            fill: gradient.linear(dir: rtl, col1, col2)))
        
        place(horizon+center, dx: dx, dy: dy,
          rect(width: bwidth + 2*radius * blur, height: bheight, fill: col1))
        place(horizon+center, dx: dx, dy: dy,
          rect(width: bwidth, height: bheight + 2*radius * blur, fill: col1))
      }
      (body)
    }))
  )
}


#let shadow-box(..args) = box(shadow-block(..args))
