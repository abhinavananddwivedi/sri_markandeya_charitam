# One-off migration: create transcripts/Sarg_3/p061.yml..p086.yml from scratch,
# sourced from transcripts/Sarg_3/*.md (primary Devanagari/Hindi source) and
# transcripts/Sarg_3_English_translation/*.md (English source + Hindi/Sanskrit
# cross-check copy). Mirrors the exact schema/formatting of Sarg_1 / Sarg_2.
#
# Canto 3's source markdown comes in two dialects (auto-detected by the shared
# parser): pages 61-75 are byte-identical in structure to canto 2 ("dialect A");
# pages 76-86 are a newer "dialect B" -- fenced ```sanskrit shlok, plain-text
# Hindi bodies, "#### " subsections, and a paleographic/metre note per shlok that
# is carried into new optional fields manuscript_note / manuscript_note_en
# (author: ai_transcription).
#
# Usage: Rscript build_sarga3_transcripts.R          (dry run, prints pages 61/71/73/76/86)
#        Rscript build_sarga3_transcripts.R --write   (writes all 26 files)

source("transcript_md_parser.R")

args <- commandArgs(trailingOnly = TRUE)
write_mode <- "--write" %in% args

dev_dir <- "../transcripts/Sarg_3"
en_dir <- "../transcripts/Sarg_3_English_translation"
out_dir <- "../transcripts/Sarg_3"

normalize_ws <- function(s) if (is.null(s)) "" else gsub("\\s+", " ", trimws(s))

strip_bom <- function(lines) {
  if (length(lines) >= 1) lines[1] <- sub("^﻿", "", lines[1])
  lines
}

# Page number: dialect A "*(पृष्ठ संख्या: ६१)*" or dialect B "**पृष्ठ ८६ (Page 86)**".
extract_page_devanagari <- function(lines) {
  for (rx in c("पृष्ठ संख्या:\\s*([०-९]+)", "\\*\\*पृष्ठ\\s+([०-९]+)")) {
    m <- regmatches(lines, regexec(rx, lines))
    hit <- Filter(function(x) length(x) >= 2, m)
    if (length(hit)) return(hit[[1]][2])
  }
  stop("No page-number header found")
}

# Canto heading ("**अथ तृतीयः सर्गः**"), only expected on page 61 (dialect A).
extract_sarga_heading <- function(lines) {
  first_verse_line <- grep("^#{2,3} ", lines)[1]
  head_lines <- if (is.na(first_verse_line)) lines else lines[seq_len(first_verse_line - 1)]
  m <- regmatches(head_lines, regexec("^\\*\\*(अथ[^*]+)\\*\\*", head_lines))
  hit <- Filter(function(x) length(x) >= 2, m)
  if (length(hit) == 0) NULL else trimws(hit[[1]][2])
}

# Page 71: the ">" editorial note sitting before the first verse heading. Folded
# into that page's source: string, not attached to a verse.
extract_leading_editorial_note <- function(lines) {
  fv <- grep("^#{2,3} ", lines)[1]
  if (is.na(fv) || fv <= 1) return(NULL)
  head_lines <- lines[seq_len(fv - 1)]
  q <- head_lines[grepl("^>\\s", head_lines)]
  if (length(q) == 0) return(NULL)
  strip_md_emphasis(trimws(paste(sub("^>\\s?", "", q), collapse = " ")))
}

# Page 86: the "**...**" lines under the "### पुष्पिका (Colophon)" heading.
# Returns c(hindi_close, sanskrit_rubric) in source order.
extract_colophon_lines <- function(lines) {
  h <- grep("^#{2,4}\\s+(पुष्पिका|Colophon)", lines)[1]
  if (is.na(h)) return(character(0))
  rest <- lines[(h + 1):length(lines)]
  bolds <- rest[grepl("^\\*\\*.+\\*\\*\\s*$", rest)]
  strip_md_emphasis(trimws(bolds))
}

