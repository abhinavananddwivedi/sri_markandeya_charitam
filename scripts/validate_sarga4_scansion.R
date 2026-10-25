# scripts/validate_sarga4_scansion.R
# Validates syllable counts and metrical regularity for Sarga 4 (Verses 1 to 66)

library(yaml)

count_sanskrit_syllables <- function(line) {
  # Clean line of punctuation, numbers, danda, avagraha, whitespace
  s <- gsub("[।॥०-९0-9\\s\\'\"\\-\\?\\!\\(\\)\\[\\]\\.,:;]+", "", line)
  if (!nzchar(s)) return(0)
  
  chars <- strsplit(s, "")[[1]]
  n <- length(chars)
  count <- 0
  vowels <- c("अ","आ","इ","ई","उ","ऊ","ऋ","ॠ","ऌ","ॡ","ए","ऐ","ओ","औ")
  virama <- "्"
  
  is_consonant <- function(ch) {
    cp <- utf8ToInt(ch)
    (cp >= 0x0915 && cp <= 0x0939) || (cp >= 0x0958 && cp <= 0x095F)
  }
  
  i <- 1
  while (i <= n) {
    ch <- chars[i]
    if (ch %in% vowels) {
      count <- count + 1
    } else if (is_consonant(ch)) {
      if (i < n && chars[i + 1] == virama) {
        i <- i + 1
      } else {
        count <- count + 1
      }
    }
    i <- i + 1
  }
  count
}

validate_all <- function() {
  files <- sprintf("transcripts/Sarg_4/p%03d.yml", 87:118)
  results <- list()
  
  for (f in files) {
    if (!file.exists(f)) next
    data <- yaml::read_yaml(f)
    p_num <- data$page_number_arabic
    
    for (v in data$verses) {
      num <- v$number
      shlok <- v$shlok
      lines <- strsplit(shlok, "\n")[[1]]
      lines <- trimws(lines)
      lines <- lines[nzchar(lines)]
      
      # Syllable counts
      counts <- sapply(lines, count_sanskrit_syllables)
      results[[length(results) + 1]] <- list(
        page = p_num,
        verse = num,
        lines = lines,
        counts = counts
      )
    }
  }
  
  cat("=== SARGA 4 METRICAL AUDIT ===\n\n")
  total_verses <- length(results)
  cat(sprintf("Total verses analyzed: %d\n\n", total_verses))
  
  for (r in results) {
    counts_str <- paste(r$counts, collapse = ", ")
    expected <- if (r$verse == 15) {
      "Anustubh (8, 8, 8, 8)"
    } else if (r$verse == 63) {
      "Shardulavikridita (19, 19, 19, 19)"
    } else if (grepl("-", as.character(r$verse))) {
      "Triad / Colophon"
    } else {
      "Rathoddhata (11, 11, 11, 11)"
    }
    
    cat(sprintf("Page %03d | Verse %s | Counts: [%s] | Expected: %s\n",
                r$page, r$verse, counts_str, expected))
  }
}

if (!interactive()) {
  validate_all()
}
