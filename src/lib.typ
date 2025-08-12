// Referenceable elements (https://typst.app/docs/reference/model/ref/):
//
// - [x] headings:  https://typst.app/docs/reference/model/heading/
// - [x] figures:   https://typst.app/docs/reference/model/figure/
// - [x] equations: https://typst.app/docs/reference/math/equation/
// - [x] footnotes: https://typst.app/docs/reference/model/footnote/

#import "@local/hallon:0.1.0": normalize-length, title-case, pluralize

#let is-heading(elem) = {
	return elem.has("bookmarked")
}

#let is-equation(elem) = {
	return elem.has("number-align") and elem.has("block")
}

#let is-footnote(elem) = {
	if elem.fields().len() != 3 {
		return false
	}
	return elem.has("numbering") and elem.has("body") and elem.has("label")
}

#let supplement-func(ref, capital: false) = {
	let target = query(ref.target).first()
	let supplement = none
	if target.has("supplement") {
		supplement = target.supplement.text
	} else if is-footnote(target) {
		return none // no default supplement for footnotes
	} else {
		//return [ fields: #target.fields() \ ]
		panic("unable to get supplement of target '" + str(type(target)) + "'")
	}
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
		} else if is-heading(elem) {
			c = counter(heading)
		} else if is-equation(elem) {
			c = counter(math.equation)
		} else if is-footnote(elem) {
			c = counter(footnote)
		} else {
			//return [ fields: #elem.fields() \ ]
			panic("unable to get counter of element '" + str(type(elem)) + "'")
		}
		let text = std.numbering(elem.numbering, ..c.at(elem.label))
		link(elem.label, text)
	}
	refs.join(", ", last: " and ")
}

#let Cref = cref.with(supplement: supplement-func.with(capital: true))
