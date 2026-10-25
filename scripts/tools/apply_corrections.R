# Usage: Rscript apply_corrections.R <canto_dir> <corr_glob_dir> <prefix> [--write]
suppressMessages({library(yaml); library(tidyverse)})
a <- commandArgs(TRUE); dir <- a[1]; cdir <- a[2]; prefix <- a[3]; write <- "--write" %in% a
corr <- list.files(cdir, paste0("^", prefix, "_.*\\.yaml$"), full.names = TRUE) |> sort() |> map(read_yaml) |> list_flatten()
block <- function(key, text) c(paste0("    ", key, ":"), "      author: ai_translation", "      text: |",
                                 paste0("        ", str_split(str_trim(text), "\n")[[1]]))
log <- character(0)
for (pg in unique(map_int(corr, "p"))) {
  f <- file.path(dir, sprintf("p%03d.yml", pg)); L <- readLines(f, encoding = "UTF-8")
  for (c in keep(corr, ~ .x$p == pg)) {
    vs <- grep("^  - number: ", L); nums <- str_remove_all(sub("^  - number: ", "", L[vs]), '"')
    k <- which(nums == c$v); if (length(k) != 1) { log <- c(log, sprintf("p%d v%s: verse not found", pg, c$v)); next }
    s <- vs[k]; nxt <- c(vs[vs > s], grep("^[^ ]", L)[grep("^[^ ]", L) > s]); e <- if (length(nxt)) min(nxt) - 1 else length(L)
    fieldrange <- function(key) {
      i <- s - 1 + which(L[s:e] == paste0("    ", key, ":")); if (!length(i)) return(NULL)
      j <- i + 1; while (j <= e && !grepl("^ {0,4}[^ ]", L[j])) j <- j + 1; c(i, j - 1)
    }
    for (key in c("translation_en", "notes_en", "shlok_en")) {
      txt <- c[[switch(key, translation_en = "he", notes_en = "ne", shlok_en = "se")]]
      if (is.null(txt)) next
      r <- fieldrange(key); nb <- block(key, txt)
      if (!is.null(r)) { L <- c(L[seq_len(r[1] - 1)], nb, L[-seq_len(r[2])]) }
      else {
        anchor <- if (key == "shlok_en") { t <- fieldrange("translation"); if (!is.null(t)) t[1] - 1 else e } else e
        if (key == "notes_en" && is.null(fieldrange("notes"))) { log <- c(log, sprintf("p%d v%s: notes_en given but no notes", pg, c$v)) }
        L <- append(L, nb, after = anchor)
      }
      vs <- grep("^  - number: ", L); s <- vs[k]; nxt <- c(vs[vs > s], grep("^[^ ]", L)[grep("^[^ ]", L) > s]); e <- if (length(nxt)) min(nxt) - 1 else length(L)
    }
  }
  ok <- tryCatch({ yaml.load(paste(L, collapse = "\n")); TRUE }, error = function(e) { log <<- c(log, paste(basename(f), "YAML ERROR", conditionMessage(e))); FALSE })
  if (ok && write) writeLines(L, f, useBytes = TRUE)
}
cat("corrections:", length(corr), "\n"); if (length(log)) writeLines(log) else cat("no problems\n")
gr <- map_dfr(corr, ~ tibble(p = .x$p, v = .x$v, he = .x$g$he %||% NA, ne = .x$g$ne %||% NA, s = .x$g$s %||% NA))
write_csv(gr, file.path(cdir, paste0(prefix, "_grades.csv")))
print(gr |> pivot_longer(c(he, ne, s)) |> count(name, value) |> pivot_wider(names_from = value, values_from = n))
