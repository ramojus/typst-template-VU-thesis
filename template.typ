#let text_font_size = 12pt
#let heading_font_size = 14pt

#let get_lt_supplement(it) = {
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

#let get_lt_caption(it) = {
  let supplement = get_lt_supplement(it)
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

#let get_people_with_signature_fields(authors, done_by, supervisor, reviewer) = {
  let signature_field = {
    v(1.2em)
    h(1.5em)
    super([(Parašas)])
    h(1em)
  }

  v(15%)
  align(right, {
    table(
      columns: 2,
      align: left,
      stroke: white,

      [Atliko: #done_by], [],
      ..for name in authors {(
          {name}, {signature_field}
      )},
      ..if supervisor != none {(
          [Vadovas:], [],
          {supervisor}, {signature_field},
      )},
      ..if reviewer != none {(
          [Recenzentas:], [],
          {reviewer}, {signature_field},
      )},
    )
  })
}

// to indent the first real paragraph
#let follow_with_empty_par(it, line_spacing) = {
  it
  let a = par(box())
  a
  v(-(measure(a).height + line_spacing))
}

#let indent_as_first_line(it, first_line_indent) = {
  set par(first-line-indent: 0pt) // prevent some lists automatically indenting inside box
  box(inset: (left: first_line_indent), it)
}

#let vu_thesis(
  title: "Darbo tema",
  authors: (),
  supervisor: none,
  reviewer: none,
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
  show table: set math.equation(numbering: none)

  // Use commas in decimal numbers
  show math.equation: it => {
      show regex("\d+\.\d+"): it => {
        show ".": {
          "," + h(0pt)
        }
        it
      }
      it
  }

  show figure: it => {
    set align(center)
    v(1.5em, weak: true)
    block({
      // For tables, caption comes first
      if it.body.func() != table {
        it.body
        v(1.5em, weak: true)
      }
      get_lt_caption(it)
      if it.body.func() == table {
        v(1.5em, weak: true)
        it.body
      }
    })
    v(1.5em, weak: true)
  }

  show ref: it => {
    if it.element == none or it.element.body == none {
      return it
    }
    let ref_counter = none
    if it.element.func() == figure {
      ref_counter = counter(figure.where(kind: it.element.body.func()))
    } else if it.element.func() == math.equation {
      ref_counter = counter(it.element.func())
    }
    // Don't show supplement, only the caption number
    link(it.element.location(), {
      numbering(
        it.element.numbering,
        ..ref_counter.at(it.element.location())
      )
    })
  }

  // Remove page number and dot fill for specific headings in TOC
  show outline.entry: it => {
    if it.at("label", default: none) == <modified-entry> {
      it // prevent infinite recursion
    } else if repr(it.body).contains("Priedas") {
      [#outline.entry(
        it.level,
        it.element,
        it.body,
        [],  // remove fill
        []  // remove page number
      ) <modified-entry>]
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
  get_people_with_signature_fields(authors, done_by, supervisor, reviewer)
  align(bottom + center, {
    city
    [\ ]
    if date != none {
      date.display("[year]")
    }
  })
  pagebreak()

  outline(title: "Turinys", indent: true)
  pagebreak()

  let first_line_indent = 0.7cm
  let line_spacing = 0.845em // Matches latex \onehalfspacing
  set par(
    first-line-indent: first_line_indent,
    justify: true,
    leading: line_spacing,
  )
  show par: set block(spacing: line_spacing) // no extra spacing between paragraphs

  // change how first line indent works
  show heading: it => follow_with_empty_par(it, line_spacing)
  show enum: it => follow_with_empty_par(it, line_spacing)
  show list: it => follow_with_empty_par(it, line_spacing)
  show enum: it => indent_as_first_line(it, first_line_indent)
  show list: it => indent_as_first_line(it, first_line_indent)

  body
}
