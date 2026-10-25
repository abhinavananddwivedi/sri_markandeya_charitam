# ONE-OFF (run 2026-10-24 by Claude; kept for the record; do not re-run).
# Restructures canto-1 pages 28-31 to match the manuscript (see PROJECT_LOG.md, 2026-10-24).
# Originals: transcripts/Sarg_1/superseded/canto1_fix_2026-10-24/*.yaml
suppressMessages(library(yaml))
d <- "transcripts/Sarg_1"
rd <- function(f) readLines(file.path(d, f), encoding = "UTF-8")
wr <- function(L, f) { yaml.load(paste(L, collapse = "\n")); writeLines(L, file.path(d, f), useBytes = TRUE) }
sub1 <- function(L, old, new) { i <- grep(old, L, fixed = TRUE); stopifnot(length(i) == 1); L[i] <- sub(old, new, L[i], fixed = TRUE); L }
src <- function(L, s) { i <- grep("^source:", L); L[i] <- paste0('source: "', s, '"'); L }

# p028: drop the v57 notes-tail fragment (it belongs to v57's notes on p029; its sheet is p029_overflow.jpg)
L <- rd("p028.yml"); a <- grep("^  - number: 57", L); b <- grep("^source:", L)
L <- c(L[1:(a - 1)], L[b:length(L)])
L <- src(L, "Transcribed via Google Lens by the user; structural cross-check against the scan done by Claude. 2026-10-24: the v57 notes-tail formerly held here was moved to v57 on p029 (it is written on the facing sheet, images/pages/p029_overflow.jpg).")
wr(L, "p028.yml")

# p029: append the notes tail from the overflow sheet to v57; register the overflow image
tail57 <- "जल का पान न कर अपनी देवी महनीय यशस्विता का विनाश क्यों कर रहे हैं? जिससे आपकी यथा-मलिनता विश्व में व्याप्त हो रही है। अहो! अभी क्या बिगड़ा है? अहो! अभी आप तत्काल अत्यन्त शीघ्रतापूर्वक गङ्गाजल पान कर सद्यः मुक्ति-फल प्राप्त करें एवं सतत भगवती गङ्गा के प्रति निष्ठावान् बने रहें, यही गङ्गा-महिमा का सुसंदेश है ॥ ५७ ॥"
L <- rd("p029.yml")
L <- sub1(L, "देवी गङ्गा के ५७", paste("देवी गङ्गा के →", tail57))
L <- sub1(L, "free-flowing ...\" [continued on the next sheet] (57)",
  "free-flowing ... → ... why are you destroying your own great divine glory by not drinking [her] water? Through this your stain spreads in the world. Oh! What has been lost yet? Oh! Drink the Gaṅgā water right now, very quickly, and at once obtain the fruit of liberation, and remain always faithful to the goddess Gaṅgā; this is the good message of the greatness of Gaṅgā.\" (57)")
L <- append(L, 'extra_images: ["images/pages/p029_overflow.jpg"]', after = grep("^image:", L))
L <- src(L, "Transcribed via Google Lens by the user; structural cross-check against the scan done by Claude. The end of v57's notes is written on the facing sheet (images/pages/p029_overflow.jpg) and is joined to the notes here (2026-10-24).")
wr(L, "p029.yml")

# p031: the manuscript numbers these verses 61 and 62 (they were labelled 59 and \"60-62\" to hide the untranscribed page 30)
tail62 <- "→ क्योंकि मन वाणी को अगम अगोचर (सो जाने जो पावे)। न तत्र वाग्गच्छति, न मनः, नेन्द्रियाणि। अतः सगुण स्नेहमयी प्रत्यक्ष मूर्ति मातृस्वरूपा भगवती गङ्गा का हम सदा आश्रयण करते हैं। ६२"
L <- rd("p031.yml")
L <- sub1(L, "  - number: 59", "  - number: 61")
L <- sub1(L, '  - number: "60-62"', "  - number: 62")
L <- sub1(L, "[Verse numbered ६१ in the manuscript.] ", "")
L <- sub1(L, "[Verse numbered ६२ in the manuscript.] ", "")
i <- grep("ढोंगी ही होते हैं। ६२", L, fixed = TRUE); stopifnot(length(i) == 1)
L[i] <- sub("ढोंगी ही होते हैं। ६२", paste("ढोंगी ही होते हैं।", tail62), L[i], fixed = TRUE)
L <- gsub("\\((59|60-62)\\)$", "(@@)", L)
k <- grep("\\(@@\\)$", L); L[k[k < grep("^  - number: 62", L)]] <- sub("(@@)", "(61)", L[k[k < grep("^  - number: 62", L)]], fixed = TRUE)
L <- gsub("(@@)", "(62)", L, fixed = TRUE)
L <- sub1(L, "are mere hypocrites.\" (62)", "are mere hypocrites. For [the Absolute] is beyond the reach of mind and speech (only one who attains it knows it): 'there speech does not go, nor mind, nor the senses'. So we always take refuge in the goddess Gaṅgā, who has qualities, is full of love, is a visible form, and is our mother.\" (62)")
L <- append(L, 'extra_images: ["images/pages/p031_overflow.jpg"]', after = grep("^image:", L))
L <- src(L, "Transcribed via Google Lens by the user (2026-08-21) from a 2026-08-12 reshoot; structural cross-check against the scan done by Claude. 2026-10-24: verses relabelled 61 and 62 as numbered in the manuscript (previously 59 and \\\"60-62\\\", because page 30, vv. 59-60, had not been transcribed). The end of v62's notes is on the facing sheet (images/pages/p031_overflow.jpg) and is joined to the notes here.")
wr(L, "p031.yml")
cat("ok\n")
