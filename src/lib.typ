// TODO: add support for all referenceable elements.
//
// Referenceable elements (https://typst.app/docs/reference/model/ref/):
//
// - [ ] headings:  https://typst.app/docs/reference/model/heading/
// - [x] figures:   https://typst.app/docs/reference/model/figure/
// - [ ] equations: https://typst.app/docs/reference/math/equation/
// - [ ] footnotes: https://typst.app/docs/reference/model/footnote/

#import "@local/hallon:0.1.0": normalize-length, title-case

#let heading-figure-subfigure-numbering(label, style: "1.1a", levels: 1) = {
	let h-nums = counter(heading).at(label)
	let f-num = counter(figure.where(kind: image)).at(label).first()
	let s-num = counter(figure.where(kind: "subfigure")).at(label).first()
	numbering(style, ..normalize-length(h-nums, levels), f-num, s-num)
}

#let heading-figure-numbering(label, fig-kind: image, style: "1.1", levels: 1) = {
	let h-nums = counter(heading).at(label)
	let f-num = counter(figure.where(kind: fig-kind)).at(label).first()
	numbering(style, ..normalize-length(h-nums, levels), f-num)
}

#let cref(..args, levels: 0, capital: false, supplement: none) = context {
	let elems = args.pos()
	let refs = ()
	for elem in elems {
		for child in elem.children {
			if child.has("target") {
				let ref = query(child.target).first()
				refs.push(ref)
			}
		}
	}

	// Use optionally heading-dependent numbering of figures and subfigures.
	let fig-numbering = "1"
	let subfig-numbering = "1a"
	if levels > 0 {
		fig-numbering = "1."*levels + fig-numbering       // e.g. "1.1"
		subfig-numbering = "1."*levels + subfig-numbering // e.g. "1.1a"
	}

	// Infer supplement from kind.
	let supplement-str = supplement
	if supplement == none {
		for ref in refs {
			if ref.kind == image or ref.kind == "subfigure" {
				supplement-str = "figures"
			} else if ref.kind == table {
				supplement-str = "tables"
			} else if ref.kind == raw {
				supplement-str = "listings"
			}
		}
	}

	let new-refs = ()
	for ref in refs {
		let str = ""
		if ref.kind == "subfigure" {
			str = heading-figure-subfigure-numbering(ref.label, style: subfig-numbering, levels: levels)
		} else if ref.kind == image or ref.kind == table or ref.kind == raw {
			str = heading-figure-numbering(ref.label, fig-kind: ref.kind, style: fig-numbering, levels: levels)
		}
		let new-ref = link(ref.label, str)
		new-refs.push(new-ref)
	}
	if capital {
		supplement-str = title-case(supplement-str)
	}
	[#supplement-str~#new-refs.join(", ", last: " and ")]
}

#let Cref = cref.with(capital: true)
