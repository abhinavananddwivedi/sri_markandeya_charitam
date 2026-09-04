# Shared parsing helpers for the one-off antigravity-output migration scripts
# (merge_sarga1_translations.R, build_sarga2_transcripts.R, build_sarga3_transcripts.R).
# Not part of the regular build_site.R pipeline.
#
# Two markdown "dialects" are supported and auto-detected by parse_md_file():
#   Dialect A (Sarga 1-2, Sarga 3 pages 61-75): "## " verse headings, "### "
#     subsections, bodies as ">" blockquotes.
#   Dialect B (Sarga 3 pages 76-86): no "## " headings; "### " verse headings,
#     "#### " subsections, the shlok in a fenced ```sanskrit code block, prose
#     bodies as plain paragraphs, and an italic "*(... लिपि-टिप्पणी ... वृत्त ...)*"
#     paleographic/metre note trailing the shlok fence (captured as
#     "__manuscript_note__").
# The discriminator is simply "does any line start with '## '".

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

# Extract a verse number/range string ("23" or "60-62") from a verse heading,
# in either the Latin-digit English dialect or the Devanagari-digit dialect.
# A run of 3+ dash-joined numbers collapses to "first-last" ("25-26-27" -> "25-27").
parse_verse_number <- function(heading) {
  heading <- normalize_dash(heading)
  first_last <- function(run, conv = identity) {
    parts <- strsplit(run, "-", fixed = TRUE)[[1]]
    parts <- parts[nzchar(parts)]
    parts <- vapply(parts, conv, character(1), USE.NAMES = FALSE)
    if (length(parts) > 1L) paste0(parts[1L], "-", parts[length(parts)]) else parts[1L]
  }
  m <- regmatches(heading, regexec("^Verses?\\s+([0-9]+(?:-[0-9]+)*)", heading))[[1]]
  if (length(m) >= 2 && nzchar(m[2])) return(first_last(m[2]))
  m <- regmatches(heading, regexec("^श्लोक\\s+([०-९]+(?:-[०-९]+)*)", heading))[[1]]
  if (length(m) >= 2 && nzchar(m[2])) return(first_last(m[2], devanagari_to_arabic))
  stop("Could not parse verse number from heading: ", heading)
}

# Split a markdown file's lines into verse chunks at lines starting with `marker`.
# Returns a list of list(heading, number, lines); when skip_unparseable is TRUE,
# chunks whose heading does not parse to a verse number are dropped and stashed
# in attr(result, "skipped") instead of aborting (used to skip a trailing
# "### पुष्पिका (Colophon)" section in dialect B).
split_verse_chunks <- function(lines, marker = "## ", skip_unparseable = FALSE) {
  pat <- paste0("^", marker)
  starts <- grep(pat, lines)
  if (length(starts) == 0) stop("No '", trimws(marker), "' verse headings found")
  ends <- c(starts[-1] - 1, length(lines))
  out <- list()
  skipped <- list()
  for (i in seq_along(starts)) {
    heading <- sub(pat, "", lines[starts[i]])
    body <- if (ends[i] >= starts[i] + 1) lines[(starts[i] + 1):ends[i]] else character(0)
    num <- tryCatch(parse_verse_number(heading), error = function(e) NULL)
    if (is.null(num)) {
      if (skip_unparseable) {
        skipped[[length(skipped) + 1]] <- list(heading = heading, lines = body)
        next
      }
      stop("Could not parse verse number from heading: ", heading)
    }
    out[[length(out) + 1]] <- list(heading = heading, number = num, lines = body)
  }
  attr(out, "skipped") <- skipped
  out
}