fmt_number <- function(n) if (grepl("-", n)) sprintf('"%s"', n) else n

build_text_block <- function(key_indent, key, author, text) {
  c(paste0(key_indent, key, ":"),
    paste0(key_indent, "  author: ", author),
    paste0(key_indent, "  text: |"),
    paste0(key_indent, "    ", text))
}

# Fetch the section text for a canonical key from a parsed verse chunk.
sec <- function(chunk, key) {
  for (h in names(chunk$sections)) {
    if (identical(canonical_section_key(h), key)) return(chunk$sections[[h]])
  }
  NULL
}

CANON_LABEL <- c(shlok = "संस्कृत श्लोक", translation = "हिन्दी अनुवाद",
                 notes = "विस्तृत भावार्थ / विशेष टिप्पणी")

build_verse_yml <- function(v_dev, v_en, page_num, colophon_lines, report_ref) {
  num <- v_dev$number
  is_colophon_range <- page_num == 86 && grepl("-", num)

  lines <- c(paste0("  - number: ", fmt_number(num)))

  # ---- shlok ---------------------------------------------------------------
  shlok_text <- sec(v_dev, "shlok")
  if (is.null(shlok_text)) stop("page ", page_num, " verse ", num, ": no shlok section")
  shlok_lines <- strsplit(shlok_text, "\n", fixed = TRUE)[[1]]
  if (is_colophon_range) {
    # Sanskrit close-of-canto rubric appended to the shlok, as on p032.
    sans_rubric <- colophon_lines[grepl("इति श्री", colophon_lines)]
    if (length(sans_rubric)) shlok_lines <- c(shlok_lines, "", sans_rubric[1])
  }
  shlok_out <- ifelse(nzchar(trimws(shlok_lines)), paste0("      ", shlok_lines), "")
  lines <- c(lines, "    shlok: |", shlok_out)

  # ---- manuscript note (dialect B, after the shlok) ----------------------
  mnote <- v_dev$sections[["__manuscript_note__"]]
  mnote_en <- v_en$sections[["__manuscript_note__"]]
  if (!is.null(mnote) && nzchar(mnote)) {
    lines <- c(lines, build_text_block("    ", "manuscript_note", "ai_transcription", mnote))
    if (is.null(mnote_en) || !nzchar(mnote_en)) {
      report_ref$add(sprintf("p%03d verse %s: dev has manuscript_note but English file does not", page_num, num))
    } else {
      lines <- c(lines, build_text_block("    ", "manuscript_note_en", "ai_transcription", mnote_en))
    }
  } else if (!is.null(mnote_en) && nzchar(mnote_en)) {
    report_ref$add(sprintf("p%03d verse %s: English file has manuscript_note but dev does not", page_num, num))
  }

  if (is_colophon_range) {
    # p086 ślokas 53-55: the recurring benedictory triad. The manuscript itself
    # defers the word-by-word gloss to canto 1 page 32, so -- as on p032/p060 --
    # this verse carries only translation / translation_en, no notes.
    pointer <- sec(v_dev, "editorial_note")
    hindi_close <- colophon_lines[grepl("सर्ग पूर्ण", colophon_lines)]
    trans <- trimws(paste(c(pointer, hindi_close), collapse = " "))
    lines <- c(lines, build_text_block("    ", "translation", "amanuensis", trans))

    ten_h <- grep("English Translation & Commentary|^III\\.", names(v_en$sections), value = TRUE)[1]
    if (is.na(ten_h)) stop("p086 verse ", num, ": no English '... & Commentary' section")
    lines <- c(lines, build_text_block("    ", "translation_en", "ai_translation",
                                       v_en$sections[[ten_h]]))
    return(lines)
  }

  # ---- translation ------------------------------------------------------
  trans <- sec(v_dev, "translation")
  if (is.null(trans) || !nzchar(trans)) stop("page ", page_num, " verse ", num, ": no translation")
  lines <- c(lines, build_text_block("    ", "translation", "amanuensis", trans))

  # ---- notes (optional) -----------------------------------------------
  notes <- sec(v_dev, "notes")
  has_notes <- !is.null(notes) && nzchar(notes)
  if (has_notes) {
    lines <- c(lines, build_text_block("    ", "notes", "grandfather", notes))
  }

  # ---- english --------------------------------------------------------
  ef <- english_fields_canonical(v_en$sections)
  if (is.null(ef$translation_en)) stop("page ", page_num, " verse ", num, ": no translation_en in English file")
  lines <- c(lines, build_text_block("    ", "translation_en", "ai_translation", ef$translation_en))
  if (has_notes) {
    if (is.null(ef$notes_en)) stop("page ", page_num, " verse ", num, ": yml has notes but no notes_en in English file")
    lines <- c(lines, build_text_block("    ", "notes_en", "ai_translation", ef$notes_en))
  }
  lines
}

