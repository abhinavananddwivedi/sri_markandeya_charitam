# Project log: Śrī Mārkaṇḍeya Caritam digitization

A running record of decisions, changes, open issues and working methods. It is written so that
the user, Claude, or any other agent (e.g. antigravity/Gemini) can pick the project up cold.
Newest entries go at the top of the Log section. CLAUDE.md describes the repo; this file
describes what happened and what is still open.

## Current state (keep this section up to date)

| Canto | Pages | Transcription source | English | Status |
|---|---|---|---|---|
| 1 | 1–32 | Google Lens (user) + antigravity; all text re-read line by line by Claude 2026-10-24/25 (p.13 has no scan) | Rewritten by Claude 2026-10-24 (faithful to Hindi) + `shlok_en` | live (older version); fixes below uncommitted |
| 2 | 33–60 | antigravity | Rewritten by Claude 2026-10-24 + `shlok_en` | live (older version); fixes uncommitted |
| 3 | 61–86 | antigravity | Rewritten by Claude 2026-10-24 + `shlok_en` | live (older version); fixes uncommitted |
| 4 | 87–118 | Gemini 3.1 Pro re-run, then re-read line by line by Claude 2026-10-24 | Claude 2026-10-24 + `shlok_en` | uncommitted |

Live site: https://abhinavananddwivedi.github.io/sri_markandeya_charitam/ (served from `docs/`).
The user commits and pushes; agents do not push.

## Open issues
- **Canto 1, page १३:** no photograph exists. The user needs to reshoot it (see the 2026-10-24 entry).
- **Canto 1:** fully re-read except p.13 (no photo). About 30 `[unclear]` spots and 6 non-scanning pādas remain (listed in the 2026-10-25 entry).
- **Canto 4:** about 20 `[unclear]` spots remain. A human reader of the family hand could settle them.
- **All cantos:** the English is AI-translated (`author: ai_translation`) and has not been reviewed by a human.

## Working methods (what works, what doesn't)
- **Reading the handwriting.** Claude can read it reliably only from **upright, line-level crops** at about 2000 px width. Whole-page views are too small.
  - Many stored images were rotated at the pixel level; check orientation first.
  - Crop scripts (PowerShell System.Drawing) are kept in `scripts/tools/`.
- **Metre check.** Use a laghu/guru scan that can fail, not a syllable count (`scripts/tools/scan_metre.R`).
  - Canto 3 is Rathoddhatā.
  - Canto 4 is Svāgatā.
  - Canto 1 is mostly Vaṃśastha (12 syllables, ।ऽ।ऽऽ।।ऽ।ऽ।ऽ).
  - Canto 2 is mostly Vaṃśastha.
  - Colophons: Vasantatilakā + Svāgatā.
- **Do not trust AI self-reports.** Gemini's `plan_reexecution.md` claimed fixes that were not in the text, and an antigravity "transcription" (old `p030.yml`) was not on the page at all. Always verify against the scan.
- **Keep the two English layers separate.** `translation_en` translates the amanuensis Hindi; `shlok_en` translates the Sanskrit; `notes_en` translates the grandfather's notes. Mark `[unclear]`; never smooth over garbled text.
- **Snapshots.** Before overwriting anything, snapshot it into a `superseded/` folder. Rename snapshot `.yml` files to `.yaml`, because `build_site.R` globs `*.yml` recursively.

## Log

### 2026-10-25 (later): Claude, canto-2 targeted Sanskrit re-read (done)
- Same method as canto 3. Snapshots: `transcripts/Sarg_2/superseded/pre_reread_2026-10-25/`.
- **Part 1 (pp. 34–45) done:** `transcripts/audit_cantos_1-3/c2_reread_01.yaml` (15 patches) applied.
- **Part 2 (pp. 47–59) done:** `c2_reread_02.yaml` (12 patches). Vaṃśastha lines now scan 200/216 (was 181). Remaining failures are flagged in `manuscript_note` (vv. 3, 4, 20, 25, 29, 36, 38, 40, 45) or are licence lines. v54 is Śālinī. The vv. 55–57 colophon was not re-read.

### 2026-10-25 (later): Claude, canto-3 targeted Sanskrit re-read
- **Triage first.** Metre-scanned the existing Sanskrit. Pass rates: canto 1 before its re-read 50%, canto 2 85%, canto 3 75%.
- **Re-read.** Read every verse in canto 3 that had a failing line from upright crops (31 verses), plus all of p.86: `transcripts/audit_cantos_1-3/c3_reread_01.yaml`. Snapshots are in `transcripts/Sarg_3/superseded/pre_reread_2026-10-25/`.
- **Result.** Rathoddhatā lines now scan 183/215, up from 160. The remaining failures are:
  - the "pr/kr" licence lines (left as written);
  - the colophon;
  - about 10 faint pādas flagged "re-read needed" (vv.11, 23, 36, 37, 38, 46, 48, 50, 52).
