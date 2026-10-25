# Sarga 4 (pp. 87–118): second assessment, after the Gemini 3.1 Pro re-run

Reviewer: Claude (Opus 5.5), 2026-10-24. Audience: the user and antigravity. Scope: the re-run
exports in `transcripts/Sarg_4/` and `transcripts/Sarg_4_English_translation/`, the compiled
`p087.yml`–`p118.yml`, `plan_reexecution.md`, and `scripts/validate_sarga4_scansion.R`. I compared
every verse block against the rejected first pass, which I backed up on 2026-09-27, and checked
nine pages against crops of the scans.

## 1. Bottom line

The re-run is much better than the first pass, but it is not ready to publish, and
`plan_reexecution.md` claims more than was done.

- **The Hindi and the notes improved the most.** Several re-readings that looked like
  "corrections to please the reviewer" turn out to be right when checked against the scan:
  Dākṣi in the v22 notes, वरविक्रय in v40, दाक्षि प्रधान बारातियों in v56, and the new Hindi of v7
  and v27.
- **The Sanskrit is better but still unreliable.** Lines that fit the metre rose from 34% to 72%,
  and fully metrical verses from 6 to 24 of 61. But the scans show misreadings in verses the plan
  calls "resolved", and some verses still contain non-words.
- **The colophon (vv. 64–66) was not read fresh**, despite the plan's claim. It merges my template
  with the corrupt canto-3 text, gets the poet's grandfather's name wrong, and adds a rubric line
  that is not on the page (§3.1).
- **The English still translates the Sanskrit, not the Hindi**, in about a dozen verses. In two
  verses, `notes_en` still translates the *old* notes, not the corrected ones.
- **No `[unclear]` marker appears anywhere** in the batch, although many Hindi passages are still
  garbled. The plan promised such markers.
- **The verification claims are false.** `validate_sarga4_scansion.R` prints syllable counts and
  never fails, so "passed across all verses" means nothing. Dozens of `manuscript_note`s say
  "all four pādas scan at 11 syllables" when they do not.

## 2. A correction to my first assessment

I wrote that canto 4, like canto 3, is mostly in Rathoddhatā. **That was wrong.** A laghu/guru
scansion of the new text gives 166 lines of exact **Svāgatā** (र न भ ग ग: `ऽ।ऽ ।।। ऽ।। ऽऽ`) and only
10 of exact Rathoddhatā (`ऽ।ऽ ।।। ऽ।ऽ ।ऽ`). The two metres differ only in syllables 9–10. The
scan of p100 confirms Svāgatā: its last line reads `तं पराशरमभीष्टसुसिद्ध्यै`, which is exact
Svāgatā. A few verses (e.g. v7, confirmed on the scan) are genuinely Rathoddhatā.

My error propagated: all 61 metre notes in the re-run say "Rathoddhatā", and no note mentions
Svāgatā. Some readings may have been bent toward the wrong pattern; p100 v27 line 4 is one case
(the export has `तं पाराशरमभीष्टसिद्धये`, the scan `…सुसिद्ध्यै`). Two smaller errors of mine: in
v7, `समुदभूत्` is a valid aorist, not a non-form; in the v22 notes, the old `पराशर` was the
misreading and `दाक्षी` is correct.

## 3. Findings checked against the scan

### 3.1 Colophon, p118 vv. 64–66: not read fresh (grade D)

| Item | Export | Scan |
|---|---|---|
| Grandfather's name | `बन्धूरामस्य` (and the English says "Banchū Rāma") | `बच्चू रामस्य`, as on p032 and p060 |
| Line 2 | `सुमनसां मनसाऽऽदृत्य मनसाऽङ्घ्रियुग्मं` (33 syllables) | `…मनसाऽङ्घ्रियुग्ममानम्य…`; `मनसाऽऽदृत्य` is from the corrupt p086 text |
| Closing rubric | `॥ इति श्री मार्कण्डेयचरिते महाकाव्ये चतुर्थः सर्गः समाप्तः ॥` | **Not on the page.** `विशेष` follows the verse directly. |
| Hindi pointer | `६४-६५-६६ का हिन्दी अनुवाद पृ. ३२ में देखें` | `६४-६५ का…` (only 64–65 are deferred; v66 is glossed in place) |
| Hindi gloss of v66 | `सद् द्विजो के आशीर्वादों से पूर्ण` | `सद् द्विजों के आचरणों से पूर्ण` |

Lines 3–4 match the scan only because they are also identical to p060. The last line of v66
(`एष तेन रचिते काव्यनाम्ना सर्ग… तुरीयः`) needs a careful re-read; I cannot read its middle.

### 3.2 v63 (p118): the plan's "accurate" Śārdūlavikrīḍita is wrong

Lines 2–4 still have 18, 20 and 22 syllables. The scan resolves lines 3 and 4 to exact
19-syllable Śārdūlavikrīḍita:

