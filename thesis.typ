#import "template.typ": vu_thesis

#show: vu_thesis.with(
  authors: (
    "Vardenis Pavardenis",
  ),
  supervisor: "Vardauskas Pavardauskas",
  reviewer: "Recenzentas Recenzentauskas",
  // title: "Darbo tema",
  // work_type: "Darbo tipas",
  // university: "Vilniaus Universitetas",
  // faculty: "Matematikos ir Informatikos",
  // institute: "Informatikos",
  // department: "Informatikos",
  done_by: "4 kurso 1 grupės studentas",
  // city: "Vilnius",
  // date: datetime.today(),
)

#set heading(numbering: none)
= Įvadas
#lorem(50)

#lorem(50)

#set heading(numbering: "1.")
= Pirmas skyrius
Anyone caught using formulas such as $sqrt(x+y)=sqrt(x)+sqrt(y)$
or $1/(x+y) = 1/x + 1/y$ will fail
The binomial theorem is @binomial.

$ (x+y)^n=sum_(k=0)^n binom(n, k) x^k y^(n-k). $ <binomial>

A favorite sum of most mathematicians is

$ sum_(n=1)^oo 1/n^2 = pi^2 / 6. $

Likewise a popular integral is
$ integral_(-oo)^oo e^(-x^2) dif x = sqrt(pi) $

== Pirmo skyriaus poskyris
Literatūros nuorodos: @LTArticle, @onlineArticle

=== Lentelės
Galima naudoti lenteles kaip @solids lentelė.

#figure(
  table(
    columns: (1fr, auto, auto),
    align: horizon,
    [], [*Area*], [*Parameters*],
    [*Cylinder*],
    $ pi h (D^2 - d^2) / 4 $,
    [$h$: height \
     $D$: outer radius \
     $d$: inner radius],
    [*Tetrahedron*],
    $ sqrt(2) / 12 a^3 $,
    [$a$: edge length]
  ),
  caption: "Solids",
) <solids>

=== Paveiksliukai
@vu-logo paveiksliuke vaizduojamas VU logotipas.
#figure(
  image("vu_logo.png", width: 30%),
  caption: "VU logotipas",
) <vu-logo>

#set heading(numbering: none)
= Išvados
Išveskime

#pagebreak()
#bibliography(title: "Literatūros sąrašas", "refs.bib")

// #pagebreak()
// = Priedas Nr. 1
// #set text(10pt) // priedų šriftas turi būti 10pt

