# Project log: Śrī Mārkaṇḍeya Caritam digitization

A running record of decisions, changes, open issues and working methods. It is written so that
the user, Claude, or any other agent (e.g. antigravity/Gemini) can pick the project up cold.
Newest entries go at the top of the Log section. CLAUDE.md describes the repo; this file
describes what happened and what is still open.

## Current state (keep this section up to date)

| Canto | Pages | Sanskrit | Hindi + notes | English | Status |
|---|---|---|---|---|---|
| 1 | 1–32 | Re-read in full by Claude (p.13 has no photo) | Re-read in full | Claude, faithful to Hindi + `shlok_en` | live |
| 2 | 33–60 | antigravity; metrically suspect verses re-read by Claude (93% of lines scan) | antigravity, not re-read | Claude-audited + `shlok_en` | live |
| 3 | 61–86 | antigravity; suspect verses + p.86 re-read by Claude (85% scan) | antigravity, not re-read | Claude-audited + `shlok_en` | live |
| 4 | 87–118 | Re-read in full by Claude | Re-read in full | Claude + `shlok_en` | live |
| 5 | 119–152 | Read in full by Claude directly from the photos (method in CLAUDE.md, "Transcription approach") | Read in full | Claude + `shlok_en` | transcribed 2026-11-02 (batches A–D, vv. 1–69); built locally, not yet committed; flagged spots await a blind second opinion |

Live site: https://abhinavananddwivedi.github.io/sri_markandeya_charitam/ (served from `docs/`). Pushed through commit 9238484 (2026-10-25).
Commit/push only when the user asks.

**Canto 5 plan:** four batches, A pp. 119–127, B 128–136, C 137–144, D 145–152. Each batch writes `transcripts/Sarg_5/pNNN.yml` from band/line crops, runs `scan_metre.R`, and is logged here.

## Open issues
- **Canto 1, page १३:** no photograph exists; the page is kept as is (user, 2026-10-25) until it is reshot.
- **Unclear spots for a second opinion** (blind crops, see CLAUDE.md step 5):
  - canto 1: about 30 `[unclear]` spots and 6 non-scanning pādas (2026-10-25 entry);
  - canto 2: vv. 3, 4, 25, 29, 38, 40, 45;
  - canto 3: vv. 11, 23, 36, 37, 38, 46, 48, 50, 52;
  - canto 4: about 20 `[unclear]` spots;
  - canto 5: the shlok spots listed in the batch A–D entries (2026-11-02), about 45 pādas in all.
- **Cantos 2–3 Hindi and notes** have not been re-read from the scans; a spot-check of a few pages would show whether a full pass is needed.
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

### 2026-11-02 (latest): Claude, canto 5 batch D (pp. 145–152, vv. 53–69) transcribed; canto 5 complete
- **Output.** `transcripts/Sarg_5/p145.yml`–`p152.yml` hold all fields, as in batches A–C. The site builds (152 pages).
- **Content.**
  - The procession on the road: riders, carts and walkers (v53), rest-places at every yojana (54), a well and sweets from the market (55).
  - Sunset: birds go to their nests (56), bees are shut in closing lotuses (57), the western quarter takes the sun (58), a pair of cakravākas fears the night (59), birds take refuge (60), owls come out (61).
  - Cows come home with their cowherds and are tied in their pens (62–64). The party halts in a village for the night (65–66).
  - Colophon vv. 67–69 (p152).
- **Metre.**
  - v53 is Sragdharā, like v52; vv. 54–64 are Drutavilambita; vv. 65–66 are **Mālinī**.
  - The colophon is Vasantatilakā for vv. 67–68 and Svāgatā for v69, as in cantos 1–4.
  - `scan_metre.R` now also knows Mālinī and Sragdharā.
  - Every line without an `[unclear]` marker scans, except two. v60 pāda 4 has "वासद्रुमं", where the "स" before "द्रु" is heavy. v68 pāda 3 has "सुप्रवृत्तिपूर्णं", which reads the same in every colophon.
- **p152.**
  - Heading "६७-६८-६९". The Hindi is the pointer to p. 32, plus the "विशेष" note that only pāda 3 of v69 differs ("अमृत बिन्दु"), plus "यहाँ पर पाँचवाँ सर्ग समाप्त हुआ".
  - The canto-6 heading "अथ षष्ठः सर्गः" at the foot is recorded only in the manuscript_note.
