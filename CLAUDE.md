# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A digitization project for a handwritten Sanskrit *mahākāvya* (epic poem) composed by the user's (Abhinav Anand's) grandfather. The source is photographs of a handwritten notebook (`Images/raw/`, subfoldered by canto), each generally containing shlok (verse) + translation + notes for the top and bottom halves of a physical page. As of 2026-09 three cantos are transcribed: **86 manuscript pages** (Sarga 1 = pp. 1–32, Sarga 2 = pp. 33–60, Sarga 3 = pp. 61–86). The shlok and its translation were penned by an amanuensis; the notes are in the grandfather's own hand. Not every page cleanly splits into two such halves — some are continuous commentary — so the data format tolerates variable structure per page rather than assuming a rigid template.

The end goal: transcribe the manuscript into text preserving this structure, and publish it as a static website hosted via GitHub Pages on the user's account. The user pushes to GitHub themselves; this repo is prepared locally and left un-pushed.

## Repository layout

```
Images/
  raw/      untouched original photos, named pNNN_<original-timestamp-filename>.jpg in manuscript page order
  pages/    upright, rotated copies used by the site, named pNNN.jpg
transcripts/
  Sarg_1/                      pages 1-32 (canto 1). p001.yml..p032.yml -- the load-bearing structured
                                transcripts, see schema below. Also holds a later antigravity Devanagari
                                re-transcription (sri_markandeya_caritam_page_N.md, cross-check only, never
                                a data source -- it carries stray "[cite: N]" export artifacts), a
                                superseded/ subfolder of deprecated drafts, and unrelated Gemini export
                                clutter (.docx, .Rhistory).
  Sarg_1_English_translation/  sri_markandeya_caritam_page_1.md..page_32.md -- antigravity-produced English
                                translations (2026-08-25) of every verse/notes pair in canto 1, per page.
                                Source for the translation_en/notes_en fields merged into Sarg_1/p0NN.yml.
  Sarg_2/                      pages 33-60 (canto 2). p033.yml..p060.yml -- load-bearing structured
                                transcripts (same schema as Sarg_1), built from this directory's own
                                antigravity Devanagari transcription (sri_markandeya_caritam_page_33.md..
                                page_60.md), which for canto 2 IS the primary source (canto 2 had no prior
                                Google Lens transcript).
  Sarg_2_English_translation/  sri_markandeya_caritam_page_33.md..page_60.md -- English translations for
                                canto 2, same role as Sarg_1_English_translation/.
  Sarg_3/                      pages 61-86 (canto 3). p061.yml..p086.yml -- load-bearing structured
                                transcripts (same schema as Sarg_1/Sarg_2), built by
                                scripts/build_sarga3_transcripts.R from this directory's own antigravity
                                Devanagari transcription (sri_markandeya_caritam_page_61.md..page_86.md),
                                which IS canto 3's primary source. That markdown comes in TWO dialects --
                                pages 61-75 are structurally identical to canto 2; pages 76-86 use a newer
                                "dialect B" (see Transcription approach). p071 is a single-verse page
                                (verse 21, plus a struck-out marginal draft relocated to p073 as vv.25-27);
                                p073 groups vv.25-27, p086 groups vv.53-55 (colophon).
  Sarg_3_English_translation/  sri_markandeya_caritam_page_61.md..page_86.md -- English translations for
                                canto 3, same role as the other *_English_translation/ dirs. Also holds
                                translation_review.md (a one-off quality assessment of the canto-3
                                translations; not consumed by any build).
scripts/
  build_site.R    regenerates docs/ from transcripts/**/*.yml + Images/pages/. Run: Rscript scripts/build_site.R
  serve_docs.js   minimal Node static file server for local preview: node scripts/serve_docs.js, then open http://localhost:8731/
  transcript_md_parser.R          shared parser for the antigravity markdown export format. Handles both
                                   the English-heading and Devanagari-heading "## " dialects (Sarga 1-2,
                                   Sarga 3 pp.61-75) AND the newer "dialect B" (Sarga 3 pp.76-86: "### "
                                   verse headings, "#### " subsections, fenced ```sanskrit shlok, plain-text
                                   bodies, per-shlok variant/metre note). Auto-detects by "does any line
                                   start with '## '". Not part of the regular build; used only by the
                                   one-off migration scripts below.
  merge_sarga1_translations.R     one-off: merged translation_en/notes_en into the 32 existing Sarg_1 yml
                                   files from Sarg_1_English_translation/. Already run; kept for reference/
                                   re-audit, not meant to be re-run against unchanged files.
  build_sarga2_transcripts.R      one-off: generated all 28 Sarg_2 yml files from scratch from Sarg_2/ +
                                   Sarg_2_English_translation/. Already run; kept for reference/re-audit.
  build_sarga3_transcripts.R      one-off: generated all 26 Sarg_3 yml files (pp.61-86) from Sarg_3/ +
                                   Sarg_3_English_translation/. Handles both markdown dialects, the p071
                                   struck-out-draft note (folded into source:), the p073/p086 grouped
                                   verses, and the p086 colophon (vv.53-55 carry only translation /
                                   translation_en, deferring the gloss to canto-1 p032, per p032/p060).
                                   Already run; kept for reference/re-audit. Dry run: Rscript
                                   build_sarga3_transcripts.R ; write: add --write.
