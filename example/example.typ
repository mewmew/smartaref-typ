#set page(width: 12cm, height: auto)

#import "@preview/smartaref:0.1.0": cref, Cref

// Highlight links.
#show link: set text(fill: blue)
#show ref: set text(fill: blue)

#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")

// === [ figure example ] ======================================================

#let example-fig = rect(fill: aqua)

= Figures example
<sec-figures-example>

#figure(
	example-fig,
	caption: [foo],
) <fig-foo>

#figure(
	example-fig,
	caption: [bar],
) <fig-bar>

#figure(
	example-fig,
	caption: [baz],
) <fig-baz>

See @fig-foo, @fig-bar and @fig-baz.

See #cref[@fig-foo @fig-bar @fig-baz].

#Cref[@fig-foo @fig-bar @fig-baz] are ...

// === [ tables example ] ======================================================

#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: raw): set figure.caption(position: top)

#let example-table = table(
	columns: 2,
	stroke: 0.3pt,
	table.header([*asdf*], [*qwerty*]),
	[a], [b],
	[c], [d],
)

= Tables example
<sec-tables-example>

#figure(
	caption: [foo],
	example-table,
) <tbl-foo>

#figure(
	caption: [foo],
	example-table,
) <tbl-bar>

#figure(
	caption: [foo],
	example-table,
) <tbl-baz>

See @tbl-foo, @tbl-bar and @tbl-baz.

See #cref[@tbl-foo @tbl-bar @tbl-baz].

#Cref[@tbl-foo @tbl-bar @tbl-baz] are ...

= Listings example
<sec-listings-example>

#let example-raw = ```typst
#set document(title: "meta")
```

#figure(
	caption: [foo],
	example-raw,
) <lst-foo>

#figure(
	caption: [bar],
	example-raw,
) <lst-bar>

#figure(
	caption: [baz],
	example-raw,
) <lst-baz>

See @lst-foo, @lst-bar and @lst-baz.

See #cref[@lst-foo @lst-bar @lst-baz].

#Cref[@lst-foo @lst-bar @lst-baz] are ...

= Sections example
<sec-sections-example>

See @sec-figures-example @sec-tables-example @sec-listings-example @sec-sections-example @sec-subsection.

See #cref[@sec-figures-example @sec-tables-example @sec-listings-example @sec-sections-example @sec-subsection].

#Cref[@sec-figures-example @sec-tables-example @sec-listings-example @sec-sections-example @sec-subsection] are ...

== Subsection
<sec-subsection>

#lorem(10)

= Equations example

$ abs(z) = sqrt(x^2 + y^2) $ <eq-pythagoras>

$ e^(i pi) = -1 $ <eq-eulers-identity>

$ (cos x + i sin x)^n = cos(n x) + i sin(n x) $ <eq-de-moivres-formula>

See @eq-pythagoras, @eq-eulers-identity and @eq-de-moivres-formula.

See #cref[@eq-pythagoras @eq-eulers-identity @eq-de-moivres-formula].

#Cref[@eq-pythagoras @eq-eulers-identity @eq-de-moivres-formula] are ...
