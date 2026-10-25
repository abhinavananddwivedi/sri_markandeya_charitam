# Laghu/guru scansion of every shlok line in a canto directory.
# Usage: Rscript scripts/tools/scan_metre.R transcripts/Sarg_N [out.csv]
# Prints the metre distribution; writes one row per line (page, verse, line, text, pattern, metre).
# Syllable weight: long vowel, anusvara/visarga, or a following consonant cluster => G (guru);
# the last syllable of a line is anceps, so the metre regexes end in ".".
suppressMessages({library(yaml); library(tidyverse)})

long_v  <- c("आ","ई","ऊ","ॠ","ए","ऐ","ओ","औ","ा","ी","ू","ॄ","े","ै","ो","ौ")
matras  <- c("ा","ि","ी","ु","ू","ृ","ॄ","े","ै","ो","ौ")
indep   <- c("अ","आ","इ","ई","उ","ऊ","ऋ","ॠ","ऌ","ए","ऐ","ओ","औ")
is_cons <- function(ch) { cp <- utf8ToInt(ch); (cp >= 0x0915 && cp <= 0x0939) || (cp >= 0x0958 && cp <= 0x095F) }

scan_line <- function(line) {
  line <- str_remove_all(line, "॥.*$|।.*$") |> str_remove_all("\\[unclear[^]]*\\]") |>
    str_remove_all("[^ऀ-ॿ]") |> str_remove_all("[ऽ।॥०-९़ँ]")
  ch <- strsplit(line, "")[[1]]; n <- length(ch); wt <- character(0); cons <- 0; i <- 1
  new_syl <- function(is_long) {
    if (length(wt) && cons >= 2) wt[length(wt)] <<- "G"
    wt <<- c(wt, if (is_long) "G" else "L"); cons <<- 0
  }
  while (i <= n) {
    c0 <- ch[i]
    if (is_cons(c0)) {
      cons <- cons + 1; nx <- if (i < n) ch[i + 1] else ""
      if (nx == "्") { i <- i + 2; next }
      if (nx %in% matras) { new_syl(nx %in% long_v); i <- i + 2; next }
      new_syl(FALSE); i <- i + 1; next
    }
    if (c0 %in% indep) { new_syl(c0 %in% long_v); i <- i + 1; next }
    if (c0 %in% c("ं", "ः") && length(wt)) wt[length(wt)] <- "G"
    i <- i + 1
  }
  if (cons >= 1 && length(wt)) wt[length(wt)] <- "G"
  paste(wt, collapse = "")
}

metres <- c(rathoddhata = "GLGLLLGLGL.", svagata = "GLGLLLGLLG.", vamsastha = "LGLGGLLGLGL.",
            indravamsa = "GGLGGLLGLGL.", indravajra = "GGLGGLLGLG.", upendravajra = "LGLGGLLGLG.",
            drutavilambita = "LLLGLLGLLGL.", vasantatilaka = "GGLGLLLGLLGLG.",
            sardula = "GGGLLGLGLLLGGGLGGL.", anustubh = "........")
which_metre <- function(p) { m <- names(metres)[map_lgl(metres, ~ str_detect(p, paste0("^", .x, "$")))]; if (length(m)) paste(m, collapse = "/") else "-" }

a <- commandArgs(TRUE); dir <- a[1]
rows <- map_dfr(list.files(dir, "^p\\d+\\.yml$", full.names = TRUE), function(f) {
  y <- read_yaml(f)
  map_dfr(y$verses, function(v) {
    if (is.null(v$shlok) || !nzchar(v$shlok)) return(NULL)
    ls <- str_trim(str_split(v$shlok, "\n")[[1]]); ls <- ls[nzchar(ls)]
    tibble(page = y$page_number_arabic, verse = as.character(v$number), line = seq_along(ls), text = ls, pat = map_chr(ls, scan_line))
  })
}) |> mutate(n = nchar(pat), metre = map_chr(pat, which_metre))
if (length(a) >= 2) write_csv(rows, a[2])
cat(dir, ": lines", nrow(rows), "\n"); print(count(rows, metre, sort = TRUE), n = 12)