- Line 3: scan `सन्तृप्तेष्वखिलेषु तत्परिजनैः स्वादैः स्वयं प्रीणितः`; export `…परिजनेष्वात्मैव…`.
- Line 4: scan `सुष्वाप स्मृतितत्परो भगवतो लीलाविलासं चिरम्` (an underlined interlinear word
  follows `सुष्वाप`; check it). Export: `सुप्त्वाऽयं गेहगतस्तत्परो … लीलाविलासांश्चित्तगाः`. The first
  pass had `सुष्वप`, which was closer; the re-run made it worse.

### 3.3 v59, v62 and v40: misread Sanskrit, or Hindi altered to fit a theory

- **v59 (p116), grade D.** The scan visibly has `…पाठैः` (line 1), `…शुभकुम्भं` (line 2) and
  `…करतले` (line 3). The export has `मङ्गलैः`, `मथाऽथ कुम्भयुक्` and `कराग्रके`. The amanuensis
  Hindi supports the scan (`मङ्गल पाठ करके`, `वर के हाथ में`). The export's `मथाऽथ` is filler.
- **v62 (p117), grade C.** The scan's line 2 is `विप्रवृन्दमपि दाक्षिसनाथम्` (export
  `दक्षिणनाथम्`), and line 4 begins `स्तं` (export `स्ते`). The notes read **`दाक्षि प्रमुख सभी
  ऋषियों`**; the export has `दक्षिण प्रान्त के सभी ऋषियों`, and the English invents "arrived from the
  southern realms". The Hindi `दक्षिण से समागत` needs a re-read for the same word.
- **v40 (p106), grade B.** Lines 3–4 and the Hindi and notes are now right. But lines 1–2 read
  `स्वीकृतं सकलमेव मनस्थं / यद्भवद्भिरुदितं सुविभाव्य`; the export has `निजमनोभवमन्त्रं` and
  `सुविचार्या`.

### 3.4 Re-readings confirmed

v7 (except that line 4 ends `तिरोऽभूत्`, not `तिरोऽदधात्`), v22 notes (`महर्षि दाक्षी ने`), v27 Hindi,
v39 (all four lines), v40 lines 3–4 and its Hindi and notes, and v56 Hindi and notes.

## 4. Findings from the text alone

### 4.1 Sanskrit: still wrong where the plan says "resolved"

| v | Problem |
|---|---|
| 1 | Unchanged. Lines 1–3 have 12 syllables. The plan claims "verified 11 syllables". |
| 5 | `ततपोऽद्भुतशक्तिः` is not a word. |
| 6 | `ससुहायः` is not a word. Line 3 has 10 syllables. |
| 8 | `र्खनित्रात सुखनित्रीपिटकादीन्`: wrong sandhi and a non-word. `सम्भभार` is not a form. |
| 11 | `अभिपदे` is not a form (perhaps `अभिपेदे`). |
| 12 | `वर्धुलाक्ष` and `मन्त्रचकार` are not words. |
| 13 | `चरणिं` contradicts the Hindi (`पृथिवी को`, i.e. `धरणिं`). `सुसिद्धितरैव` is invented. |
| 15 | `खादिरे मुसलश्चाशु` is ungrammatical (`खादिरो मुसलः`). Two pādas have 9 syllables. |
| 17 | `दृषदथाञ्ज` is not Sanskrit. `विरेजतुः` (dual) has a plural subject. |
| 19 | `लघूना` and `जनाग्रिः` are not forms. Line 1 is not metrical; the plan claims it is. |
| 20 | `पुनीताम्` does not fit; line 4 has 13 syllables. |
| 21 | `सोऽविदं`, `मैहिकादि` and `निजज्ञानान्` are not forms. |
| 23 | `प्रह्वतं` is not a word. |
| 24 | `समुपसृत्य` contradicts the Hindi `सुनकर`; the first pass's `समुपश्रुत्य` matched it. |
| 25 | `न विनाऽहं नोत्सहे` is a double negative and inverts the sense. Read `…विनाऽहमुत्सहे`. |
| 29, 45 | `सर्वे एव` is wrong sandhi (`सर्व एव`). The first pass had v29 right. |
| 37 | All four lines have 12 syllables. `त्संप्रीत्या` begins with a stray consonant. The plan claims all lines are 11 syllables. |
| 38 | **Regression.** `दिष्टवादिभिरतीव यतस्तत् / -त्कार्यमेव` doubles the `त्`. The first pass had `…रवश्यतया त- / त्कार्यमेव`, which matches the Hindi `अवश्य`. |
| 41, 42 | The notes claim 11 syllables for every pāda; v41 line 2 has 12, v42 lines 1, 2 and 4 have 12, 12 and 10. |
| 43 | Still unintelligible (`समुदस्थौ`, `…गोप्रदानैर्विधिवद् गोदानैः`). |
| 45 | Still gibberish (9/11/12/10 syllables). The plan claims "authentic Rathoddhatā". |
| 46 | `ऋत्विकेषु` should be `ऋत्विक्षु`. `रानतेन` is a fragment. |
| 49, 50 | Almost unchanged from the first pass, despite the plan's claims. |
| 53 | Lines 3–4 have 10 syllables. |

