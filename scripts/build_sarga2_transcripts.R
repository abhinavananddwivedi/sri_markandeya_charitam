# One-off migration: create transcripts/Sarg_2/p033.yml..p060.yml from scratch,
# sourced from transcripts/Sarg_2/*.md (primary Devanagari/Hindi source) and
# transcripts/Sarg_2_English_translation/*.md (English source + Hindi/Sanskrit
# cross-check copy). Mirrors the exact schema/formatting of Sarg_1's yml files.
#
# Usage: Rscript build_sarga2_transcripts.R          (dry run, prints generated yml for pages 33/45/60)
#        Rscript build_sarga2_transcripts.R --write   (writes all 28 files)

source("transcript_md_parser.R")

args <- commandArgs(trailingOnly = TRUE)
write_mode <- "--write" %in% args

dev_dir <- "../transcripts/Sarg_2"
en_dir <- "../transcripts/Sarg_2_English_translation"
out_dir <- "../transcripts/Sarg_2"

normalize_ws <- function(s) if (is.null(s)) "" else gsub("\\s+", " ", trimws(s))

extract_header_devanagari_page <- function(lines) {
  m <- regmatches(lines, regexec("पृष्ठ संख्या:\\s*([०-९]+)", lines))
  hit <- Filter(function(x) length(x) >= 2, m)
  if (length(hit) == 0) stop("No page-number header found")
  hit[[1]][2]
}

extract_sarga_heading <- function(lines) {
  first_verse_line <- grep("^## ", lines)[1]
  head_lines <- if (is.na(first_verse_line)) lines else lines[1:(first_verse_line - 1)]
  m <- regmatches(head_lines, regexec("^\\*\\*(अथ[^*]+)\\*\\*", head_lines))
  hit <- Filter(function(x) length(x) >= 2, m)
  if (length(hit) == 0) NULL else trimws(hit[[1]][2])
}

# page 60 only: the closing rubric line living after the final "---" divider,
# outside any "### " subsection, in the PRIMARY (Sarg_2, dialect B) file.
extract_trailing_rubric <- function(lines) {
  dash_idx <- which(lines == "---")
  if (length(dash_idx) == 0) return(NULL)
  after <- lines[(dash_idx[length(dash_idx)] + 1):length(lines)]
  after <- trimws(after)
  after <- after[nzchar(after)]
  if (length(after) == 0) return(NULL)
  strip_md_emphasis(after[1])
}

fmt_number <- function(n) if (grepl("-", n)) sprintf('"%s"', n) else n

build_text_block <- function(key_indent, key, author, text) {
  c(paste0(key_indent, key, ":"),
    paste0(key_indent, "  author: ", author),
    paste0(key_indent, "  text: |"),
    paste0(key_indent, "    ", text))
}

build_verse_yml <- function(v_dev, v_en, page_is_60_colophon, rubric_line) {
  lines <- c(paste0("  - number: ", fmt_number(v_dev$number)))
  shlok_lines <- strsplit(v_dev$sections[["संस्कृत श्लोक"]], "\n")[[1]]
  lines <- c(lines, "    shlok: |", paste0("      ", shlok_lines))

  hindi_trans <- v_dev$sections[["हिन्दी अनुवाद"]]
  if (!is.null(rubric_line)) {
    # This page's rubric explicitly closes the Hindi TRANSLATION ("...हिन्दी
    # अनुवाद में...सर्ग पूर्ण हुआ"), unlike p032's general Sanskrit colophon
    # (attached there to shlok) -- so it belongs on translation, not shlok.
    hindi_trans <- paste(hindi_trans, rubric_line)
  }
  lines <- c(lines, build_text_block("    ", "translation", "amanuensis", hindi_trans))

  hindi_notes <- v_dev$sections[["विस्तृत भावार्थ / विशेष टिप्पणी"]]
  has_notes <- !is.null(hindi_notes) && nzchar(hindi_notes)
  if (has_notes) {
    lines <- c(lines, build_text_block("    ", "notes", "grandfather", hindi_notes))
  }

  ef <- english_fields_from_sections(v_en$sections)
  if (is.null(ef$translation_en)) stop("verse ", v_dev$number, ": no translation_en in English file")
  lines <- c(lines, build_text_block("    ", "translation_en", "ai_translation", ef$translation_en))
  if (has_notes) {
    if (is.null(ef$notes_en)) stop("verse ", v_dev$number, ": yml has notes but no notes_en in English file")
    lines <- c(lines, build_text_block("    ", "notes_en", "ai_translation", ef$notes_en))
  }
  lines
}

report <- list()
sample_pages <- c(33, 45, 60)

