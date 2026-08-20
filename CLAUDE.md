# Personal academic website

Quarto site for Juan Pablo Siachoque Campos, served by GitHub Pages at
<https://juanpscampos.github.io> from `main`.

## Build model

`_quarto.yml` sets `output-dir: .`, so **rendered HTML is committed to the repo
root** and served directly. The `.html` files, `search.json` and `sitemap.xml`
are build artifacts but are tracked — never hand-edit them, edit the `.qmd` and
re-render.

Always `quarto render` before committing, and check the HTML actually picked up
the change. A render can silently leave a page stale, and OneDrive timestamps
are unreliable for judging freshness — grep the rendered HTML for the new text
instead of trusting mtimes.

`update-site.ps1` is the normal path for routine updates: it validates the PDF,
renders, commits and pushes in one step.

```powershell
.\update-site.ps1 -Cv "$HOME\Downloads\CV.pdf"
.\update-site.ps1 -Jmp "$HOME\Downloads\paper.pdf"
.\update-site.ps1                       # re-render and push text edits
```

## Page width

Width is driven by **one knob**: `grid.body-width` in `_quarto.yml` (currently
900px). Body text fills that column, so raising it widens every page and
narrows the outer gutters together.

Do not reintroduce a `ch` cap using a child combinator. `main.content > p` only
matches direct children, but Quarto wraps everything under a `##` heading in a
`<section>` — an earlier `max-width: 68ch` rule silently missed 13 paragraphs
and 7 lists on the CV and 5 on Research, leaving the three tabs at three
different widths. A `ch` is also 9–10px here depending on the rendered font, so
whether such a cap binds against the column at all is a coin flip.

`.lede` and `.abstract-body` keep their own tighter measures; the JMP abstract
is the only genuinely long-form block on the site. `body-classes: wide-page`
clears those two — the mechanism still works, but no page currently uses it.

Pages under `resources/` carry a docked left sidebar, which makes Quarto swap in
a different `page-columns` grid template. Their body column is slightly narrower
than the sidebar-free pages; that is expected for a docs-style section.

## Layout conventions

- Research entries use `.paper` / `.paper-title` / `.paper-meta`. Titles are
  italic, with the PDF link inline on the title line as `.paper-link` — plain
  text, no pill buttons. `.btn` is for the home page only.
- Home page buttons are short: `CV` and `Job Market Paper`, both linking
  straight to the PDF.

## Assets

```
files/Documents/CV.pdf                    # -Cv target
files/Research/Siachoque_JMP_2026.pdf     # -Jmp target
files/Fotos/                              # profile photo
files/Logos/                              # social icons
```

Paths appear in the `.qmd` sources, `_quarto.yml` (favicon), `head-person.html`
(schema image) and `update-site.ps1`. After moving anything, check every
reference resolves:

```bash
grep -oh 'files/[^"'"'"' )>]*' *.html | sort -u | while read f; do [ -f "$f" ] || echo "MISSING $f"; done
```

## Resources section — currently hidden

`resources/` is the only nested content directory. **It is work in progress and
hidden**: excluded from the render list, with the navbar entry and sidebar block
commented out in `_quarto.yml`. The sources are kept and edited normally.

To unhide: swap `"!resources/*.qmd"` back to `"resources/*.qmd"` in the render
list and uncomment the navbar entry and the `sidebar:` block. The exclusion has
to be explicit — the website project type auto-discovers nested `.qmd`, so
simply dropping the include line is not enough.

It has a navbar tab and a docked left sidebar, both configured in `_quarto.yml`
— the sidebar is scoped by `id: resources`, so it appears on those pages only.

Adding a topic means two edits: a new `resources/<topic>.qmd`, and an entry under
the sidebar's `contents:`. The render list needs `"resources/*.qmd"` explicitly;
do not rely on `"*.qmd"` to recurse.

Sidebar styling lives under `// --- Section sidebar ---` in `theme.scss`, keyed
to `#quarto-sidebar`. Keep it keyed that way: the right-hand TOC is
`.sidebar.margin-sidebar` and shares the bare `.sidebar` class, so an unscoped
rule restyles both.

Nested pages resolve assets with a `../` prefix. Quarto rewrites `site_libs`
automatically, but **plain Markdown links are not rewritten** — a `resources/`
page pointing at shared assets needs `../files/...`.

## Unpublished pages

`contact.qmd` is excluded from the render list in `_quarto.yml` and its `.html`
deleted; the source is kept so it can be restored. Contact details live in the
footer.

The old `resources.qmd` (a debt-sustainability page with an unverified OJS
calculator) was deleted when the `resources/` section took the name. Recover it
with `git show cd8aff2^:resources.qmd` if it is ever wanted.

## Gotchas

- **Stale CSS bundles.** Every render emits a new content-hashed
  `site_libs/bootstrap/bootstrap-<hash>.min.css` and never removes the old one.
  Delete the unreferenced ones before committing or they accumulate.
- **OneDrive.** The repo lives under `OneDrive\Documentos\`. Sync has
  overwritten working-tree edits with older copies mid-session. Check
  `git status` before pushing; `git checkout HEAD -- <file>` restores.