# ---- source: strings -------------------------------------------------------

BASE_SRC <- paste0(
  "Transcribed via antigravity by the user (2026-08/2026-09) from the manuscript scan; ",
  "cross-checked against the independent Hindi/Sanskrit copy embedded in the English-translation export.")

DIALECT_B_SRC <- paste0(
  " This page's source markdown uses the later antigravity 'dialect B': the shlok is a fenced ",
  "code block rather than a blockquote, the Hindi anuvad and vyakhya are plain-text paragraphs, ",
  "and each shlok carries a paleographic / variant-reading / metre note (वृत्त: रथोद्धता) ",
  "captured here as manuscript_note / manuscript_note_en (author: ai_transcription).")

source_note_for <- function(page_num, dialect, leading_note) {
  s <- BASE_SRC
  if (dialect == "B") s <- paste0(s, DIALECT_B_SRC)
  if (page_num == 71 && !is.null(leading_note)) {
    s <- paste0(s, " Page 71's manuscript had a struck-out draft of the description of ",
                "Parasara in the top margin; the scribal note recording that it was crossed ",
                "out and re-entered in order on page 73 as slokas 25-27 is preserved here: ",
                leading_note)
  }
  if (page_num == 73) {
    s <- paste0(s, " Slokas 25-27 are grouped under a single source heading ",
                "(श्लोक २५-२६-२७) and handled as one range verse, per the p032 / p060 precedent.")
  }
  if (page_num == 86) {
    s <- paste0(s, " Colophon page. Sloka 52 is the final narrative verse of the canto. ",
                "Slokas 53-55 are the recurring benedictory triad (kavi-vamsa paricaya / ",
                "Jnanesvari-Siva aradhana / kavya-mangala kamana) whose word-by-word Hindi ",
                "gloss the manuscript itself defers to canto 1 page 32 ('श्लोकों का अर्थ ",
                "कृपया पृष्ठ ३२ में अवलोकन करें'); this verse therefore carries only that ",
                "pointer plus the Hindi canto-close (यहाँ तृतीय सर्ग पूर्ण हुआ) as ",
                "translation and the English-export summary as translation_en, with no notes ",
                "-- mirroring p032 / p060. The Sanskrit colophon rubric ",
                "(॥ इति श्री मार्कण्डेयचरिते महाकाव्ये तृतीयः सर्गः समाप्तः ॥) is appended to ",
                "that verse's shlok, as on p032.")
  }
  s
}

# ---- main loop -----------------------------------------------------------

report <- local({
  items <- character(0)
  list(add = function(x) items[[length(items) + 1]] <<- x,
       all = function() items)
})

sample_pages <- c(61, 71, 73, 76, 86)

