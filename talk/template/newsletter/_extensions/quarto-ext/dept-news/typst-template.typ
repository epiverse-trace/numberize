// Used to collect sidebar articles.
#let articles = state("articles", ())

// This function gets your whole document as its `body` and formats
// it as the fun newsletter of a college department.
#let dept-news(
  // The newsletter's title.
  title: "Newsletter title",

  // The edition, displayed at the top of the sidebar.
  edition: none,

  // A hero image at the start of the newsletter. If given, should be a
  // dictionary with two keys: A `path` to an image file and a `caption`
  // that is displayed to the right of the image.
  hero-image: none,

  // Details about the publication, displayed at the end of the document.
  publication-info: none,

  // The newsletter's content.
  body
) = {
  // Set document metadata.
  set document(title: title)

  // Configure pages. The background parameter is used to
  // add the right background to the pages.
  set page(
    margin: (left: 2.5cm, right: 1.6cm),
    background: place(right + top, rect(
      fill: red,
      height: 100%,
      width: 7.8cm,
    ))
  )

  // Set the body font.
  set text(12pt, font: "Barlow")

  // Configure headings.
  show heading: set text(font: "Syne")
  show heading.where(level: 1): set text(1.1em)
  show heading.where(level: 1): set par(leading: 0.4em)
  show heading.where(level: 1): set block(below: 0.8em)
  show heading: it => {
    set text(weight: 600) if it.level > 2
    it
  }

  // Links should be underlined.
  show link: underline

  // Configure figures.
  show figure: it => block({
    // Display a backdrop rectangle.
    move(dx: -3%, dy: 1.5%, rect(
      fill: rgb("FF7D79"),
      inset: 0pt,
      move(dx: 3%, dy: -1.5%, it.body)
    ))

    // Display caption.
    if it.has("caption") {
      set align(center)
      set text(font: "Syne")
      v(if it.has("gap") { it.gap } else { 24pt }, weak: true)
      if it.supplement != none and it.numbering != none {
        [#it.supplement #counter(figure).display(it.numbering): ]
      }
      it.caption
    }

    v(48pt, weak: true)
  })

  // The document is split in two with a grid. A left column for the main
  // flow and a right column for the sidebar articles.
  grid(
    columns: (1fr, 7.8cm - 1.6cm - 18pt),
    column-gutter: 36pt,
    row-gutter: 32pt,

    // Title.
    text(font: "Syne", 23pt, weight: 800, upper(title)),

    // Edition.
    text(fill: white, weight: "medium", 14pt, align(right + bottom, edition)),

    // Hero image.
    style(styles => {
      if hero-image == none {
        return
      }

      // Measure the image and text to find out the correct line width.
      // The line should always fill the remaining space next to the image.
      let img = image(hero-image.path, width: 14cm)
      let text = text(size: 25pt, fill: white, font: "Syne Tactile", hero-image.caption)
      let img-size = measure(img, styles)
      let text-width = measure(text, styles).width + 12pt
      let line-length = img-size.height - text-width

      grid(
        columns: (img-size.width, 1cm),
        column-gutter: 16pt,
        rows: img-size.height,
        img,
        grid(
          rows: (text-width, 1fr),
          move(dx: 11pt, rotate(
            90deg,
            origin: top + left,
            box(width: text-width, text)
          )),
          line(angle: 90deg, length: line-length, stroke: 3pt + white),
        ),
      )
    }),

    // Nothing next to the hero image.
    none,

    // The main flow with body and publication info.
    {
      set par(justify: true)
      body
      v(1fr)
      set text(0.7em)
      publication-info
    },

    // The sidebar with articles.
    locate(loc => {
      set text(fill: white, weight: 500)
      show heading: underline.with(stroke: 2pt, offset: 4pt)
      v(44pt)
      for element in articles.final(loc) {
        element
        v(24pt, weak: true)
      }
    }),
  )
}

// A stylized block with a quote and its author.
#let blockquote(body) = box(inset: (x: 0.4em, y: 12pt), width: 100%, {
  set text(font: "Syne")
  grid(
    columns: (1em, auto, 1em),
    column-gutter: 12pt,
    rows: (1em, auto),
    row-gutter: 8pt,
    text(5em)["],
    line(start: (0pt, 0.45em), length: 100%),
    none, none,
    text(1.4em, align(center, body)),
    none, none
  )
})


// An article that is displayed in the sidebar. Can be added
// anywhere in the document. All articles are collected automatically.
#let article(body) = articles.update(it => it + (body,))
