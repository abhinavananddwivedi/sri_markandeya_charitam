# Regenerates docs/ (the static site) from transcripts/*.yml and Images/pages/.
# Usage: Rscript scripts/build_site.R
# docs/ is fully generated output -- never hand-edit files inside it.

library(yaml)
library(glue)

script_args <- commandArgs(trailingOnly = FALSE)
script_path <- sub("^--file=", "", script_args[grep("^--file=", script_args)])
repo_root <- normalizePath(file.path(dirname(script_path), ".."))
transcripts_dir <- file.path(repo_root, "transcripts")
images_src_dir <- file.path(repo_root, "Images", "pages")
docs_dir <- file.path(repo_root, "docs")
docs_images_dir <- file.path(docs_dir, "images")

dir.create(docs_dir, showWarnings = FALSE)
dir.create(docs_images_dir, showWarnings = FALSE)

# ---- load transcripts -------------------------------------------------

yml_files <- sort(list.files(transcripts_dir, pattern = "\\.yml$", full.names = TRUE, recursive = TRUE))
if (length(yml_files) == 0) stop("No transcripts found in ", transcripts_dir)

pages <- lapply(yml_files, function(f) {
  p <- yaml::read_yaml(f)
  p$.slug <- tools::file_path_sans_ext(basename(f))
  p
})
pages <- pages[order(vapply(pages, function(p) as.integer(p$page_number_arabic), integer(1)))]

# ---- copy page images into docs/images/ --------------------------------

for (p in pages) {
  src <- file.path(repo_root, p$image)
  if (file.exists(src)) {
    file.copy(src, file.path(docs_images_dir, basename(src)), overwrite = TRUE)
  }
}

# ---- shared CSS ----------------------------------------------------------