for (page_num in 33:60) {
  dev_path <- file.path(dev_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  en_path <- file.path(en_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  if (!file.exists(dev_path)) stop("Missing: ", dev_path)
  if (!file.exists(en_path)) stop("Missing: ", en_path)

  dev_lines <- readLines(dev_path, encoding = "UTF-8", warn = FALSE)
  dev_page_devanagari <- extract_header_devanagari_page(dev_lines)
  dev_page_arabic <- as.integer(devanagari_to_arabic(dev_page_devanagari))
  if (dev_page_arabic != page_num) {
    stop("Filename/header page mismatch: filename says ", page_num,
         " but header says ", dev_page_devanagari, " (", dev_page_arabic, ")")
  }

  sarga_heading <- if (page_num == 33) extract_sarga_heading(dev_lines) else NULL

  dev_chunks <- parse_md_file(dev_path)
  en_chunks <- parse_md_file(en_path)
  en_by_number <- setNames(en_chunks, vapply(en_chunks, function(c) c$number, character(1)))

  is_colophon_page <- page_num == 60
  rubric_line <- if (is_colophon_page) extract_trailing_rubric(dev_lines) else NULL
  if (is_colophon_page && is.null(rubric_line)) stop("page 60: expected trailing rubric line, found none")

  verse_blocks <- list()
  for (ch in dev_chunks) {
    ve <- en_by_number[[ch$number]]
    if (is.null(ve)) stop("page ", page_num, " verse ", ch$number, ": no matching English-file heading")

    # cross-check the English file's own embedded Hindi/Sanskrit copy against the primary source
    for (key in c("संस्कृत श्लोक", "हिन्दी अनुवाद", "विस्तृत भावार्थ / विशेष टिप्पणी")) {
      en_key <- switch(key,
        "संस्कृत श्लोक" = "Sanskrit Shloka",
        "हिन्दी अनुवाद" = "Hindi Translation (Amanuensis)",
        "विस्तृत भावार्थ / विशेष टिप्पणी" = "Grandfather's Commentary / Hindi Notes")
      a <- ch$sections[[key]]
      b <- ve$sections[[en_key]]
      if (!identical(is.null(a), is.null(b))) {
        report[[length(report) + 1]] <- sprintf(
          "page %d verse %s: presence mismatch for %s -- primary=%s english-file=%s",
          page_num, ch$number, key, !is.null(a), !is.null(b))
      } else if (!is.null(a) && normalize_ws(a) != normalize_ws(b)) {
        report[[length(report) + 1]] <- sprintf(
          "page %d verse %s: ** %s text MISMATCH ** primary=[%s...] english-file=[%s...]",
          page_num, ch$number, key, substr(normalize_ws(a), 1, 50), substr(normalize_ws(b), 1, 50))
      }
    }

    verse_blocks[[length(verse_blocks) + 1]] <- build_verse_yml(ch, ve, is_colophon_page, rubric_line)
  }

  out_lines <- character(0)
  if (!is.null(sarga_heading)) out_lines <- c(out_lines, sprintf('sarga: "%s"', sarga_heading))
  out_lines <- c(out_lines,
    sprintf('page_number_devanagari: "%s"', dev_page_devanagari),
    sprintf("page_number_arabic: %d", page_num),
    sprintf('image: "images/pages/p%03d.jpg"', page_num),
    "verses:")
  for (vb in verse_blocks) out_lines <- c(out_lines, vb)

  source_note <- if (is_colophon_page) {
    "Transcribed via antigravity by the user (2026-08-25/2026-09-02) from the manuscript scan; cross-checked against the independent Hindi/Sanskrit copy embedded in the English-translation export. Closing rubric line taken from this page's own Devanagari transcription (Sarg_2/...page_60.md), not from the differently-worded rubric variant appended in the English-translation export -- and appended to the translation (not the shlok, unlike p032) since its own wording specifically closes the Hindi anuvad ('...हिन्दी अनुवाद में द्वितीय सर्ग पूर्ण हुआ')."
  } else {
    "Transcribed via antigravity by the user (2026-08-25) from the manuscript scan; cross-checked against the independent Hindi/Sanskrit copy embedded in the English-translation export."
  }
  out_lines <- c(out_lines, sprintf('source: "%s"', source_note))

  if (page_num %in% sample_pages || !write_mode) {
    if (page_num %in% sample_pages) {
      cat("\n=== p", sprintf("%03d", page_num), ".yml ===\n", sep = "")
      cat(paste(out_lines, collapse = "\n"), "\n")
    }
  }

  report[[length(report) + 1]] <- sprintf("p%03d: OK, %d verse(s)", page_num, length(verse_blocks))

  if (write_mode) {
    out_path <- file.path(out_dir, sprintf("p%03d.yml", page_num))
    writeLines(out_lines, out_path, useBytes = TRUE)
  }
}

cat("\n", paste(unlist(report), collapse = "\n"), "\n")
cat("\nMode:", if (write_mode) "WRITE" else "DRY RUN (pass --write to apply)", "\n")