docs/       generated static site — GitHub Pages should be configured to serve from here (Settings -> Pages -> Deploy from branch -> /docs). NEVER hand-edit files in here; they are overwritten by build_site.R. The index groups pages into per-canto <section class="sarga-group"> blocks with an <h2> heading ("Sarga N (pages a-b)") plus the Devanagari canto heading as a subtitle; grouping is keyed off the Sarg_N/ folder each transcript lives in (build_site.R errs out if a transcript is not under one). Individual page files are unchanged by the grouping -- a page shows its Devanagari canto heading only if its own yml carries `sarga:` (i.e. the first page of each canto).
```

## Image orientation

The raw camera photos (`Images/raw/`) are stored sideways (landscape pixels with an EXIF rotation tag) — viewers that respect EXIF display them upright, but tools that read raw pixel data (including the rotation script and Claude's own image reading) see them sideways. `Images/pages/*.jpg` are pre-rotated 90° so they're upright with no EXIF dependency. Always work from `Images/pages/`, not `Images/raw/`, for anything that needs to read the image content correctly oriented.

## Page numbering

Each page has a Devanagari numeral in the **bottom-left margin** (not top-right, despite that being the initial assumption) — e.g. `(६)`, `(७)`, `(८)`. These numerals climb by roughly 1 per photo, confirming that **capture order (filename timestamp order) equals manuscript page order** — the photos are consecutive pages, not a scattered selection. Cursive digits are easy to misread at low zoom (`५`/`६`/`१` look similar) — if reading a numeral for the first time, crop and upscale the bottom-left margin region before trusting the digit.

## Transcript schema (`transcripts/Sarg_N/pNNN.yml`)

Real content is organized as a **sequence of numbered shlokas** per page (not a spatial top-half/bottom-half split — that was an early incorrect assumption, since discarded):

```yaml
title: "श्री मार्कण्डेय चरितम्"        # optional, only needed where it appears/changes
sarga: "अथ प्रथमः सर्गः प्रारभ्यते"     # optional canto heading, only where present
page_number_devanagari: "१"
page_number_arabic: 1
image: "images/pages/p001.jpg"        # relative path used by build_site.R when copying into docs/images/
verses:
  - number: 1
    shlok: |
      ...four lines of verse...
    manuscript_note:           # optional: paleographic / variant-reading / metre note. Canto 3
      author: ai_transcription #   pages 76-86 only (the "dialect B" source carries one per shlok).
      text: |
        ...e.g. amanuensis's actual reading vs. the reconstruction; वृत्त: रथोद्धता...
    manuscript_note_en:        # optional: English of the above
      author: ai_transcription
      text: |
        ...
    translation:
      author: amanuensis
      text: |
        ...
    notes:
      author: grandfather
      text: |
        ...
    translation_en:            # optional: AI-generated English translation of `translation`
      author: ai_translation
      text: |
        ...
    notes_en:                  # optional: AI-generated English translation of `notes`
      author: ai_translation
      text: |
        ...
placeholder: true   # set true only for sample/test data — never on real transcriptions
notes_uncertain: true   # set true when any block contains [unclear: ...] markers
```

`verses` length and presence of `notes`/`translation` per verse is flexible — don't force structure a page doesn't have. A grouped/colophon verse uses a quoted range string for `number` (e.g. `"64-66"`, `"25-27"`, `"53-55"`); such verses may carry only `translation`/`translation_en` with no `notes`/`notes_en` when the source itself has no separate commentary for that span (see p032.yml, p060.yml, p086.yml). p086.yml's `"53-55"` verse mirrors p032/p060: its `translation` is the manuscript's own pointer ("अर्थ … पृष्ठ ३२ में अवलोकन करें") plus the Hindi canto-close, its `translation_en` the English-export summary, and the Sanskrit colophon rubric is appended to its `shlok` (p032 precedent).

`manuscript_note`/`manuscript_note_en` (`author: ai_transcription`) appear only on canto-3 pages 76-86, one per shlok, holding the paleographic/variant-reading/metre apparatus that the "dialect B" source attaches to each verse. `build_site.R` renders them as a small-print block (`.block-manuscript-note`) directly under the shlok.

`translation_en`/`notes_en` (added 2026-09, via `scripts/merge_sarga1_translations.R` and `scripts/build_sarga2_transcripts.R`) are English translations produced by the antigravity tool, one field per corresponding Hindi block, `author: ai_translation`. They are translations of the Hindi (not independently re-derived from the Sanskrit), and are present only where the corresponding Hindi field (`translation`/`notes`) exists on that verse.

## Transcription approach

Traditional OCR and Claude's own vision-based reading were both tested and found unreliable for this specific handwriting (personal cursive Devanagari) — Claude could only confidently read isolated words/markers, not connected prose, across sample pages spanning the beginning, middle, and end of the set. **Google Lens (used by the user directly), by contrast, transcribed the handwriting effortlessly** and is the working approach: the user runs pages through Lens and supplies the resulting text (e.g. as a `.md` file dropped in `transcripts/`); Claude's job is structuring that real text into the YAML schema above and building the site around it — not independently reading the handwriting. When given a new Lens transcription, cross-check its structure (canto heading, verse count, page number) against the corresponding `Images/pages/pNNN.jpg` scan before committing it to the schema, since Claude can still verify structural/gross correspondence even without being able to independently transcribe.

As of 2026-09, a tool called antigravity has also been used (by the user) both to re-transcribe handwriting directly (used as the primary Devanagari source for cantos 2 and 3, since neither had a prior Lens pass) and to produce English translations of the Hindi `translation`/`notes` text (`translation_en`/`notes_en`, see schema above). The same caution applies: cross-check antigravity output's structure against the trusted yml/scans before merging, and where a page's content can't be corroborated against any independently-produced source, resolve it with the user explicitly rather than merging it silently (e.g. p030.yml's verse 58 notes).

The antigravity export format drifted mid-canto-3. Pages 61-75 use the same markdown as canto 2 ("dialect A": `## श्लोक N` / `## Verse N` headings, `### ` subsections, `>` blockquote bodies). Pages 76-86 use "dialect B": `#`-level title with `**पृष्ठ N (Page N)**` (no `पृष्ठ संख्या:`), `### श्लोक N` / `### Verse N` verse headings, `#### ` subsections, the shlok as a fenced ```` ```sanskrit ```` block instead of a blockquote, plain-text (non-blockquote) Hindi/English bodies, and an explicit `*(… लिपि-टिप्पणी … वृत्त …)*` / `*(Paleographic … Meter …)*` note after each shlok. The dialect-A files also carry a UTF-8 BOM; dialect-B files do not. `scripts/transcript_md_parser.R` auto-detects (A = "some line starts with `## `") and normalises both onto the same canonical section keys; `scripts/build_sarga3_transcripts.R` consumes that. Any further antigravity import should re-verify which dialect it is and that the parser still handles it (dry-run `build_sarga3_transcripts.R` and, as a regression gate, re-run `build_sarga2_transcripts.R --write` and confirm `git diff transcripts/Sarg_2` is empty).

## Build & preview

```
Rscript scripts/build_site.R     # regenerate docs/ from transcripts/
node scripts/serve_docs.js       # serve docs/ at http://localhost:8731/ for local preview
```

R packages required: `yaml`, `glue` (installed to the user library at `%LOCALAPPDATA%/R/win-library/<version>` since the system R library isn't user-writable).

The site self-hosts Noto Sans Devanagari (`docs/assets/fonts/`) rather than depending on Google Fonts at runtime, so it renders correctly offline and once deployed.
