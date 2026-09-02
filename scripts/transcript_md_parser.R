# Shared parsing helpers for the one-off antigravity-output migration scripts
# (merge_sarga1_translations.R, build_sarga2_transcripts.R). Not part of the
# regular build_site.R pipeline.

devanagari_to_arabic <- function(s) {
  chartr("०१२३४५६७८९",
         "0123456789", s)
}

normalize_dash <- function(s) gsub("–|—", "-", s)

strip_md_emphasis <- function(s) {
  s <- gsub("\\*\\*([^*]+)\\*\\*", "\\1", s)
  s <- gsub("\\*([^*]+)\\*", "\\1", s)
  s
}

# Extract a verse number/range string ("23" or "60-62") from a "## ..." heading,
# in either the Latin-digit English dialect or the Devanagari-digit dialect.
parse_verse_number <- function(heading) {
  heading <- normalize_dash(heading)
  m <- regmatches(heading, regexec("^Verses?\\s+([0-9]+)(?:-([0-9]+))?", heading))[[1]]
  if (length(m) >= 2 && nzchar(m[2])) {
    return(if (length(m) >= 3 && nzchar(m[3])) paste0(m[2], "-", m[3]) else m[2])
  }
  m <- regmatches(heading, regexec("^श्लोक\\s+([०-९]+)(?:-([०-९]+))?", heading))[[1]]
  if (length(m) >= 2 && nzchar(m[2])) {
    a <- devanagari_to_arabic(m[2])
    return(if (length(m) >= 3 && nzchar(m[3])) paste0(a, "-", devanagari_to_arabic(m[3])) else a)
  }
  stop("Could not parse verse number from heading: ", heading)
}

# Split a markdown file's lines into top-level "## " verse chunks.
# Returns a list of list(heading = <heading text>, number = <parsed number>, lines = <body lines>)
split_verse_chunks <- function(lines) {
  starts <- grep("^## ", lines)
  if (length(starts) == 0) stop("No '## ' verse headings found")
  ends <- c(starts[-1] - 1, length(lines))
  lapply(seq_along(starts), function(i) {
    heading <- sub("^## ", "", lines[starts[i]])
    body <- if (ends[i] >= starts[i] + 1) lines[(starts[i] + 1):ends[i]] else character(0)
    list(heading = heading, number = parse_verse_number(heading), lines = body)
  })
}

# Split one verse chunk's body lines into "### " subsections.
# Returns a named list: heading text (trimmed) -> paragraph text (or line vector if is_shlok).
split_subsections <- function(body_lines) {
  starts <- grep("^### ", body_lines)
  if (length(starts) == 0) return(list())
  ends <- c(starts[-1] - 1, length(body_lines))
  out <- list()
  for (i in seq_along(starts)) {
    heading <- trimws(sub("^### ", "", body_lines[starts[i]]))
    raw <- if (ends[i] >= starts[i] + 1) body_lines[(starts[i] + 1):ends[i]] else character(0)
    quoted <- raw[grepl("^>", raw)]
    quoted <- sub("^>\\s?", "", quoted)
    quoted <- sub("\\s+$", "", quoted)
    is_shlok <- heading %in% c("Sanskrit Shloka", "संस्कृत श्लोक")
    if (is_shlok) {
      out[[heading]] <- paste(quoted, collapse = "\n")
    } else {
      joined <- paste(quoted, collapse = " ")
      out[[heading]] <- strip_md_emphasis(trimws(joined))
    }
  }
  out
}

# Full-file parse: list of verse chunks, each with $number, $heading, $sections (named list)
parse_md_file <- function(path) {
  lines <- readLines(path, encoding = "UTF-8", warn = FALSE)
  chunks <- split_verse_chunks(lines)
  lapply(chunks, function(ch) {
    list(number = ch$number, heading = ch$heading, sections = split_subsections(ch$lines))
  })
}

# From an English-dialect verse's $sections, get translation_en/notes_en text.
# Rule: any "English Translation (...)" heading containing "Notes" -> notes_en,
# any other "English Translation (...)" heading -> translation_en.
english_fields_from_sections <- function(sections) {
  en_headings <- grep("^English Translation", names(sections), value = TRUE)
  translation_en <- NULL
  notes_en <- NULL
  for (h in en_headings) {
    if (grepl("Notes", h)) notes_en <- sections[[h]] else translation_en <- sections[[h]]
  }
  list(translation_en = translation_en, notes_en = notes_en)
}
