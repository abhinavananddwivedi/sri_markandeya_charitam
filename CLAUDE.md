# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A digitization project for a handwritten Sanskrit *mahākāvya* (epic poem) composed by the user's (Abhinav Anand's) grandfather. The source is 32 photographs of a handwritten notebook (`Images/raw/`), each generally containing shlok (verse) + translation + notes for the top and bottom halves of a physical page. The shlok and its translation were penned by an amanuensis; the notes are in the grandfather's own hand. Not every page cleanly splits into two such halves — some are continuous commentary — so the data format tolerates variable structure per page rather than assuming a rigid template.

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
scripts/
  build_site.R    regenerates docs/ from transcripts/**/*.yml + Images/pages/. Run: Rscript scripts/build_site.R
  serve_docs.js   minimal Node static file server for local preview: node scripts/serve_docs.js, then open http://localhost:8731/
  transcript_md_parser.R          shared parser for the antigravity markdown export format (both the
                                   English-heading and Devanagari-heading dialects). Not part of the regular
                                   build; used only by the one-off migration scripts below.
  merge_sarga1_translations.R     one-off: merged translation_en/notes_en into the 32 existing Sarg_1 yml
                                   files from Sarg_1_English_translation/. Already run; kept for reference/
                                   re-audit, not meant to be re-run against unchanged files.
  build_sarga2_transcripts.R      one-off: generated all 28 Sarg_2 yml files from scratch from Sarg_2/ +
                                   Sarg_2_English_translation/. Already run; kept for reference/re-audit.
docs/       generated static site — GitHub Pages should be configured to serve from here (Settings -> Pages -> Deploy from branch -> /docs). NEVER hand-edit files in here; they are overwritten by build_site.R.
```

## Image orientation

The raw camera photos (`Images/raw/`) are stored sideways (landscape pixels with an EXIF rotation tag) — viewers that respect EXIF display them upright, but tools that read raw pixel data (including the rotation script and Claude's own image reading) see them sideways. `Images/pages/*.jpg` are pre-rotated 90° so they're upright with no EXIF dependency. Always work from `Images/pages/`, not `Images/raw/`, for anything that needs to read the image content correctly oriented.

## Page numbering

Each page has a Devanagari numeral in the **bottom-left margin** (not top-right, despite that being the initial assumption) — e.g. `(६)`, `(७)`, `(८)`. These numerals climb by roughly 1 per photo, confirming that **capture order (filename timestamp order) equals manuscript page order** — the 32 photos are consecutive pages, not a scattered selection. Cursive digits are easy to misread at low zoom (`५`/`६`/`१` look similar) — if reading a numeral for the first time, crop and upscale the bottom-left margin region before trusting the digit.

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

`verses` length and presence of `notes`/`translation` per verse is flexible — don't force structure a page doesn't have. A grouped/colophon verse uses a quoted range string for `number` (e.g. `"64-66"`); such verses may carry only `translation`/`translation_en` with no `notes`/`notes_en` when the source itself has no separate commentary for that span (see p032.yml, p060.yml).

`translation_en`/`notes_en` (added 2026-09, via `scripts/merge_sarga1_translations.R` and `scripts/build_sarga2_transcripts.R`) are English translations produced by the antigravity tool, one field per corresponding Hindi block, `author: ai_translation`. They are translations of the Hindi (not independently re-derived from the Sanskrit), and are present only where the corresponding Hindi field (`translation`/`notes`) exists on that verse.

## Transcription approach

Traditional OCR and Claude's own vision-based reading were both tested and found unreliable for this specific handwriting (personal cursive Devanagari) — Claude could only confidently read isolated words/markers, not connected prose, across sample pages spanning the beginning, middle, and end of the set. **Google Lens (used by the user directly), by contrast, transcribed the handwriting effortlessly** and is the working approach: the user runs pages through Lens and supplies the resulting text (e.g. as a `.md` file dropped in `transcripts/`); Claude's job is structuring that real text into the YAML schema above and building the site around it — not independently reading the handwriting. When given a new Lens transcription, cross-check its structure (canto heading, verse count, page number) against the corresponding `Images/pages/pNNN.jpg` scan before committing it to the schema, since Claude can still verify structural/gross correspondence even without being able to independently transcribe.

As of 2026-09, a tool called antigravity has also been used (by the user) both to re-transcribe handwriting directly (used as canto 2's primary Devanagari source, since canto 2 had no prior Lens pass) and to produce English translations of the Hindi `translation`/`notes` text for both cantos (`translation_en`/`notes_en`, see schema above). The same caution applies: cross-check antigravity output's structure against the trusted yml/scans before merging, and where a page's content can't be corroborated against any independently-produced source, resolve it with the user explicitly rather than merging it silently (e.g. p030.yml's verse 58 notes).

## Build & preview

```
Rscript scripts/build_site.R     # regenerate docs/ from transcripts/
node scripts/serve_docs.js       # serve docs/ at http://localhost:8731/ for local preview
```

R packages required: `yaml`, `glue` (installed to the user library at `%LOCALAPPDATA%/R/win-library/<version>` since the system R library isn't user-writable).

The site self-hosts Noto Sans Devanagari (`docs/assets/fonts/`) rather than depending on Google Fonts at runtime, so it renders correctly offline and once deployed.
