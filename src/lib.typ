// TODO: add support for all referenceable elements.
//
// Referenceable elements (https://typst.app/docs/reference/model/ref/):
//
// - [x] headings:  https://typst.app/docs/reference/model/heading/
// - [x] figures:   https://typst.app/docs/reference/model/figure/
// - [ ] equations: https://typst.app/docs/reference/math/equation/
// - [ ] footnotes: https://typst.app/docs/reference/model/footnote/

#import "@local/hallon:0.1.0": normalize-length, title-case, pluralize

#let supplement-func(ref, capital: false) = {
	let target = query(ref.target).first()
	let supplement = target.supplement.text
	let singular = supplement.trim(regex("[.]")) // remove trailing dot if present (e.g. "Fig.")
	let plural = pluralize(singular)
	let s = supplement.replace(singular, plural)
	if capital {
		title-case(s)
	} else {
		lower(s)
	}
}

#let cref(..args, supplement: supplement-func) = context {
	let refs = ()
	for arg in args.pos() {
		for child in arg.children {
			if child.has("target") {
				refs.push(child)
			}
		}
	}
	if supplement != none {
		if type(supplement) == str or type(supplement) == content {
			supplement
		} else if type(supplement) == function {
			supplement(refs.first())
		}
		[ ]
	}
	show std.ref: it => {
		let elem = it.element
		let c = none
		if elem.has("counter") {
			c = elem.counter
		} else if elem.has("bookmarked") {
			c = counter(heading) // counter of heading element
		} else {
			panic("unable to get counter of element '" + type(elem) + "'")
		}
		let text = std.numbering(elem.numbering, ..c.at(elem.label))
		link(elem.label, text)
	}
	refs.join(", ", last: " and ")
}

#let Cref = cref.with(supplement: supplement-func.with(capital: true))
