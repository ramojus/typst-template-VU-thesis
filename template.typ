#let get_supplement(it) = {
  let supplement = it.supplement

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
  institute: "Informatikos",
  department: "Informatikos",
  city: "Vilnius",
  date: datetime.today(),
  bibliography_file: none,
  body,
) = {
  set document(title: title, author: authors)

  set text(size: 12pt, font: "Linux Libertine", lang: "lt")

  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      left: 30mm,
      right: 15mm,
      bottom: 20mm,
    ),

    footer-descent: 1em,
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
    it
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

  // Title page
  align(center, image("vu_logo.png", width: 60pt))
  align(center, upper([
    #university \
    #faculty Fakultetas\
    #institute Institutas\
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
        Atliko:\ 
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

  outline(title: "Turinys")
  pagebreak()

  set par(first-line-indent: 1.5em, justify: true)
  show par: set block(spacing: 0.65em)

  body

  if bibliography_file != none {
    pagebreak()
    bibliography(title: "Literatūros šaltiniai", bibliography_file)
  }
}

