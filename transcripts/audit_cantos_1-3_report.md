# Audit of cantos 1–3: English translations, shlok_en, page numbering

Claude (Opus 5.5), 2026-10-24. Status: **COMPLETE.** All changes are in `transcripts/Sarg_{1,2,3}/*.yml` and `docs/` is rebuilt; nothing is committed. Per-verse corrections and grades are in `transcripts/audit_cantos_1-3/` (`c1_*.yaml`, `c2_*.yaml`, `c3_*.yaml`, `c*_grades.csv`).

## 1. What was done
- **`translation_en` and `notes_en` were checked against the Hindi** for all 169 verse blocks (170 blocks, minus one fabricated block). Every block that was not faithful was rewritten in plain English that follows the Hindi. Where the Hindi as transcribed is garbled, the English says so (`[unclear: …]`, `[as written]`) rather than smoothing it over.
- **`shlok_en` (a direct translation of the Sanskrit) was added to every verse.** Where the transcribed Sanskrit is corrupt, `shlok_en` translates only what can be construed and says the rest is unclear; it does not borrow meaning from the Hindi.
- **Transcription was taken as given** (per the user's instruction), except where the page-numbering check exposed problems (§3).

## 2. Findings: English

| | Old `translation_en` | Old `notes_en` |
|---|---|---|
| Canto 1 (63 blocks) | 10 OK · 47 minor · 5 major | 1 OK · 56 minor · 5 major |
| Canto 2 (55 blocks) | 6 OK · 46 minor · 3 major | 2 OK · 50 minor · 2 major |
| Canto 3 (51 blocks) | 18 OK · 31 minor · 2 major | 3 OK · 46 minor · 1 major |

- **"Minor" was almost always embellishment:** stacked adjectives ("sublime", "transcendental", "supreme") and small invented details that are not in the Hindi.
- **"Major" means a wrong meaning or invented content.** Examples:
  - 1.1: "the mind of the Creator" for the poet's own intellect.
  - 1.30: joy at seeing *them*, reversed.
  - 1.41 and 1.44: whole clauses invented.
  - 2.38: the speaker is wrong.
  - 3.53–55: invents "Jñāneśvarī" and "Bandhu" in place of the manuscript's pointer to page 32.
- Canto 3's English was the best of the three. Canto 1's was the most embellished.

## 3. Findings: page numbering and structure
- **Cantos 2 and 3: correct.** Every scan's margin numeral matches its filename, and the verse sequence is continuous. Canto 3's p071 (a single verse) and p073 (vv. 25–27 grouped) match the manuscript.
- **Canto 1: problems.** These need the user's decision; nothing has been changed.
  1. **Images `p013.jpg`–`p027.jpg` each show the next page**, from (१४) to (२८); the verse numbers on the scans confirm this. The transcripts are right; only the images are shifted. **No photo of page १३ exists.**
  2. `p028.jpg` and `p030.jpg` are overflow sheets (the tails of the notes on v57 and v59), not manuscript pages.
  3. **Page ३० (vv. 59–60) was photographed but never transcribed.** The photo is `raw/Sarg_1/p031_20260811_172019_page_30.jpg`, plus the overflow sheet `p032_…_page_30_2.jpg`, which ends "६०".
  4. **`p031.yml` mislabels its verses.** The manuscript numbers them ६१ and ६२; the YAML calls them 59 and "60-62".
  5. **`p030.yml` holds text that is not on the scan.** It claims to be a continuation of the v58 notes, "transcribed from the page-30 scan by antigravity". The image actually shows the end of the **v59** notes: "अहंकार का प्रदर्शन करने वाले … उनके अस्तित्व के प्रति सदा जागरूक करती रहती हो। ५९". The YAML text was apparently invented. It was left untranslated.

## 4. Findings: transcription quality (outside the brief; recorded for later)
- **Canto 1's Sanskrit (Google Lens) is poor.** 13 of 63 blocks cannot be construed and 32 are partly corrupt. Canto 2's Sanskrit (antigravity) is clean: 37 A, 17 B, 1 C. Canto 3: 31 A, 15 B, 4 C, 1 D.
- **Canto 3's p086 colophon Sanskrit is corrupt** (see the canto-4 assessment).
- **Names worth checking.** Canto 2 vv. 1–2 read "शुकण्ड" for मृकण्डु. In canto 3 v36, the Sanskrit has "नारेण" (Nara) but the Hindi has "नारद". Canto 3 v3 (Sanskrit "दाक्षिण्या") and v36 suggest that the canto-2 householder who hosts Mṛkaṇḍu is **Dākṣi**, the same sage who appears in canto 4.

## 5. Recommended next steps
1. Fix canto 1:
   - (a) rename the images so pNNN shows page NNN, and reshoot page १३;
   - (b) transcribe page ३० (vv. 59–60) and the two overflow sheets;
   - (c) renumber p031 as vv. 61 and 62, separately;
   - (d) replace the fabricated `p030.yml` text.
2. Re-read the corrupt canto-1 Sanskrit from the scans, as was done for canto 4. Line-level crops work.
