# GEMINI.md

This file provides guidance to Antigravity (and Gemini-powered coding agents) when working with code and data in this repository.

---

## 0. Master Instructions

1. No need to be too agreeable. Be polite but state your point directly, especially if you disagree with my thinking.
2. Always think from the first principles. As much as possible.
3. Please prioritize precision and objectivity over other attributes.
4. Please be simple, direct and clear in communication as much as possible.
5. When coding, please do so in R. That's my preferred language. Please use the base R and the tidyverse paradigm as much as possible for programming.
6. When using markup languages, please note my preference for LaTeX (.tex), followed by Markdown (.md). I prefer the typeface 'Computer Modern' which is loaded by default in .tex.
7. When making slides, I prefer Beamer. I also prefer the themes 'Malmoe' and 'seahorse'. 
   7.1 I prefer the usage of `\begin{block}{BLOCKNAME}...\end{block}` environments. 
   7.2 I do not prefer usage of `\section{}` in Beamer. 
   7.3 I also prefer using bulleted environments: `\begin{itemize}...\end{itemize}`
8. When asked to produce text, please follow the advice by John Cochrane at the following link: https://www.johnhcochrane.com/research-all/writing-tips-for-phd-studentsnbsp and/or the link here: https://static1.squarespace.com/static/5e6033a4ea02d801f37e15bb/t/5eda74919c44fa5f87452697/1591374993570/phd_paper_writing.pdf
9. When asked to produce plots, please use the visual paradigm advocated by Edward Tufte
10. In plots, I prefer black and white. When there are several plotlines try to distinguish them by using different types of lines like solid, dashed, dotdashed etc. The target is to create plots which are simple and friendly to those who are color blind
11. When writing text in .tex files, .md files or presentation files etc., avoid gemini-speak (e.g., 'load bearing', other stock phrases you love using) and use an academic, neutral, descriptive tone

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

## 7. Multi-Agent Batching Architecture & Token-Conservation Protocols (Sarga 4 Onwards)

> **Core Policy (User Mandate)**:  
> From Sarga 4 onwards, transcribing and translating must be batch-processed using concurrent subagents deployed autonomously based on the agent's judgment, without requiring manual prompts or reminders from the user. Strict token-conservation protocols must be observed to prevent rate-limit exhaustion.

### 1. Mathematical Rationale: Eliminating $O(N^2)$ Context Inflation
In a single conversational thread, token costs grow quadratically across turns:
$$\text{Tokens per turn } k = T_{\text{system}} + \sum_{i=1}^k (T_{\text{prompt}, i} + T_{\text{tool\_outputs}, i} + T_{\text{response}, i})$$
Accumulating 30+ high-resolution manuscript scans, terminal logs, and drafts in one context window consumes 80–90% of weekly quota in minutes. Context partitioning and deterministic offloading eliminate this accumulation.

### 2. Mandatory Token-Conservation Protocols
1. **Explicit Model Tier Selection (`flash`)**:
   * When invoking subagents via `invoke_subagent`, always explicitly set `"Model": "flash"` (never default to `"inherit"` or `"pro"`).
   * Flash provides sufficient multimodal vision and language comprehension for transcription/translation while consuming a fraction of the quota.
2. **Zero-LLM-Token Deterministic Scripting**:
   * Reserve LLM tokens strictly for human-level interpretation: deciphering handwriting, translating Sanskrit $\to$ English, and poetic/grammatical commentary.
   * All mechanical operations must be executed via local PowerShell or R scripts:
     - Image rotation: PowerShell `.NET System.Drawing` script.
     - YAML compilation: R parser script (e.g. `scripts/build_sarga_transcripts.R`) extracting Markdown blocks via regex into canonical YAML schema.
     - Validation: Local R schema assertions (0 LLM tokens).
3. **Silent Subagent Reporting (No Text Echoing)**:
   * Subagents must write their output files (`transcripts/Sarg_N/page_NNN.md` and `transcripts/Sarg_N_English_translation/page_NNN.md`) directly to disk.
   * Subagents must **never** return or echo full transcribed or translated text back to the orchestrator.
   * Return message must be a single status line: `"Batch complete: Pages X to Y written to disk."`
4. **Session Hygiene (`/clear`)**:
   * Treat each Sarga as a discrete session.
   * Once a Sarga's YAML files are compiled, validated, and staged in git, recommend or execute `/clear` before starting the next Sarga to reset the input context window to baseline.

### 3. Operational Protocol for Sarga Execution
1. **Preparation**:
   * Inspect raw images for the canto. Run local rotation script to generate upright copies in `Images/pages/`.
2. **Subagent Deployment**:
   * Partition the pages into slices of 5–7 pages.
   * Launch concurrent subagents with `"Model": "flash"` and silent reporting instructions.
3. **Audit & Canonical Compilation**:
   * Main orchestrator checks disk existence and runs the deterministic R compiler script to generate canonical YAMLs.
   * Run local R validation script for verse continuity, meter designations, and missing fields.
4. **Completion & Reset**:
   * Verify git status.
   * Ready for `/clear` before the next canto.