# Split one verse chunk's body lines into subsections at lines starting with `marker`.
# Returns a named list: heading text (trimmed) -> paragraph text (or line vector if
# is_shlok). Blockquote bodies (dialect A) take the ">" path; when a subsection has
# no ">" lines (dialect B), a fenced ```code``` block is read as the shlok text and
# a trailing "*(... लिपि-टिप्पणी ...)*" line is stored under "__manuscript_note__";
# any other dialect-B subsection is joined as a plain paragraph.
split_subsections <- function(body_lines, marker = "### ") {
  pat <- paste0("^", marker)
  starts <- grep(pat, body_lines)
  if (length(starts) == 0) return(list())
  ends <- c(starts[-1] - 1, length(body_lines))
  out <- list()
  shlok_headings <- c("Sanskrit Shloka", "संस्कृत श्लोक",
                      "संस्कृत (मूल हस्तलेख)", "I. Sanskrit Text")
  for (i in seq_along(starts)) {
    heading <- trimws(sub(pat, "", body_lines[starts[i]]))
    raw <- if (ends[i] >= starts[i] + 1) body_lines[(starts[i] + 1):ends[i]] else character(0)
    is_shlok <- heading %in% shlok_headings
    quoted <- raw[grepl("^>", raw)]
    if (length(quoted) > 0) {
      quoted <- sub("^>\\s?", "", quoted)
      quoted <- sub("\\s+$", "", quoted)
      if (is_shlok) {
        out[[heading]] <- paste(quoted, collapse = "\n")
      } else {
        out[[heading]] <- strip_md_emphasis(trimws(paste(quoted, collapse = " ")))
      }
    } else {
      fences <- grep("^```", raw)
      if (length(fences) >= 2) {
        code <- sub("\\s+$", "", raw[(fences[1] + 1):(fences[2] - 1)])
        out[[heading]] <- paste(code, collapse = "\n")
        after <- if (fences[2] < length(raw)) raw[(fences[2] + 1):length(raw)] else character(0)
        note <- after[grepl("^\\s*\\*\\(", after) &
                        grepl("लिपि-टिप्पणी|पाठभेद|Paleographic|Textual Note|वृत्त|Meter", after)]
        if (length(note) > 0) {
          txt <- sub("^\\s*\\*\\((.*)\\)\\*\\s*$", "\\1", note[1])
          out[["__manuscript_note__"]] <- strip_md_emphasis(trimws(txt))
        }
      } else {
        keep <- nzchar(trimws(raw)) & !grepl("^\\s*\\*\\(", raw) & !grepl("^\\s*-{3,}\\s*$", raw)
        out[[heading]] <- strip_md_emphasis(trimws(paste(raw[keep], collapse = " ")))
      }
    }
  }
  out
}

# Map a subsection heading from either dialect onto a canonical field key.
# Order matters: the explicit "notes" name list is checked before the generic
# English-translation branch so that "III. Grandfather's Commentary / Hindi Notes"
# (an embedded Hindi copy) maps to "notes", while "V. English Translation:
# Grandfather's Commentary & Context" maps to "notes_en".
canonical_section_key <- function(heading) {
  h <- trimws(heading)
  if (h %in% c("संस्कृत श्लोक", "Sanskrit Shloka",
               "संस्कृत (मूल हस्तलेख)", "I. Sanskrit Text")) return("shlok")
  if (h %in% c("हिन्दी अनुवाद", "Hindi Translation (Amanuensis)",
               "हिन्दी अनुवाद (लिपिकार)", "II. Hindi Translation (Amanuensis)")) return("translation")
  if (h %in% c("विस्तृत भावार्थ / विशेष टिप्पणी", "Grandfather's Commentary / Hindi Notes",
               "व्याख्या / विशेष टिप्पणी (बाबाजी / रचनाकार)",
               "III. Grandfather's Commentary / Hindi Notes")) return("notes")
  if (grepl("^English Translation", h) || grepl("^IV\\.", h) || grepl("^V\\.", h)) {
    if (grepl("Notes|Context|Commentary", h)) return("notes_en") else return("translation_en")
  }
  if (grepl("पुष्पिका|Colophon", h)) return("colophon")
  if (grepl("पाण्डुलिपि निर्देश|Manuscript Editorial Note", h)) return("editorial_note")
  NA_character_
}

# Full-file parse: list of verse chunks, each with $number, $heading, $sections,
# $dialect. attr(result, "skipped") holds any chunks dropped by skip_unparseable.
parse_md_file <- function(path) {
  lines <- readLines(path, encoding = "UTF-8", warn = FALSE)
  if (length(lines) >= 1) lines[1] <- sub("^\ufeff", "", lines[1])
  dialect <- if (any(grepl("^## ", lines))) "A" else "B"
  vmark <- if (dialect == "A") "## " else "### "
  smark <- if (dialect == "A") "### " else "#### "
  chunks <- split_verse_chunks(lines, marker = vmark, skip_unparseable = (dialect == "B"))
  res <- lapply(chunks, function(ch) {
    list(number = ch$number, heading = ch$heading,
         sections = split_subsections(ch$lines, marker = smark), dialect = dialect)
  })
  attr(res, "skipped") <- attr(chunks, "skipped")
  res
}

# From an English-dialect verse's $sections, get translation_en/notes_en text.
# Legacy rule (dialect A, used by build_sarga2_transcripts.R / merge_sarga1_translations.R):
# any "English Translation (...)" heading containing "Notes" -> notes_en, else translation_en.
english_fields_from_sections <- function(sections) {
  en_headings <- grep("^English Translation", names(sections), value = TRUE)
  translation_en <- NULL
  notes_en <- NULL
  for (h in en_headings) {
    if (grepl("Notes", h)) notes_en <- sections[[h]] else translation_en <- sections[[h]]
  }
  list(translation_en = translation_en, notes_en = notes_en)
}

# Dialect-agnostic version, driven by canonical_section_key (used by build_sarga3).
english_fields_canonical <- function(sections) {
  out <- list(translation_en = NULL, notes_en = NULL)
  for (h in names(sections)) {
    k <- canonical_section_key(h)
    if (identical(k, "translation_en")) out$translation_en <- sections[[h]]
    if (identical(k, "notes_en")) out$notes_en <- sections[[h]]
  }
  out
}
