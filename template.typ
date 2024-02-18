#let text_font_size = 12pt
#let heading_font_size = 14pt

#let get_supplement(it) = {
  let supplement = "pav"

  if it.body != none {
    if it.body.func() == image {
      supplement = "pav"
    }
    if it.body.func() == table {
      supplement = "lentelė"
    }
  }

  supplement
}

#let get_caption(it) = {
  let supplement = get_supplement(it)
  if it.has("caption") {
    if it.numbering != none {
      it.counter.display(it.numbering)
    }
    [ ]
    supplement
    [. ]
    it.caption.body
  }
}

#let vu_thesis(
  title: "Darbo tema",
  authors: (),
  supervisor: none,
  work_type: "Darbo tipas",
  university: "Vilniaus Universitetas",
  faculty: "Matematikos ir Informatikos",
  department: "Informatikos",
  done_by: "",
  city: "Vilnius",
  date: datetime.today(),
  body,
) = {
  set document(title: title, author: authors)

  set text(
    size: text_font_size,
    font: "Linux Libertine",
    lang: "lt",
    hyphenate: false,
  )

  set page(
    paper: "a4",
    margin: (
      top: 3cm,
      left: 3cm,
      right: 1.5cm,
      bottom: 2cm,
    ),

    footer: locate(loc => {
      let i = counter(page).at(loc).first()
      if i != 1 {
        align(right, [#i])
      }
    })
  )

  set heading(numbering: "1.")
  show heading: it => {
    if it.level == 1 {
      pagebreak(weak: true)
    } else {
      v(1.5em, weak: true)
    }
    set text(heading_font_size, weight: "semibold")
    it
    set text(text_font_size, weight: "regular")
    v(1em, weak: true)
  }

  set math.equation(numbering: "(1)")
  show table: it => {
    set math.equation(numbering: none)
    it
  }

  show figure: it => {
    set align(center)

    v(1.5em, weak: true)

    let gap = v(if it.has("gap") { it.gap } else { 1.5em }, weak: true)

    if it.body.func() != table {
      it.body
      gap
    }

    get_caption(it)

    if it.body.func() == table {
      gap
      it.body
    }

    v(1.5em, weak: true)
  }

  show ref: it => {
    if it.element == none {
      it
    } else if it.element.func() == math.equation {
      link(it.element.location(), {
        numbering(
          it.element.numbering,
          ..counter(math.equation).at(it.element.location())
        )
      })
    } else if it.element.body == none {
      it
    } else if it.element.body.func() == table or it.element.body.func() == image {
      link(it.element.location(), {
        numbering(
          it.element.numbering,
          ..counter(figure.where(kind: it.element.body.func())).at(it.element.location())
        )
      })
    } else {
      it
    }
  }

  set bibliography(style: "vu.csl")

  // Title page
  align(center, upper([
    #university \
    #faculty Fakultetas\
    #department Katedra\
  ]))
  v(20%)
  align(center, work_type)
  align(center, text(size: 15pt, weight: 700, title))

  v(15%)
  align(right, {
    table(
      columns: 2,
      align: left,
      stroke: white,
      [
        Atliko: #done_by \ 
        #for (i, name) in authors.enumerate() {
          name
          v(1.5em)
        }
      ],
      [
        \
        \
        #for (i, _) in authors.enumerate() {
          h(3em)
          super([(Parašas)])
          h(4em)
          v(1.5em)
        }
      ],
      [
        #if supervisor != none {
          [Vadovas:\ ]
          supervisor
        }
      ],
      [
        \
        \
        #h(3em)
        #super([(Parašas)])
        #h(1.5em)
      ],
    )
  })

  align(bottom + center, {
    city
    [\ ]
    if date != none {
      date.display("[year]")
    }
  })
  pagebreak()

  // Remove page number and dot fill for specific headings
  show outline.entry: it => {
    if not repr(it.body).contains("Priedas") or it.at("label", default: none) == <modified-entry> {
      it // prevent infinite recursion
    } else {
      [#outline.entry(
        it.level,
        it.element,
        it.body,
        [],  // remove fill
        []  // remove page number
      ) <modified-entry>]
    }
  }

  outline(title: "Turinys", indent: true)
  pagebreak()

  // Use commas in decimal numbers
  show math.equation: it => {
      show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
          it}
      it
  }

  show raw.where(lang: "block"): it => block(
    fill: rgb("#F0F0F0"),
    inset: 10pt,
    radius: 3pt,
    par(justify: false, leading: 0.6em, text(size: 9pt, it))
  )
  set raw(align: left)
  set par(
    first-line-indent: 0.7cm,
    justify: true,
    leading: 0.845em, // Matches latex \onehalfspacing
  )
  show par: set block(spacing: 0.845em)

  body
}
