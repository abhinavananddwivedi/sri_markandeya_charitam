# Migration/Build: create transcripts/Sarg_4/p087.yml..p118.yml from scratch,
# sourced from transcripts/Sarg_4/*.md (primary Devanagari/Hindi source) and
# transcripts/Sarg_4_English_translation/*.md (English source + Hindi/Sanskrit
# cross-check copy). Mirrors the exact schema/formatting of Sarg_1 / Sarg_2 / Sarg_3.
#
# All Canto 4 files use "dialect B": fenced ```sanskrit shlok, plain-text
# Hindi bodies, "#### " subsections, and a paleographic/metre note per shlok that
# is carried into optional fields manuscript_note / manuscript_note_en
# (author: ai_transcription).
#
# Usage: Rscript scripts/build_sarga4_transcripts.R          (dry run, prints sample pages)
#        Rscript scripts/build_sarga4_transcripts.R --write   (writes all 32 files)

# RETIRED 2026-10-24: transcripts/Sarg_4/p087.yml..p118.yml were re-read from the scans
# and corrected by hand; they are now the source of truth. The antigravity markdown
# this script reads is archived in transcripts/Sarg_4/superseded/gemini_rerun_2026-10-24/.
stop("build_sarga4_transcripts.R is retired: Sarg_4 yml files are hand-corrected and must not be regenerated.")

script_dir <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) "scripts")
if (!nzchar(script_dir)) script_dir <- "scripts"
source(file.path(script_dir, "transcript_md_parser.R"))

args <- commandArgs(trailingOnly = TRUE)
write_mode <- "--write" %in% args

dev_dir <- "transcripts/Sarg_4"
en_dir <- "transcripts/Sarg_4_English_translation"
out_dir <- "transcripts/Sarg_4"

normalize_ws <- function(s) if (is.null(s)) "" else gsub("\\s+", " ", trimws(s))

strip_bom <- function(lines) {
  if (length(lines) >= 1) lines[1] <- sub("^﻿", "", lines[1])
  lines
}

# Page number: dialect B "**पृष्ठ ८७ (Page 87)**".
extract_page_devanagari <- function(lines) {
  for (rx in c("पृष्ठ संख्या:\\s*([०-९]+)", "\\*\\*पृष्ठ\\s+([०-९]+)")) {
    m <- regmatches(lines, regexec(rx, lines))
    hit <- Filter(function(x) length(x) >= 2, m)
    if (length(hit)) return(hit[[1]][2])
  }
  stop("No page-number header found")
}

# Canto heading ("**अथ चतुर्थः सर्गः**"), only expected on page 87.
extract_sarga_heading <- function(lines) {
  first_verse_line <- grep("^#{2,3} ", lines)[1]
  head_lines <- if (is.na(first_verse_line)) lines else lines[seq_len(first_verse_line - 1)]
  m <- regmatches(head_lines, regexec("^\\*\\*(अथ[^*]+)\\*\\*", head_lines))
  hit <- Filter(function(x) length(x) >= 2, m)
  if (length(hit) == 0) NULL else trimws(hit[[1]][2])
}

# Page 118: the "**...**" lines under the "### पुष्पिका (Colophon)" heading.
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
  is_colophon_range <- page_num == 118 && grepl("-", num)

  lines <- c(paste0("  - number: ", fmt_number(num)))

  # ---- shlok ---------------------------------------------------------------
  shlok_text <- sec(v_dev, "shlok")
  if (is.null(shlok_text)) stop("page ", page_num, " verse ", num, ": no shlok section")
  shlok_lines <- strsplit(shlok_text, "\n", fixed = TRUE)[[1]]
  if (is_colophon_range) {
    sans_rubric <- colophon_lines[grepl("इति श्री", colophon_lines)]
    if (length(sans_rubric)) shlok_lines <- c(shlok_lines, "", sans_rubric[1])
  }
  shlok_out <- ifelse(nzchar(trimws(shlok_lines)), paste0("      ", shlok_lines), "")
  lines <- c(lines, "    shlok: |", shlok_out)

  # ---- manuscript note ---------------------------------------------------
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
    pointer <- sec(v_dev, "editorial_note")
    hindi_close <- colophon_lines[grepl("सर्ग पूर्ण", colophon_lines)]
    trans <- trimws(paste(c(pointer, hindi_close), collapse = " "))
    lines <- c(lines, build_text_block("    ", "translation", "amanuensis", trans))

    ten_h <- grep("English Translation & Commentary|^III\\.", names(v_en$sections), value = TRUE)[1]
    if (is.na(ten_h)) {
      ten_h <- grep("English Translation", names(v_en$sections), value = TRUE)[1]
    }
    if (!is.na(ten_h)) {
      lines <- c(lines, build_text_block("    ", "translation_en", "ai_translation",
                                         v_en$sections[[ten_h]]))
    }
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
  "Transcribed via antigravity (flash-tier batch subagents, 2026-09) from the manuscript scan. ",
  "The Hindi/Sanskrit copy embedded in the English-translation export is byte-identical to the ",
  "primary export, so it is not an independent cross-check; no second transcription exists for this canto.")