for (page_num in 61:86) {
  dev_path <- file.path(dev_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  en_path <- file.path(en_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  if (!file.exists(dev_path)) stop("Missing: ", dev_path)
  if (!file.exists(en_path)) stop("Missing: ", en_path)

  dev_lines <- strip_bom(readLines(dev_path, encoding = "UTF-8", warn = FALSE))

  dialect <- if (any(grepl("^## ", dev_lines))) "A" else "B"
  expect <- if (page_num <= 75) "A" else "B"
  if (dialect != expect) {
    report$add(sprintf("p%03d: dialect is %s, expected %s", page_num, dialect, expect))
  }

  dev_page_devanagari <- extract_page_devanagari(dev_lines)
  dev_page_arabic <- as.integer(devanagari_to_arabic(dev_page_devanagari))
  if (is.na(dev_page_arabic) || dev_page_arabic != page_num) {
    stop("Filename/header page mismatch: filename says ", page_num,
         " but header says ", dev_page_devanagari, " (", dev_page_arabic, ")")
  }

  sarga_heading <- if (page_num == 61) extract_sarga_heading(dev_lines) else NULL
  if (page_num == 61 && is.null(sarga_heading)) stop("page 61: expected a canto heading, found none")

  leading_note <- if (page_num == 71) extract_leading_editorial_note(dev_lines) else NULL
  colophon_lines <- if (page_num == 86) extract_colophon_lines(dev_lines) else character(0)
  if (page_num == 86 && length(colophon_lines) < 2) stop("page 86: expected colophon lines, found ", length(colophon_lines))

  dev_chunks <- parse_md_file(dev_path)
  en_chunks <- parse_md_file(en_path)
  en_by_number <- setNames(en_chunks, vapply(en_chunks, function(c) c$number, character(1)))

  verse_blocks <- list()
  for (ch in dev_chunks) {
    ve <- en_by_number[[ch$number]]
    if (is.null(ve)) stop("page ", page_num, " verse ", ch$number, ": no matching English-file heading")

    # cross-check the English file's embedded Hindi/Sanskrit copy against the primary source
    for (canon in c("shlok", "translation", "notes")) {
      a <- sec(ch, canon)
      b <- sec(ve, canon)
      if (!identical(is.null(a), is.null(b))) {
        report$add(sprintf(
          "page %d verse %s: presence mismatch for %s -- primary=%s english-file=%s",
          page_num, ch$number, CANON_LABEL[[canon]], !is.null(a), !is.null(b)))
      } else if (!is.null(a) && normalize_ws(a) != normalize_ws(b)) {
        report$add(sprintf(
          "page %d verse %s: ** %s text MISMATCH ** primary=[%s...] english-file=[%s...]",
          page_num, ch$number, CANON_LABEL[[canon]],
          substr(normalize_ws(a), 1, 50), substr(normalize_ws(b), 1, 50)))
      }
    }

    verse_blocks[[length(verse_blocks) + 1]] <- build_verse_yml(ch, ve, page_num, colophon_lines, report)
  }

  out_lines <- character(0)
  if (!is.null(sarga_heading)) out_lines <- c(out_lines, sprintf('sarga: "%s"', sarga_heading))
  out_lines <- c(out_lines,
    sprintf('page_number_devanagari: "%s"', dev_page_devanagari),
    sprintf("page_number_arabic: %d", page_num),
    sprintf('image: "images/pages/p%03d.jpg"', page_num),
    "verses:")
  for (vb in verse_blocks) out_lines <- c(out_lines, vb)
  out_lines <- c(out_lines, sprintf('source: "%s"', source_note_for(page_num, dialect, leading_note)))

  if (page_num %in% sample_pages) {
    cat("\n=== p", sprintf("%03d", page_num), ".yml ===\n", sep = "")
    cat(paste(out_lines, collapse = "\n"), "\n")
  }

  report$add(sprintf("p%03d: OK, %d verse(s) [dialect %s]", page_num, length(verse_blocks), dialect))

  if (write_mode) {
    writeLines(out_lines, file.path(out_dir, sprintf("p%03d.yml", page_num)), useBytes = TRUE)
  }
}

cat("\n", paste(report$all(), collapse = "\n"), "\n", sep = "")
cat("\nMode:", if (write_mode) "WRITE" else "DRY RUN (pass --write to apply)", "\n")