css <- '
@font-face {
  font-family: "Noto Sans Devanagari";
  font-weight: 400;
  src: url("assets/fonts/NotoSansDevanagari-Regular.ttf") format("truetype");
}
@font-face {
  font-family: "Noto Sans Devanagari";
  font-weight: 600;
  src: url("assets/fonts/NotoSansDevanagari-SemiBold.ttf") format("truetype");
}
@font-face {
  font-family: "Noto Sans Devanagari";
  font-weight: 700;
  src: url("assets/fonts/NotoSansDevanagari-Bold.ttf") format("truetype");
}
:root {
  --bg: #faf7f0;
  --ink: #2b2420;
  --muted: #7a6f61;
  --rule: #e2d9c8;
  --shlok-bg: #fff9ec;
  --shlok-border: #c9a24b;
  --notes-bg: #f3efe6;
  --accent: #8a3b2b;
  --en-accent: #3b6e8f;
  --en-bg: #f0f5f8;
}
* { box-sizing: border-box; }
body {
  background: var(--bg);
  color: var(--ink);
  font-family: "Noto Sans Devanagari", "Noto Sans", sans-serif;
  max-width: 780px;
  margin: 0 auto;
  padding: 2rem 1.25rem 4rem;
  line-height: 1.9;
}
h1, h2 { font-weight: 700; }
h1 { font-size: 1.5rem; }
a { color: var(--accent); }
.subtitle { color: var(--muted); margin-top: -0.5rem; }
.page-nav { display: flex; justify-content: space-between; margin: 2rem 0 1rem; font-size: 0.95rem; }
.page-list { list-style: none; padding: 0; }
.page-list li { border-bottom: 1px solid var(--rule); padding: 0.6rem 0; display: flex; justify-content: space-between; }
.page-list .devanagari-num { color: var(--muted); }
.verse { margin: 1.75rem 0; padding: 1.25rem; border: 1px solid var(--rule); border-radius: 8px; }
.verse-label { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin-bottom: 0.75rem; }
.sarga { color: var(--muted); font-style: italic; margin-top: -0.25rem; }
.block { margin: 0.9rem 0; }
.block-shlok { background: var(--shlok-bg); border-left: 4px solid var(--shlok-border); padding: 0.85rem 1rem; font-size: 1.15rem; white-space: pre-line; }
.block-translation { padding: 0.4rem 0.2rem; white-space: pre-line; }
.block-translation-en { background: var(--en-bg); border-left: 4px solid var(--en-accent); padding: 0.85rem 1rem; white-space: pre-line; font-style: italic; }
.block-notes { background: var(--notes-bg); border-left: 4px solid var(--accent); padding: 0.85rem 1rem; white-space: pre-line; font-size: 0.97rem; }
.block-notes-en { background: var(--en-bg); border-left: 4px solid var(--en-accent); padding: 0.85rem 1rem; white-space: pre-line; font-size: 0.97rem; font-style: italic; }
.block-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.06em; color: var(--muted); margin-bottom: 0.3rem; }
.author-tag { font-style: normal; font-size: 0.7rem; color: var(--muted); border: 1px solid var(--rule); border-radius: 4px; padding: 0.05rem 0.4rem; margin-left: 0.4rem; }
.source-scan { margin-top: 2rem; }
.source-scan img { max-width: 100%; border: 1px solid var(--rule); border-radius: 4px; }
.source-scan summary { cursor: pointer; color: var(--muted); font-size: 0.9rem; }
.placeholder-banner { background: #fbe6e0; border: 1px solid #d98a72; color: #7a2e1c; padding: 0.6rem 1rem; border-radius: 6px; font-size: 0.9rem; margin-bottom: 1.5rem; }
footer { margin-top: 3rem; color: var(--muted); font-size: 0.85rem; }
'
writeLines(css, file.path(docs_dir, "style.css"))
dir.create(file.path(docs_dir, "assets", "fonts"), recursive = TRUE, showWarnings = FALSE)
invisible(file.copy(
  list.files(file.path(repo_root, "docs", "assets", "fonts"), full.names = TRUE),
  file.path(docs_dir, "assets", "fonts"), overwrite = TRUE
))

# ---- helpers --------------------------------------------------------------

html_escape <- function(x) {
  if (is.null(x)) return("")
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x
}

author_label <- function(author) {
  switch(author,
    amanuensis = "amanuensis's hand",
    grandfather = "grandfather's hand",
    ai_translation = "AI-assisted translation",
    author
  )
}

render_block <- function(type, text, author = NULL) {
  cls <- switch(type,
    shlok = "block-shlok",
    translation = "block-translation",
    translation_en = "block-translation-en",
    notes = "block-notes",
    notes_en = "block-notes-en",
    "block-translation"
  )
  label <- switch(type,
    shlok = "Shlok",
    translation = "Translation",
    translation_en = "English Translation",
    notes = "Notes",
    notes_en = "English Notes",
    type
  )
  author_tag <- if (!is.null(author)) glue('<span class="author-tag">{html_escape(author_label(author))}</span>') else ""
  glue('
    <div class="block {cls}">
      <div class="block-label">{label}{author_tag}</div>
      {html_escape(text)}
    </div>')
}

render_verse <- function(v) {
  parts <- c(
    if (!is.null(v$shlok)) render_block("shlok", v$shlok, "amanuensis") else NULL,
    if (!is.null(v$translation)) render_block("translation", v$translation$text, v$translation$author) else NULL,
    if (!is.null(v$translation_en)) render_block("translation_en", v$translation_en$text, v$translation_en$author) else NULL,
    if (!is.null(v$notes)) render_block("notes", v$notes$text, v$notes$author) else NULL,
    if (!is.null(v$notes_en)) render_block("notes_en", v$notes_en$text, v$notes_en$author) else NULL
  )
  body <- paste(parts, collapse = "\n")
  label <- if (!is.null(v$number)) glue("Verse {v$number}") else "Verse"
  glue('
  <section class="verse">
    <div class="verse-label">{label}</div>
    {body}
  </section>')
}

page_href <- function(p) glue("{p$.slug}.html")

# ---- render each page -------------------------------------------------

for (i in seq_along(pages)) {
  p <- pages[[i]]
  prev_p <- if (i > 1) pages[[i - 1]] else NULL
  next_p <- if (i < length(pages)) pages[[i + 1]] else NULL

  banner <- if (isTRUE(p$placeholder)) '<div class="placeholder-banner">This page shows placeholder/sample text for layout testing only -- not a real transcription.</div>' else ""

  prev_link <- if (!is.null(prev_p)) glue('<a href="{page_href(prev_p)}">&larr; previous</a>') else ""
  next_link <- if (!is.null(next_p)) glue('<a href="{page_href(next_p)}">next &rarr;</a>') else ""

  nav <- glue('
  <div class="page-nav">
    <span>{prev_link}</span>
    <a href="index.html">index</a>
    <span>{next_link}</span>
  </div>')

  verses_html <- paste(vapply(p$verses, render_verse, character(1)), collapse = "\n")

  sarga_html <- if (!is.null(p$sarga)) glue('<p class="sarga">{html_escape(p$sarga)}</p>') else ""
  title_html <- if (!is.null(p$title)) glue("{html_escape(p$title)}") else "Mahakavya manuscript"

  img_tag <- if (!is.null(p$image) && file.exists(file.path(repo_root, p$image))) {
    glue('
  <details class="source-scan">
    <summary>View original scanned page</summary>
    <img src="images/{basename(p$image)}" alt="Scan of manuscript page {html_escape(p$page_number_devanagari)}">
  </details>')
  } else ""

  html <- glue('<!doctype html>
<html lang="sa">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Page {html_escape(p$page_number_devanagari)} -- Mahakavya manuscript</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
{banner}
<h1>{title_html}</h1>
{sarga_html}
<p class="subtitle">Manuscript page {p$page_number_arabic} ({html_escape(p$page_number_devanagari)})</p>
{nav}
{verses_html}
{img_tag}
{nav}
<footer>Digitized manuscript pages of a Sanskrit mahākāvya.</footer>
</body>
</html>')

  writeLines(html, file.path(docs_dir, glue("{p$.slug}.html")))
}

# ---- index page ---------------------------------------------------------

list_items <- paste(vapply(pages, function(p) {
  glue('<li><a href="{page_href(p)}">Page {p$page_number_arabic}</a><span class="devanagari-num">{html_escape(p$page_number_devanagari)}</span></li>')
}, character(1)), collapse = "\n")

index_html <- glue('<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Mahakavya manuscript</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<h1>Mahakavya manuscript</h1>
<p class="subtitle">A digitized Sanskrit mahākāvya, handwritten in a notebook. {length(pages)} page(s) transcribed so far.</p>
<ul class="page-list">
{list_items}
</ul>
<footer>Digitized manuscript pages of a Sanskrit mahākāvya.</footer>
</body>
</html>')

writeLines(index_html, file.path(docs_dir, "index.html"))

cat(glue("Built {length(pages)} page(s) into {docs_dir}\n"))
