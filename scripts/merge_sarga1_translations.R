# One-off migration: add translation_en/notes_en fields to the 32 existing
# transcripts/Sarg_1/p0NN.yml files, sourced from
# transcripts/Sarg_1_English_translation/*.md. Text-splice approach: existing
# yml content is never rewritten, only new lines appended to the end of each
# verse block. Page 30 (verse 58) is handled separately by hand -- see plan.
#
# Usage: Rscript merge_sarga1_translations.R          (dry run, prints report)
#        Rscript merge_sarga1_translations.R --write   (writes files)

library(yaml)
source("transcript_md_parser.R")

args <- commandArgs(trailingOnly = TRUE)
write_mode <- "--write" %in% args

sarg1_dir <- "../transcripts/Sarg_1"
en_dir <- "../transcripts/Sarg_1_English_translation"

SKIP_PAGES <- c(30)  # handled by hand (see plan: p030/verse 58 Hindi provenance)

normalize_ws <- function(s) if (is.null(s)) "" else gsub("\\s+", " ", trimws(s))

yml_files <- sort(list.files(sarg1_dir, pattern = "^p0[0-9]{2}\\.yml$", full.names = TRUE))

indent_text_block <- function(key, text) {
  c(paste0("    ", key, ":"),
    "      author: ai_translation",
    "      text: |",
    paste0("        ", text))
}

report <- list()

for (yf in yml_files) {
  page_num <- as.integer(sub(".*p0*([0-9]+)\\.yml$", "\\1", yf))
  if (page_num %in% SKIP_PAGES) {
    report[[length(report) + 1]] <- sprintf("p%03d: SKIPPED (handled by hand)", page_num)
    next
  }

  yd <- yaml::read_yaml(yf)
  md_path <- file.path(en_dir, sprintf("sri_markandeya_caritam_page_%d.md", page_num))
  if (!file.exists(md_path)) stop("Missing English translation md for page ", page_num, ": ", md_path)
  md_chunks <- parse_md_file(md_path)
  md_by_number <- setNames(md_chunks, vapply(md_chunks, function(c) c$number, character(1)))

  lines <- readLines(yf, encoding = "UTF-8", warn = FALSE)
  verse_start_lines <- grep("^  - number:", lines)
  if (length(verse_start_lines) != length(yd$verses)) {
    stop("p", page_num, ": verse count mismatch between yaml::read_yaml (", length(yd$verses),
         ") and raw line scan (", length(verse_start_lines), ")")
  }

  insertions <- list()  # list of list(after_line = int, text = chr vector)

  for (i in seq_along(yd$verses)) {
    v <- yd$verses[[i]]
    vnum <- as.character(v$number)
    ch <- md_by_number[[vnum]]
    if (is.null(ch)) stop("p", page_num, " verse ", vnum, ": no matching heading in ", md_path)

    ef <- english_fields_from_sections(ch$sections)
    ins_lines <- character(0)

    if (!is.null(v$translation)) {
      if (is.null(ef$translation_en) || !nzchar(ef$translation_en))
        stop("p", page_num, " verse ", vnum, ": yml has translation but no translation_en found in md")
      # cross-check Hindi translation text matches
      md_hindi <- ch$sections[["Hindi Translation (Amanuensis)"]]
      if (normalize_ws(md_hindi) != normalize_ws(v$translation$text)) {
        report[[length(report) + 1]] <- sprintf(
          "p%03d verse %s: ** Hindi translation text MISMATCH ** yml vs md -- yml=[%s...] md=[%s...]",
          page_num, vnum, substr(normalize_ws(v$translation$text), 1, 50), substr(normalize_ws(md_hindi), 1, 50))
      }
      ins_lines <- c(ins_lines, indent_text_block("translation_en", ef$translation_en))
    }

    if (!is.null(v$notes)) {
      if (is.null(ef$notes_en) || !nzchar(ef$notes_en))
        stop("p", page_num, " verse ", vnum, ": yml has notes but no notes_en found in md")
      md_hindi_notes <- ch$sections[["Grandfather's Commentary / Hindi Notes"]]
      if (normalize_ws(md_hindi_notes) != normalize_ws(v$notes$text)) {
        report[[length(report) + 1]] <- sprintf(
          "p%03d verse %s: ** Hindi notes text MISMATCH ** yml vs md -- yml=[%s...] md=[%s...]",
          page_num, vnum, substr(normalize_ws(v$notes$text), 1, 50), substr(normalize_ws(md_hindi_notes), 1, 50))
      }
      ins_lines <- c(ins_lines, indent_text_block("notes_en", ef$notes_en))
    }

    if (length(ins_lines) > 0) {
      block_start <- verse_start_lines[i]
      block_end <- if (i < length(verse_start_lines)) verse_start_lines[i + 1] - 1 else {
        top_level <- grep("^[A-Za-z_]", lines[(block_start + 1):length(lines)])
        if (length(top_level) > 0) block_start + top_level[1] - 1 else length(lines)
      }
      insertions[[length(insertions) + 1]] <- list(after_line = block_end, text = ins_lines)
    }
  }

  # apply insertions from last to first so earlier line indices stay valid
  insertions <- insertions[order(-vapply(insertions, function(x) x$after_line, numeric(1)))]
  new_lines <- lines
  for (ins in insertions) {
    new_lines <- append(new_lines, ins$text, after = ins$after_line)
  }

  report[[length(report) + 1]] <- sprintf("p%03d: OK, %d verse(s), %d line(s) added",
                                           page_num, length(yd$verses), length(new_lines) - length(lines))

  if (write_mode) {
    writeLines(new_lines, yf, useBytes = TRUE)
  }
}

cat(paste(unlist(report), collapse = "\n"), "\n")
cat("\nMode:", if (write_mode) "WRITE" else "DRY RUN (pass --write to apply)", "\n")