- **Unclear spots for a blind second opinion** (shlok):
  - v54 pāda 1 ("कृतयोजननिर्मितौ"? The Hindi suggests "प्रति-"; the locative needs "-निर्मिते");
  - v56 pāda 3 ("समुन्मुखमाययुः"/"-खगा ययुः");
  - **v58 pāda 2** ("सु?रपरावृता"; "सुदूरपरावृता" scans);
  - **v59 pāda 3** (the first eight syllables, "प्रबलयाश्रुवदस्रु"?);
  - **v61 pāda 3** ("अरिदु/अरिद्रु-मुत्कतया");
  - v63 pāda 1 ("सिग-", some form of śikya/sīṅkā);
  - v64 pāda 1 (written "इतव धान", read "इह बधान");
  - v66 pāda 2 ("संविदध्याम"?);
  - v69 pāda 3 ("अत्यगात्"/"अल्पगात्").
  - Hindi/notes doubts are marked `[unclear: …]` in the YAML. None are serious.
- **Second opinion.** The blind package for all of canto 5 (38 crops, about 45 pādas) is in `second_opinion/canto5/PROMPT.md`. The crops are regenerated from `spec.csv` by `scripts/tools/second_opinion_crops.ps1` and gitignored. Answers are awaited; save them as `second_opinion/canto5/answers_<model>.md`.
- **Committed and pushed** on 2026-11-02, with the YAML as it stood before the second opinion; corrections follow as a separate commit.

### 2026-11-02 (earlier): Claude, canto 5 batch C (pp. 137–144, vv. 37–52) transcribed
- **Output.** `transcripts/Sarg_5/p137.yml`–`p144.yml` hold all fields, as in batches A–B, with two verses per page. The site builds (144 pages).
- **Content.** The procession continues:
  - a rider standing in the saddle (v37), elders in palanquins (38), the heads of hermitages (39), and the gods in aerial cars (40–42);
  - the wedding guests from the heavenly worlds: the Moon (43), the Sun (44), Maṅgala (45), Budha (46), Bṛhaspati (47), Śukra (48), Śani (49), Rāhu (50) and Ketu (51);
  - the sky full of aerial cars and the earth darkened by clouds (52).
- **Metre.**
  - vv. 37–51 are Drutavilambita.
  - **v52 is Sragdharā**, the first change of metre in the canto. Its pādas 1 and 4 scan in full. `scan_metre.R` has no Sragdharā pattern, so it reports them as "-".
  - Every other line without an `[unclear]` marker or a strike-through scans.
- **Numbering.** The amanuensis's cursive ७ looks like a Latin "6", so the p137 heading reads like "36", but it is ३७. The verses run 37–52 without a gap.
- **Unclear spots for a blind second opinion** (shlok):
  - **v37 pādas 2–3** (the worst spot in this batch). Pāda 2 reads "युगकरान्तधुरा?रिहोत्थितः". Pāda 3 opens with something like "न्योमयतो", then a struck letter, then "ह".
  - v38 pāda 3 ("बृहतिकालित"?) and pāda 4 (the first letter: the metre wants "अ", but it looks like "प्य"/"ह्य");
  - v39 pāda 3 ("मनुजचारु-"/"मनुजवाह-");
  - v40 pāda 1 ("विहाय सकर्मणा"?);
  - v41 pāda 3 ("स्वचल"? "स्तृते"/"स्थिते");
  - v43 pāda 4 (the first word: "परम"?);
  - v46 pāda 2 ("नतिमोददान्"? It is written like "नतिलेहदान्") and pāda 4 ("बुधम्"/"मुखम्");
  - v48 pāda 2 ("प्रवतानिमान्"/"प्लवतः इमान्");
  - v49 pāda 4 ("विभावयताश्चिरमुद्गतान्");
  - v50 pāda 4 ("भाज"/"भासुर");
  - **v52 pādas 2–3** (Sragdharā). Pāda 2, "…यदभातिसंछन्नसूर्यम्", does not scan. Pāda 3 opens "आस्माकीनाभिरेषापि"?, and the word after "करिनिवहै" is unclear.
  - Hindi/notes doubts are marked `[unclear: …]` in the YAML. The least certain notes are line 2 of v41's and those of v52.

