# GEMINI.md

This file provides guidance to Antigravity (and Gemini-powered coding agents) when working with code and data in this repository.

---

## 1. Project Overview

This is a digitization and archival project for a handwritten Sanskrit *mahākāvya* (epic poem) composed by the user's (Abhinav Anand's) grandfather. 

* **Source Material**: 32 photographed notebook pages (`Images/raw/`). Each page generally contains shlok (verse) + translation + commentary/notes. The shlokas and translations were penned by an amanuensis; notes are in the grandfather's own hand.
* **Format Flexibility**: While most pages contain numbered shlokas with translation and notes, some contain continuous commentary or differing verse counts. The data schema tolerates variable structure rather than enforcing a rigid template.
* **Goal**: Transcribe the manuscript preserving structure and annotations, and generate a self-contained static site deployed via GitHub Pages (`/docs`).

---

## 2. Repository Layout

```
Images/
  raw/            Untouched original photos (landscape pixels / EXIF tagged), pNNN_<timestamp>.jpg
  pages/          Upright, pre-rotated copies (pNNN.jpg) used by site generator & visual inspection
transcripts/
  Sarg_N/         pages/canto N: pNNN.yml, Devanagari transcription markdown files
  Sarg_N_English_translation/   English translation markdown files per page
scripts/
  build_site.R    Site generator: compiles transcripts/**/*.yml + Images/pages/ into docs/
  serve_docs.js   Minimal Node server for local preview (http://localhost:8731/)
docs/             Generated static site — published via GitHub Pages.
                  NEVER edit docs/ manually; all changes will be overwritten by build_site.R.
```

---

## 3. Image Orientation & Page Numbering

* **Upright Scans (`Images/pages/`)**: Always inspect and reference `Images/pages/*.jpg` rather than `Images/raw/`. Raw photos have landscape pixel buffers requiring EXIF interpretation, whereas `pages/` are physically rotated 90° upright.
* **Devanagari Page Numerals**:
  * Located in the **bottom-left margin** of each page in parentheses, e.g. `(१)`, `(६)`, `(७)`, `(८)`.
  * Sequential order: The photos represent consecutive manuscript pages in timestamp order.
  * *Tip*: Cursive Devanagari digits (like `५`, `६`, `१`) can look similar; crop/zoom into the bottom-left corner when verifying page numbering.

---

## 4. Transcription Protocol & Schema

### Transcription Workflow
* Direct vision OCR on this specific cursive handwriting is error-prone. The user generates high-accuracy transcriptions via Google Lens (exported as Markdown or Word docs in `transcripts/`) or high-fidelity Antigravity transcription passes.
* The agent's role is to **structure, parse, and validate** the text into the canonical `transcripts/Sarg_N/pNNN.yml` schema, generate bilingual English translations, and cross-reference structural correspondence (canto headings, verse counts, margin markers) against `Images/pages/pNNN.jpg`.

### Schema Reference (`transcripts/Sarg_N/pNNN.yml`)

```yaml
title: "श्री मार्कण्डेय चरितम्"        # optional, include when present/changed
sarga: "अथ प्रथमः सर्गः प्रारभ्यते"     # optional canto heading
page_number_devanagari: "१"
page_number_arabic: 1
image: "images/pages/p001.jpg"        # relative path used during site generation
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
    translation_en:                    # English translation of amanuensis Hindi
      author: ai_translation
      text: |
        ...
    notes_en:                          # English translation of grandfather's notes
      author: ai_translation
      text: |
        ...
placeholder: false                    # true ONLY for dummy/stub test data
notes_uncertain: false                # true if any section contains [unclear: ...] markers
```

---

## 5. Build, Preview, and Verification

### Commands
* **Build Site**:
  ```powershell
  Rscript scripts/build_site.R
  ```
* **Local Preview Server**:
  ```powershell
  node scripts/serve_docs.js
  ```
  Accessible at: `http://localhost:8731/`

### Dependencies
* **R Packages**: `yaml`, `glue` (installed in the user's R library).
* **Fonts**: Noto Sans Devanagari is self-hosted under `docs/assets/fonts/` for offline and standalone fidelity.

---

## 6. Antigravity Agent Guidelines

* **Do not edit `docs/` files directly**: Always edit the source YAML files in `transcripts/` or the template generator `scripts/build_site.R`, then run `Rscript scripts/build_site.R`.
* **Recommended Workflows**:
  * Use `/plan` when introducing modifications to the generator or YAML schema.
  * Use `/learn` when recording verified handwriting idiosyncrasies, recurring transcription corrections, or manuscript anomalies.

---

## 7. Multi-Agent Batching Architecture (Sarga 4 Onwards)

> **Core Policy (User Mandate)**:  
> From Sarga 4 onwards, transcribing and translating must be batch-processed using concurrent subagents deployed autonomously based on the agent's judgment, without requiring manual prompts or reminders from the user.

### 1. Motivation & Token Efficiency
* Processing an entire sarga (25–35 pages) within a single main-thread conversation creates quadratic vision context accumulation ($O(N^2)$), consuming 80–90% of weekly quota in a single run.
* Partitioning the workload across independent subagents with fresh context windows eliminates image re-ingestion accumulation, reducing token consumption by **55%–65%**.

### 2. Operational Protocol
1. **Batching**:
   * Inspect page counts in `Images/raw/Sarg_N` (or `Images/pages/`).
   * Spawn 3 to 5 concurrent subagents (using `invoke_subagent`), each assigned a balanced slice of pages (e.g. 5–7 pages per subagent).
2. **Subagent Execution Scope**:
   * Each subagent inspects only its allocated page images, produces the Devanagari transcription files in `transcripts/Sarg_N/`, and creates the corresponding English translations in `transcripts/Sarg_N_English_translation/`.
   * Subagents write files directly and report back concise confirmation summaries.
3. **Orchestrator Role (Main Agent)**:
   * Waits reactively for all subagents to finish.
   * Performs the unified audit: verifies sequential verse numbering across batch boundaries, meter consistency, phalaśruti/colophon integrity, and overall fidelity.
   * Compiles the canonical YAML files (`transcripts/Sarg_N/pNNN.yml`) and triggers the site build (`Rscript scripts/build_site.R`).