- **Content fixes:**
  - the v3 instructor is "दाक्षि" (Dakṣa's son);
  - v1 reads "पर्यगात्";
  - v29's verb is "समार्चयत्".
- **p.86.** The colophon triad was garbled and is now aligned with pp.32/118. The added "इति … समाप्तः" rubric is not on the page and was removed. v52 could not be resolved; the old text is kept and flagged.
- **Scope.** Hindi and notes were not re-read; nor were verses that already scan. Their `translation_en`/`notes_en` are unchanged.


### 2026-10-25: Claude (Opus 5.5), canto-1 re-read finished
- Resumed the canto-1 re-read where the previous session stopped. That session had actually reached p.14 (patches 01–06), not p.9 as logged.
- Re-read pp. 15–29, 31 and 32 from upright band crops: `transcripts/audit_cantos_1-3/c1_reread_07.yaml` (35 patches). p.30 had already been read fresh during the structure fix. Every page of canto 1 that has a scan is now re-read; p.13 is still unread because no photo exists.
- Almost every Sanskrit verse in this range had been garbled by Lens. 30 of the 36 verses now scan in full in their metre, with the corrections recorded in each verse's `manuscript_note`. Vaṃśastha runs to v.56; vv.57–58 and 61 are Sragdharā, v.62 Śārdūlavikrīḍita, v.63 Mālinī, and the colophon is Vasantatilakā + Svāgatā.
- Content findings:
  - v.48: the place is हरद्वार (Haridvāra), not "हरहार".
  - v.32: Urvaśī comes from Nārāyaṇa's split thigh (विनिर्भिद्य).
  - vv.61–62: the verse numerals inside the shlok text were wrong (५९, ६०) and are now corrected.
  - p.32: the Sanskrit "इति … प्रथमः सर्गः समाप्तः" rubric is not on the page. It had been added by the earlier structuring step and has been removed, matching p.118.
- Verses that still do not fully scan (kept as written, flagged in `manuscript_note`): v.32 pāda 2 (one syllable short), v.38 pāda 1, v.56 pāda 1, v.57 pāda 4, v.62 pāda 4, and v.66 pāda 3 (interlinear correction unreadable).
- `notes_uncertain: true` added to the 14 canto-1 pages that contain `[unclear]` markers (`c1_reread_08_flags.yaml`). Site rebuilt.

### 2026-10-24 (later): Claude, canto-1 structural fix and re-read (completed 2026-10-25, see above)
- **Images.** `scripts/tools/fix_canto1_images_2026-10-24.ps1` realigned `Images/pages/p001–p032.jpg`: each is now upright, has no EXIF tag, and shows its own page. Originals are in `Images/pages_superseded_2026-10-24/`.
  - There is **no p013.jpg**: page १३ was never photographed.
  - New overflow sheets: `p029_overflow.jpg` (v57 notes tail), `p030_overflow.jpg` (v59 notes tail), `p031_overflow.jpg` (v62 notes tail).
  - `build_site.R` now renders an optional `extra_images:` list under the main scan.
- **YAML.** `scripts/tools/fix_canto1_yaml_2026-10-24.R`:
  - moved the v57 notes tail from p028 to p029;
  - relabelled p031 as vv. 61 and 62;
  - joined the notes tails.
  - `p030.yml` was rewritten from scratch: page ३०, vv. 59–60 (Sragdharā), read by Claude. The old p030 was a fabrication.
  - Snapshots are in `transcripts/Sarg_1/superseded/canto1_fix_2026-10-24/` and `superseded/pre_reread_2026-10-24/`.
- **Full re-read of canto 1** (Sanskrit, Hindi and notes) from the scans, via patch files `transcripts/audit_cantos_1-3/c1_reread_NN.yaml`, applied with `scripts/tools/apply_page_patches.R`.
  - Done in this session: pp. 1–14 (patches 01–06). Finished 2026-10-25.
  - Finding: the old v7 text was the Ṛgvedic aghamarṣaṇa hymn, inserted by the Lens/Gemini pipeline. The manuscript has the poet's own Vaṃśastha verse.

### 2026-10-24: Claude (Opus 5.5)
- **Canto 4.**
  - Audited the Gemini re-run (`transcripts/Sarg_4_assessment_2.md`).
  - Then re-read all 32 pages from the scans and rewrote `p087.yml`–`p118.yml`. Gemini's version is in `transcripts/Sarg_4/superseded/gemini_rerun_2026-10-24/`.
  - `scripts/build_sarga4_transcripts.R` is retired: the YAML is now the source of truth.
  - Correction: canto 4's metre is Svāgatā, not Rathoddhatā as I had said in the first assessment.
- **New field `shlok_en`** (a direct translation of the Sanskrit), added to every verse in all cantos. `build_site.R` renders it as "English Translation (of the Sanskrit)", and `translation_en` is now labelled "(of the Hindi)". This was the user's decision.
- **Cantos 1–3 English audit.**
  - Every `translation_en` and `notes_en` was checked against the Hindi, and the unfaithful ones (most of them) were rewritten.
  - Report: `transcripts/audit_cantos_1-3_report.md`. Per-verse grades and corrections: `transcripts/audit_cantos_1-3/`.
- **Page-numbering check of all cantos.**
  - Cantos 2–4 are fine.
  - Canto 1 had: images p013–p027 shifted by one page; no photo of page १३; page ३० never transcribed; p031's verses (६१, ६२) mislabelled 59 and "60-62"; and a fabricated `p030.yml`.
  - The user approved fixing all of these; the details are in the next entry once done.