### 4.2 Hindi and notes

- **New errors introduced:** v21 notes `अनतिव्याप्ति` (the first pass had `ज्ञानार्थी`); v28 notes
  `उदारशमतो`; v53 Hindi `असमग्र` (the first pass had `अवश्य`); v54 Hindi `मुत्कण्डु` (a typo for
  मृकण्डु); v56 notes `अनुसार किया` (the first pass had `अनुसरण`).
- **Still garbled, with no `[unclear]` marker:** v6, v7 (genuinely odd, but as written), v15
  `चावल प्रदर्शन`, v20, v21, v36 `उसने ही`, v43, v45 (and the notes' `प्रेम की नाक सीमा`), and the
  v46 notes `अपनी लताओं से झुकते मिलते`.
- **Hindi rewritten to match the new Sanskrit; check on the scan:** v31 `लज्जा` → `वञ्चकता`; v46
  `सुखों` → `ऋत्विजों`; v49 `दक्षिण` → `दाक्षि`.
- **v33.** The plan says it corrected `मुद्गलाचार्य!` to `महर्षे!`. In fact it deleted the second
  vocative and inserted `अतः`. Read the notes from the scan instead.
- **v43.** The plan says "sage Gautama" was eliminated. The notes still read `गौतमप्रभृति`, and
  `notes_en` says "sages such as Gautama".
- **v44.** The English calls the sage "Dakṣa", while every other verse has Dākṣi.

### 4.3 English

The batch still breaks the rule "translate the Hindi only".

| v | The English follows the Sanskrit or adds material |
|---|---|
| 11 | "pleasant roofs all around" (the Hindi has `चारों बरामदों में`) |
| 15 | "for treating the fine grain" papers over the garbled `चावल प्रदर्शन` |
| 17 | Adds "mortar-vessel for … medicinal herbs" and "soft cotton"; drops the flour mill (`चक्की`) |
| 18 | Adds "arranged day by day" |
| 19 | Adds "humble origin", "foremost of men" and "kings"; none of these is in the Hindi |
| 20, 21 | Fluent sentences over garbled Hindi |
| 27 | Translates the Sanskrit; omits "elder brother" (`बड़े भाई`) |
| 28 | Says Mṛkaṇḍu "entrusted" everything to Parāśara; the Hindi says he collected materials for Parāśara |
| 29 | Says he "took a seat"; the Hindi says he gave the others seats |
| 30 | "does not even occur to my mind"; the Hindi has `उचित प्रतीत नहीं होता` |
| 37 | Adds "I shall return" |
| 63 | "partook of food with his family" and "retired to rest" come from the notes, not the Hindi |

Two `notes_en` blocks still translate the **first-pass** notes: v57 ("ablution water offered by
Sage Mṛkaṇḍu" is no longer in the Hindi) and v58 ("the Seven Ṛṣis"; the new Hindi has
`सभी देवों`). v50 `notes_en` contains a reply to my review, "(… not flower-shaped)"; delete it.
The `(Verse N)` endings are now uniform.

## 5. Process and metadata

1. **Independence is still missing.** The Sanskrit, Hindi and notes embedded in the English export
   are byte-identical to the Devanagari export in 63 of 64 blocks; v32 differs by one word
   (`सम्पादनार्थ` / `सम्पादना अर्थ`).
2. **`source:` is stale in all 32 YAML files.** It still says "flash-tier batch subagents,
   2026-09". It must name the re-run (Gemini 3.1 Pro, 2026-10) and the model tier.
3. **`notes_uncertain` is never set,** although many passages are uncertain.
4. **The metre labels are wrong** (§2), and `manuscript_note` still mixes plot summary with
   paleography (e.g. v41, v59, v60).
5. **The validator does not validate.** It should compare each line's laghu/guru pattern against
   the declared metre and fail on a mismatch. My scansion script (`scan.R`, in the session
   scratchpad) does this; it can be moved into `scripts/` on request.
6. **`GEMINI.md` §7 still mandates `"Model": "flash"`.** That conflicts with the re-run and with
   this canto's experience.

## 6. Recommendation

Do not publish yet. Rerunning the whole canto is not necessary; a targeted pass is enough:

1. Re-read p118 (vv. 63–66) line by line against §3.1–3.2.
2. Re-read the Sanskrit of the verses in §3.3 and §4.1, with the metre set to **Svāgatā**. Keep
   genuine Rathoddhatā lines where the scan shows them.
3. Re-read the Hindi and notes listed in §4.2. Mark anything still unreadable `[unclear: …]`.
4. Retranslate the English for the verses in §4.3 from the corrected Hindi only, and regenerate
   `notes_en` for v57 and v58.
5. Fix the metadata in §5, recompile, and rerun a scansion check that can fail.

After that, I would expect canto 4 to be at canto 3's level. On metre it is already there: 72% of
lines fit, against 74% for canto 3.
