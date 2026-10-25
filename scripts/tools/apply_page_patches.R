# Merge per-verse patches into transcripts/<canto>/pNNN.yml and re-emit each page in canonical form.
# Usage: Rscript scripts/tools/apply_page_patches.R <canto_dir> <patch.yaml> [--write]
# Patch file: list of {p, v, <field>: text, ...}; fields: shlok, manuscript_note, manuscript_note_en,
#   shlok_en, translation, notes, translation_en, notes_en. A field set to "" is deleted.
# Page-level keys: {p, page: {source: ..., notes_uncertain: true/false}}.
suppressMessages({library(yaml); library(purrr)})
a <- commandArgs(TRUE); dir <- a[1]; patches <- read_yaml(a[2]); write <- "--write" %in% a
auth <- c(manuscript_note = "ai_transcription", manuscript_note_en = "ai_transcription", shlok_en = "ai_translation",
          translation = "amanuensis", notes = "grandfather", translation_en = "ai_translation", notes_en = "ai_translation")
order <- c("shlok", "manuscript_note", "manuscript_note_en", "shlok_en", "translation", "notes", "translation_en", "notes_en")
q <- function(s) paste0('"', gsub('"', '\\\\"', s), '"')
blk <- function(txt, ind) paste0(ind, strsplit(sub("\n+$", "", txt), "\n", fixed = TRUE)[[1]])
emit <- function(y) {
  L <- character(0)
  for (k in c("title", "sarga", "page_number_devanagari")) if (!is.null(y[[k]])) L <- c(L, paste0(k, ": ", q(y[[k]])))
  L <- c(L, paste0("page_number_arabic: ", y$page_number_arabic), paste0("image: ", q(y$image)))
  if (length(y$extra_images)) L <- c(L, paste0("extra_images: [", paste(q(unlist(y$extra_images)), collapse = ", "), "]"))
  L <- c(L, "verses:")
  for (v in y$verses) {
    n <- v$number; L <- c(L, paste0("  - number: ", if (is.character(n) && grepl("-", n)) q(n) else n))
    for (k in order) {
      x <- v[[k]]; if (is.null(x)) next
      if (k == "shlok") { L <- c(L, "    shlok: |", blk(x, "      ")); next }
      L <- c(L, paste0("    ", k, ":"), paste0("      author: ", x$author), "      text: |", blk(x$text, "        "))
    }
  }
  for (k in c("placeholder", "notes_uncertain")) if (isTRUE(y[[k]])) L <- c(L, paste0(k, ": true"))
  if (!is.null(y$source)) L <- c(L, paste0("source: ", q(y$source)))
  L
}
log <- character(0)
for (pg in unique(map_int(patches, "p"))) {
  f <- file.path(dir, sprintf("p%03d.yml", pg)); y <- read_yaml(f)
  for (pt in keep(patches, ~ .x$p == pg)) {
    if (!is.null(pt$page)) { for (k in names(pt$page)) y[[k]] <- pt$page[[k]]; next }
    i <- which(map_chr(y$verses, ~ as.character(.x$number)) == as.character(pt$v))
    if (length(i) != 1) { log <- c(log, sprintf("p%d v%s not found", pg, pt$v)); next }
    for (k in intersect(names(pt), order)) {
      val <- pt[[k]]
      if (!nzchar(trimws(val))) { y$verses[[i]][[k]] <- NULL; next }
      y$verses[[i]][[k]] <- if (k == "shlok") val else list(author = auth[[k]], text = val)
    }
  }
  out <- emit(y)
  chk <- yaml.load(paste(out, collapse = "\n"))
  if (length(chk$verses) != length(y$verses)) log <- c(log, paste(basename(f), "re-emit mismatch"))
  if (write) writeLines(out, f, useBytes = TRUE)
}
cat("patches:", length(patches), if (write) "(written)" else "(dry run)", "\n"); if (length(log)) writeLines(log)