### 2026-11-02 (later still): Claude, canto 5 batch B (pp. 128–136, vv. 19–36) transcribed
- **Output.** `transcripts/Sarg_5/p128.yml`–`p136.yml` hold all fields, as in batch A, with two verses per page. The site builds (136 pages).
- **Content.** The ceremonies before the procession: worship of the sixteen Mothers and the ghee-Mothers (vv. 19–20), Nāndī-śrāddha and tarpaṇa (21–24), the parīchan and the kohl mark against the evil eye (25–26). Then the procession: horsemen, musicians, elephants, the guests (27–32), and displays of horsemanship (33–36).
- **Metre.** Every line without an `[unclear]` marker scans as Drutavilambita.
- **Unclear spots for a blind second opinion** (shlok):
  - v19 pāda 2 (the conjunct after "कुड्यगता") and pāda 4 (the first syllable: "ह्य"?);
  - v20 pāda 2 ("…रश्मिकजां"?);
  - **v23 pādas 3–4** (the worst spot: struck letters, an underlined word, and "ववार" in the margin; pāda 4 is 10–11 syllables as written);
  - v24 pāda 1 ("सुनिष्क्रयं"?);
  - v26 pāda 4 ("योग-" or "लोकपरायणाः");
  - v27 pāda 2 (the first word) and pāda 4 ("क्षणतया"?); in pāda 3, "ययुर्" is added above the line;
  - v33 pāda 2 ("शकल"/"शबल");
  - v34 pādas 1–2 ("…मश्नुते"? "पुलितं"? These are conjectures from the metre and the list of horses' gaits);
  - v36 pāda 2 ("कुलमजः"? Its sense is unclear).
  - Hindi/notes doubts are marked `[unclear: …]` in the YAML. The notes of v36 are the least certain.
- **Tooling.** `Rscript` is not on PATH, and R 4.4.0 fails to load tidyverse (purrr DLL). Use `"C:\Program Files\R\R-4.6.1\bin\Rscript.exe"`.

### 2026-11-02 (later): Claude, canto 5 batch A (pp. 119–127, vv. 1–18) transcribed
- **Output.** `transcripts/Sarg_5/p119.yml`–`p127.yml` hold all fields: shlok, Hindi, notes, `*_en`, `shlok_en`, and `manuscript_note` with metre and doubts. There are two verses per page. The site builds (127 pages).
- **Metre.** Drutavilambita (।।। ऽ।। ऽ।। ऽ।ऽ) is confirmed. Every line without `[unclear]` scans, except:
  - v11 pāda 3 ("भूपप्रियव्रत", the pr licence);
  - v12 pāda 4 ("वरगृहे सकलं विधिमकुर्वत", 13 syllables as written).
- **Unclear spots for a blind second opinion** (shlok):
  - v1 pāda 1 (the letter after "गते": "सु"?) and pāda 4 (the first word: "प्रवरता"?);
  - v2 pāda 3 ("गन्तुमतो"/"गन्तुमनो") and pāda 4 (the first letter, "ह्य"?);
  - v3 pāda 1 (the last word: "अश्वो"/"शुभो"; the metre wants ।ऽ);
  - v4 pāda 4 ("भ्रमनुदेपनुदेश…");
  - v6 pāda 3 ("प्रविमृश्य"? "सुमंथवाः"?);
  - v8 pāda 2 (the letter after "दृढजनो");
  - v10 pādas 2 and 4 ("वंशकान्"? "…गतानहरंस्तदा"?);
  - v13 pāda 2 ("नवसुताः"/"नवयुताः");
  - v15 pāda 2 ("कृतपणः"?).
  - Hindi/notes doubts are marked `[unclear: …]` in the YAML.
- **Script habit.** The amanuensis writes initial "ह्य" so that it looks like "प्य" (v2, v7).

### 2026-11-02: Claude, canto 5 ingested (pp. 119–152)
- **Photos.** 34 photos in `Images/raw/Sarg_5/`, ingested with `ingest_pages.ps1 -start 119` (all EXIF `Rotate90FlipNone`) to `Images/pages/p119.jpg`–`p152.jpg`.
- **Checks.** Every page is upright. The numerals sit at the **top right** in this canto and run ११९…१५२ consecutively. Every one was checked, except p124, where the numeral is faint but consistent. There are no gaps and no overflow sheets.
- **p119.** Heading "अथ पञ्चमः सर्गः"; a red-ink "Pramod Kumar" signature in the top-left margin.
- **p152.**
  - Colophon vv. ६७-६८-६९, with the pointer "अर्थ … पृ. सं. ३२ में अवलोकन करें" (as in p032/p060/p086).
  - A "विशेष" note: only pāda 3 of v. 69 differs in meaning ("अमृत बिन्दु").
  - "यहाँ पर पाँचवाँ सर्ग समाप्त हुआ".
  - At the foot, the **"अथ षष्ठः सर्गः"** heading. This belongs to canto 6 and is to be recorded only in a manuscript_note on p152.
- **Metre.** v. 1 looks like Drutavilambita (to confirm with `scan_metre.R`).

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