DIALECT_B_SRC <- paste0(
  " This page's source markdown uses antigravity 'dialect B': the shlok is a fenced ",
  "code block, the Hindi anuvad and vyakhya are plain-text paragraphs, ",
  "and each shlok carries a paleographic / variant-reading / metre note (वृत्त: रथोद्धता / अनुष्टुप्) ",
  "captured here as manuscript_note / manuscript_note_en (author: ai_transcription).")

source_note_for <- function(page_num, colophon_lines) {
  s <- paste0(BASE_SRC, DIALECT_B_SRC)
  if (page_num == 118) {
    s <- paste0(s, " Colophon page. Slokas 64-66 are the recurring benedictory triad (kavi-vamsa paricaya / ",
                "Jnanesvari-Siva aradhana / kavya-mangala kamana) whose word-by-word Hindi ",
                "gloss the manuscript itself defers to canto 1 page 32 ('श्लोकों का अर्थ ",
                "कृपया पृष्ठ ३२ में अवलोकन करें'); this verse therefore carries that ",
                "pointer plus the Hindi canto-close as translation and the English-export summary ",
                "as translation_en, with no notes -- mirroring p032 / p060 / p086. The Sanskrit colophon rubric ",
                "(॥ इति श्री मार्कण्डेयचरिते महाकाव्ये चतुर्थः सर्गः समाप्तः ॥) is appended to ",
                "that verse's shlok.")
  }
  s
}

# ---- main loop -----------------------------------------------------------

report <- local({
  items <- character(0)
  list(add = function(x) items[[length(items) + 1]] <<- x,
       all = function() items)
})

sample_pages <- c(87, 94, 100, 106, 112, 118)

for (page_num in 87:118) {
  dev_path <- file.path(dev_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  en_path <- file.path(en_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  if (!file.exists(dev_path)) {
    report$add(sprintf("p%03d: Devanagari file not found yet (%s)", page_num, dev_path))
    next
  }
  if (!file.exists(en_path)) {
    report$add(sprintf("p%03d: English file not found yet (%s)", page_num, en_path))
    next
  }

  dev_lines <- strip_bom(readLines(dev_path, encoding = "UTF-8", warn = FALSE))

  dev_page_devanagari <- extract_page_devanagari(dev_lines)
  dev_page_arabic <- as.integer(devanagari_to_arabic(dev_page_devanagari))
  if (is.na(dev_page_arabic) || dev_page_arabic != page_num) {
    stop("Filename/header page mismatch: filename says ", page_num,
         " but header says ", dev_page_devanagari, " (", dev_page_arabic, ")")
  }

  sarga_heading <- if (page_num == 87) extract_sarga_heading(dev_lines) else NULL
  if (page_num == 87 && is.null(sarga_heading)) stop("page 87: expected a canto heading, found none")

  colophon_lines <- if (page_num == 118) extract_colophon_lines(dev_lines) else character(0)

  dev_chunks <- parse_md_file(dev_path)
  en_chunks <- parse_md_file(en_path)
  en_by_number <- setNames(en_chunks, vapply(en_chunks, function(c) c$number, character(1)))

  verse_blocks <- list()
  for (ch in dev_chunks) {
    ve <- en_by_number[[ch$number]]
    if (is.null(ve)) stop("page ", page_num, " verse ", ch$number, ": no matching English-file heading")

    for (canon in c("shlok", "translation", "notes")) {
      a <- sec(ch, canon)
      b <- sec(ve, canon)
      if (!identical(is.null(a), is.null(b))) {
        report$add(sprintf(
          "page %d verse %s: presence mismatch for %s -- primary=%s english-file=%s",
          page_num, ch$number, CANON_LABEL[[canon]], !is.null(a), !is.null(b)))
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
  out_lines <- c(out_lines, sprintf('source: "%s"', source_note_for(page_num, colophon_lines)))

  if (page_num %in% sample_pages) {
    cat("\n=== p", sprintf("%03d", page_num), ".yml ===\n", sep = "")
    cat(paste(out_lines, collapse = "\n"), "\n")
  }

  report$add(sprintf("p%03d: OK, %d verse(s)", page_num, length(verse_blocks)))

  if (write_mode) {
    writeLines(out_lines, file.path(out_dir, sprintf("p%03d.yml", page_num)), useBytes = TRUE)
  }
}

cat("\n", paste(report$all(), collapse = "\n"), "\n", sep = "")
cat("\nMode:", if (write_mode) "WRITE" else "DRY RUN (pass --write to apply)", "\n")
