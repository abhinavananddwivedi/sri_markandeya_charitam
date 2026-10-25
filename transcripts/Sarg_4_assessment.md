# Sarga 4 (pp. 87–118): assessment of the antigravity transcription and translation

Reviewer: Claude (Opus 5.5), 2026-09-27. Audience: antigravity, for a revision pass on a
stronger model. Scope: every file in `transcripts/Sarg_4/sri_markandeya_caritam_page_{87..118}.md`
and `transcripts/Sarg_4_English_translation/sri_markandeya_caritam_page_{87..118}.md`.

## 1. Bottom line

The batch is structurally sound, but its text is not reliable enough to publish.

- **Structure is correct.** Verse numbering runs 1–63 plus the 64–66 triad, two per page, with no
  gaps or overlaps, and it continues cleanly from canto 3. Page headers match filenames. The files
  parse cleanly into the site schema.
- **The Sanskrit is the weakest layer.** Of 63 ślokas, 19 are unusable and 22 more have
  significant errors (§3). Many lines are not Sanskrit words at all.
- **The Hindi translation is the second weakest.** In many verses it reads as ungrammatical or
  meaningless Hindi. The amanuensis did not write nonsense, so these are misreadings of the
  handwriting.
- **The grandfather's notes are the best layer.** They are mostly coherent, with garbled patches.
- **The English is fluent but not faithful.** Where the Hindi is garbled, the English composes a
  plausible meaning, drawn from the notes, the manuscript note, or general knowledge, and presents
  it as a translation. This is the most serious process problem: it turns misreadings into
  confident, readable prose, which hides them from any reader who does not check the Hindi.
- **The metre notes (`manuscript_note`) are mostly plot summary.** Metre labels are asserted
  rather than checked, and some are wrong.

## 2. Evidence

### 2.1 Metre test (objective)

Cantos 3 and 4 are both mostly in Rathoddhatā, 11 syllables per pāda: `ऽ।ऽ ।।। ऽ।ऽ ।ऽ`.
A mechanical syllable count of every shlok line in the YAML gives:

| | Canto 3 (same pipeline) | Canto 4 (this batch) |
|---|---|---|
| Lines with exactly 11 syllables | 84% | 53% |
| Ślokas with four 11-syllable lines | 55% | 17% |

A correct 11-syllable count does not prove a correct reading. A wrong count does prove an
error, unless the metre really changes, as it does in v15 (Anuṣṭubh) and v63 (Śārdūlavikrīḍita).

### 2.2 Spot check against the scan

On p107, verse 42, line 3, an upright crop of the scan reads **`तद् भवत्सु किल सन्निहितेषु`**. This
is clean Sanskrit, 11 syllables, and correct Rathoddhatā. The export has
`तद् भवत्सु खिन्न सान्नोहितैषु`. Line 1 visibly contains `…स्वजनयुतैश्च`, which the amanuensis
Hindi confirms (`स्वजनवृन्दों से युक्त विप्रवर`). The export has `विपुलाद्र्यभि संघसङ्गतैर्मखैः`.
The handwriting on that page is legible when it is upright and cropped. The errors come from the
reading process, not from an unreadable manuscript. (My reading of line 1 is partial; line 3 is
clear.)

### 2.3 No independent cross-check

The Sanskrit, Hindi translation and notes embedded in the English export are **byte-identical** to
the Devanagari export for all 64 verse blocks. One reading was copied into both files, so the
second file adds no confirmation.

### 2.4 Colophon triad copied, not read

The p118 triad (vv. 64–66) is canto 3's p086 triad with only `तृतीयः` changed to `चतुर्थः`. The p086
triad is itself corrupt (`बन्धुपौत्रेण वै गुणवता दृढम्`, `शितस्य सुशीलकेण`, `सङ्गितोचित`). The
canto 2 version on p060, from an independent transcription, is far better:

```
श्रीचन्द्रभूषणसुधीसुतकेन बच्चू-
रामस्य पौत्रसुभगेन नवंगुणाढ्यम् ।
संगुम्फितं सुमनसो मनसाऽङ्घ्रि युग्मं
मानम्य तेन हि शिवस्य सुशिष्यकेण ॥
धानेश्वरी हृदयजेन शिवार्चकेन
विद्वज्जनार्चनरता धरणीधरेण ।
काव्यं सुमङ्गलमयं सुप्रवृत्तिपूर्णं
शाश्वत् समा विजयतां शिवयोः प्रसादात् ॥
दीर्घजीविचरितामृतकाव्ये
सद्विजोचितसदाऽऽचरणाढ्ये ।
[canto-specific line — read from p118 itself]
व्यत्यगादिह महेशकृपातः ॥
```

## 3. Verse-by-verse ratings

Grades:
- **A**: usable as is.
- **B**: minor problems; fix the items listed.
- **C**: significant errors; re-read from the scan.
- **D**: unusable; re-transcribe from scratch.

Columns: Skt = Sanskrit, Hin = amanuensis Hindi translation, Notes = grandfather's notes,
Eng = English.

| p | v | Grade | Skt | Hin | Notes | Eng | Main problems |
|---|---|---|---|---|---|---|---|
| 87 | 1 | C | C | D | B | C | The Hindi carries v2's content (`बहुदर्शी होने के कारण उसे अपना सम्भाषण नहीं माना`). `चार गौ` should be `चारु गौ`. The English follows the Sanskrit, not the Hindi, and says "having performed" where the Hindi has `करने के पूर्व`. Lines have 12 syllables. |
| 87 | 2 | C | C | C | B | C | The Hindi says `स्वीकार नहीं किया`; the notes say `तिरस्कार नहीं किया`, which is the likely reading given `नाभ्यमन्यत`. The Hindi has `भक्त`, the notes `शक्ति`. `स्राष्ट्रिकर्मणि` should probably be `स्रष्टृकर्मणि`. The English silently follows the notes. |
| 88 | 3 | C | D | C | B | B | The Sanskrit is unmetrical (12–13 syllables): `…निवासकोटं सः`, `आश्रितुं रसेत`. The Hindi has `सरगाव के पास` and `आदि रस के साथ`, both garbled (probably for वट / अंगिरस). |
| 88 | 4 | C | D | C | B | B | `गौर्जाले चोदभूतं दिगन्तान्` and `विध्यै व्यपयोक्तुम्` are not Sanskrit. The Hindi `दर्दभूमि`, `सिद्धियों को स्वीकार किया` is dubious. |
| 89 | 5 | D | D | D | C | D | The Sanskrit is ungrammatical. The Hindi `सतभर्तता … भारती चालकों से` is meaningless. The English "acts methodically" is invented. |
| 89 | 6 | C | C | D | B | B | Line 1 has only 10 syllables. `निचोकुर्-` is not a word. The Hindi `लेन आशा/दक्षताति को रोक कर ध्यान उन्होंने` is garbled. |
| 90 | 7 | D | C | D | C | C | `समुदभूत्` is not a form. The Hindi `सर्वलोकों की उन्नत से`, `भूमि के सतनोरण हो` is garbled. The notes `ध्यान भाषित` should probably be `ध्यानाभासित`. |
| 90 | 8 | C | C | C | C | C | `पिठार्दाः` is not a word, and lines 3–4 have no verb. The Notes column has `षड अङ्गों द्वारा के` and `पियारी (रँबेची)`. The English invents "six-limbed Vedic consecration" and "rāmbeī". |
| 91 | 9 | D | D | D | D | D | 13–14 syllables per line, so not Rathoddhatā. The Hindi is meaningless and the notes' opening (`त्रिविध चुनादि … लोक गेह`) is garbled. It was reportedly drafted and struck out on p89; verify that it really belongs on p91. |
| 91 | 10 | C | C | B | B | B | `शोध्यमथ पटलान् गृहशाणां`, `चिरङ्गम्` and `पक्वकेटकव्यधायि` are garbled. The gloss `pakva-iṣṭakā` is a guess. |
| 92 | 11 | D | D | D | B | C | `सुवल्मिकाः` means "anthills", which is nonsense here. The Hindi `पराधियों`, `जाने वालों से` is garbled. The English is taken from the notes. |
| 92 | 12 | D | D | D | C | C | `सूर्यवत्सा समसाभ कलावत्` and `सोऽङ्गेनेह सुगृहं मन्त्रचकार` are garbled. The Hindi `चन्द्रकलाना वती बाँधना` is too. The notes' `तेजो द्वीप` should probably be `तेजोदीप्त`. |
| 93 | 13 | B | C | A | B | A | `गोस सेवनपरो` and `ह्यागमम्यत` need re-reading. The notes' `अपनी चर्चा` should probably be `चर्या`. |
| 93 | 14 | B | C | A | A | A | The text has `सम्बाहितमभूत्` but the manuscript note quotes `सम्भावितमभूत्`, so the two contradict each other. Lines 1–2 have 10 syllables. |
| 94 | 15 | B | B | B | B | A | Anuṣṭubh; pāda 3 has 9 syllables. The Hindi `चावल प्रदर्श` is garbled. |
| 94 | 16 | B | A | B | C | C | The metre note says "Triṣṭubh/Upajāti", but line 1 scans as Rathoddhatā. The notes `बहुत दुहक … कपिलाकृति` are garbled. The English V invents "bowl shaped like a gentle kapilā cow". |
| 95 | 17 | C | C | A | C | C | `शिलामाया`, `पेषणाम्` and `तत्तूलफलकादियुतत्वं` are garbled. The English V says "the amanuensis notes", but the text is the grandfather's. It also invents "jars of preserved fruit jams" from garbled `फलों को द्वारा निर्मित अवलेह`. |
| 95 | 18 | A | A | A | A | A | — |
| 96 | 19 | C | D | C | B | C | `सुयशोरहलीना`, `बभूविह` and `जनरङ्गेऽत्र` are garbled. The second Hindi sentence is meaningless. |
| 96 | 20 | C | C | C | A | B | `द्रागतन्द्यत` and `ब्रह्मवित्तमसुचयोऽपि पुनानाम्` are doubtful. The second Hindi sentence (`कीर्ति श्रवण कराने का नियम तन्मय भी हुआ`) is garbled. |
| 97 | 21 | C | C | D | B | C | The Hindi `ऐहिकादि कलादियों में चतुर लोगों को जान के लिए` is meaningless. |
| 97 | 22 | B | B | C | B | A | The Hindi `सुशृत सुनने की कुशलता` is garbled. |
| 98 | 23 | B | C | B | B | A | `प्राह्लुतो` is not a word. |
| 98 | 24 | B | C | A | A | A | `योजियाऽहमभिनन्दनयायाः` is garbled. `कर्तुमागत भवान्हि` is ungrammatical. |
| 99 | 25 | B | B | B | A | A | The Hindi `मण्डल के कहने पर` should be `मुद्गल`. `भूत्सहे` should be `उत्सहे`. |
| 99 | 26 | A | A | A | A | A | — |
| 100 | 27 | C | C | B | C | B | Line 1 has 14 syllables. `अभ्यैषम्` is garbled. The notes `जिन की यथार्थतया आशीर्वाद लोक सम्मति जैसी हुई थी` are garbled. |
| 100 | 28 | C | C | C | D | C | `स पाराशरभरो` is garbled. The notes `अकर्मण्य दीनता कामिनी यथार्थ सत्ता वाले` are meaningless. The English V invents "unfamiliar with worldly ceremonial intricacies". |
| 101 | 29 | B | B | A | A | A | Missing finite verb (probably `ददौ`); check the line break at `निर्वि-/कल्प`. |
| 101 | 30 | B | C | B | B | A | Line 1 has 13 syllables, and `प्राह` duplicates `उवाच`. The Hindi `सदैव मुद्गल` is garbled. |
| 102 | 31 | B | C | A | A | A | Lines have 9 and 12 syllables. |
| 102 | 32 | C | B | C | B | C | **Speaker problem.** A `दाक्षी` suddenly speaks the father's words ("I have come for my daughter"), although Mudgala speaks from v23 to v39. Decide from the scan whether this is a misreading of `दाक्षिण्यात्` or whether Dākṣi really speaks for Mudgala, and make all layers agree. |
| 103 | 33 | B | A | A | C | C | The notes address `मुद्गलाचार्य!` inside Mudgala's own speech. The addressee should probably be Parāśara. The English copies the error ("O revered Master Mudgala!"). |
| 103 | 34 | B | C | B | B | B | `सरित्वा` is not a word. |
| 104 | 35 | B | C | A | B | A | `केन चाप्यथ रमेव विन्द्या` is garbled. The notes `वह तो सदा अभेद्य ही है` are unclear. |
| 104 | 36 | B | B | A | A | B | English IV reverses the sense: the Hindi says the groom's side *should* be content, not that it *declares* this. |
| 105 | 37 | B | C | A | A | A | `सम्प्रितं मम नु गृह्यतां प्रहर्षम्` and `अल्पकै रहमहर्गणे` are garbled. |
| 105 | 38 | A | A | A | A | A | — |
| 106 | 39 | B | C | A | A | B | Lines 3–4 have 13–14 syllables. The English adds "anxious heart" and "serene disposition", which are not in the Hindi. |
| 106 | 40 | C | D | C | C | C | Lines 3–4 (`यौतुके विवादतां मनुजौ नौ / वाहि तन्न वरोऽस्तु सुभवः`) are garbled. `वञ्चिकूप` is not a word (possibly `अन्धकूप`). |
| 107 | 41 | B | C | B | C | B | Line 4 has 13 syllables and ends `स्वस्त्य`. The notes `तिलक आदि शुक की` are garbled. |
| 107 | 42 | D | D | C | — | D | **Proven misreading** (§2.2). The Hindi `जानादि दैत्य नाशक` stands for `जनार्दन`. The absence of notes is correct: the scan's commentary space is blank. |
| 108 | 43 | D | D | D | D | D | The whole Sanskrit is unintelligible. The Hindi `गौ भेष द्वारा रख गये` and the notes `अभिमत गौतमी षट्त्यागी … सङ्ग धंधा` are too. The English invents "sage Gautama". |
| 108 | 44 | D | D | C | B | C | `सफलमर्पिक युर्गान्त =` is not Sanskrit. The Hindi `(मुद्गल)` is misplaced. The notes' "9 pairs of gold coins" should be checked. |
| 109 | 45 | D | D | D | D | D | The Sanskrit is gibberish (`प्रीतिं हरिरिविलाउगे कलयाऽथ / नृत्यन्ननुकदेर दर्शनाज्जूत`), and so are the Hindi and notes (`प्रेम की नाक सीमा`). |
| 109 | 46 | D | D | D | C | C | The Sanskrit (`प्रवितेषु निज सभासु पद्- / ऋषिकेभ्यः मुदसु खतेषु`) is gibberish. The notes `अपनी लताओं से झुकते मिलते` are garbled. |
| 110 | 47 | C | D | C | C | B | `मुद्गलो हृदयतोऽनुयुतान` is garbled. The notes break off mid-sentence (`आह्लादित (रहे)`). |
| 110 | 48 | C | C | C | C | B | `शमूनि` and `लब्धुभिः` are not words. The Hindi `बड़ों ईश्वर कृपा`, `चरणों के साथ` is garbled. |
| 111 | 49 | B | C | A | B | A | `सामग्रीं वरणतो` and `दाक्षिण्यद्विजनटेन` are garbled. |
| 111 | 50 | C | C | C | B | C | The Hindi drops the *khārī-pacana* and has `दूध (पकाने)`. The English V misreads `फूल का थाल` (a bell-metal platter) as "shaped like an open flower". |
| 112 | 51 | D | D | D | C | C | The Sanskrit is gibberish. The Hindi `स्वारोगितागलिक` is not a word. |
| 112 | 52 | C | C | A | A | A | `क्थं` and `स्तृच्छेद्यम` are not words. |
| 113 | 53 | D | D | C | A | B | `वरसमायिकदिरुपाया` and `भवयुः` are gibberish. |
| 113 | 54 | D | D | C | A | B | `मुद्गलन मुनिना परिमतो- / शालिनना प्रतिगभत दतोयम्` is gibberish. |
| 114 | 55 | D | D | C | C | B | The Sanskrit is gibberish. The notes `आये एस्तों के` are garbled. |
| 114 | 56 | D | D | C | B | C | The Hindi `दक्षिण प्रधान भारतीयों` should probably be `बारातियों`. The notes' `दाक्षिणात्य मुनि` is probably Dākṣi (v49), but the English has "southern sage". |
| 115 | 57 | D | C | D | A | B | The Hindi `पावन चौहद्दी … नगरी अधिक सम्मानता` is meaningless. |
| 115 | 58 | D | D | B | A | B | `स्थास्थ्य मङ्गल घटेश् चरया` is gibberish. English IV drops the Hindi's `नक्षत्र` worship. |
| 116 | 59 | D | D | C | B | C | Lines have 13–16 syllables. English IV does not render the Hindi (the groom's feet touching the kalaśa with kumkum). |
| 116 | 60 | D | D | D | C | C | The Hindi (`…व्योतित हो गये पाण्डवे`) is gibberish. The English invents the gloss "aṅgulīyāṅga-dīkṣā / bridal pledge tokens". |
| 117 | 61 | C | D | A | A | A | `स्वाहिति वाच्य वरैः प्रतितान्तयोः` and `धातशतन्` are garbled. |
| 117 | 62 | C | C | A | A | A | The marginal heading `शम्भुभक्त` is carried as shlok line 1; move it to `manuscript_note`. `विप्रयुङ्केभ्यो` and `प्रणानाम` are misread. |
| 118 | 63 | C | C | A | A | A | Lines have 19–22 syllables, which is Śārdūlavikrīḍita, so lines 3–4 are overlong. The note calls the metre "स्रग्धरा/मन्दाक्रान्ता संकर", which is wrong. The note's own "manuscript reading" (`शुष्यन् सेहगृहाति`) contradicts the text. |
| 118 | 64–66 | D | D | — | — | C | Copied from p086, not read (§2.4). |

**Totals:** A 3, B 19, C 22, D 19, and the triad is D.

**Pages to re-transcribe first** (both verses C or D): 87, 88, 89, 90, 91, 92, 96, 100, 108, 109,
110, 112, 113, 114, 115, 116, 117, 118. All other pages need at least the targeted fixes above. A
full re-run of all 32 pages is the simplest path.

## 4. Systematic problems and required fixes

### 4.1 Reading the images

1. **Check orientation before reading.** The files `Images/pages/pNNN.jpg` have upright pixels
   but carry a stale EXIF orientation tag. Most pages have tag 6 (rotate 90°), and p087–p088 have
   tag 3 (rotate 180°). A viewer that honours EXIF will show the page sideways or upside down.
   Read the raw pixels, or confirm that the page numeral and text are upright before
   transcribing. This may be a root cause of the misreadings.
2. **Read at line level, not page level.** §2.2 shows that an upright crop of a single verse is
   legible where the whole-page reading failed. Crop each verse, or each line, at full
   resolution before transcribing.
3. **Read every page fresh.** Never reuse text from another page. The colophon triad was copied
   from p086.

### 4.2 Transcribing the Sanskrit

4. **Check the metre of every line.** Count syllables and write out the laghu/guru pattern. For
   Rathoddhatā the pattern is `ऽ।ऽ ।।। ऽ।ऽ ।ऽ`. If a line fails, re-read the image. If it still
   fails, keep the manuscript reading and mark `[unclear: …]`. Do not pad or trim to make a line
   scan.
5. **Every word must be a real Sanskrit form.** Strings like `पिठार्दाः`, `निचोकुर्-`, `सुवल्मिकाः`
   and `हरिरिविलाउगे` are signs of a misreading, not of the author's Sanskrit.
6. **Use the Hindi as a check on the Sanskrit, and the reverse.** The amanuensis Hindi glosses the
   verse closely. If it names something (`स्वजनवृन्द`, `जनार्दन`, `सन्निहित`), the Sanskrit should
   contain the matching word.
7. **Mark reconstructions explicitly.** Put the diplomatic manuscript reading in `manuscript_note`
   and the reconstruction in the shlok. Reconstruct only when both the metre and the Hindi support
   it; canto 3 p076 is the precedent. The shlok and the note must never contradict each other
   silently (see v14 and v63).

### 4.3 Transcribing the Hindi and notes

8. **The Hindi must be grammatical Hindi.** If a reading produces non-words (`सतनोरण`, `पाण्डवे`,
   `स्वारोगितागलिक`), re-read it. If it is still unreadable, mark `[unclear: …]`.
9. **Keep speakers and names consistent.** Establish who speaks in v23–v39 and who Dākṣi is, then
   make all layers agree (v32, v33, v35, v44, v49, v56).

### 4.4 English translation

10. **Translate the Hindi only.** `II. Hindi Translation` must be rendered in `IV`, and
    `III. Notes` in `V`. Do not draw on the Sanskrit, the notes, the manuscript note or general
    knowledge to fill gaps.
11. **Carry uncertainty into the English.** Where the Hindi has `[unclear: …]`, the English must
    have `[unclear]` too. A smooth English sentence over garbled Hindi is the worst failure mode
    in this batch.
12. **Add nothing and correct nothing.** Do not add details (the kapilā cow, fruit jams, "open
    flower", "sage Gautama") or glosses that the Hindi does not contain. If you think the Hindi is
    wrong, say so in a bracketed translator's note; do not correct it silently.
13. **Keep the register plain.** Drop stacked adjectives such as "supremely", "exquisitely",
    "magnificent" and "sublime" unless the Hindi has an equivalent. Canto 3 was ornate only where
    the grandfather's Hindi was.
14. **Keep the format uniform.** End each IV and V section with `(Verse N)` / `(N)`; pages
    106–110 omit this.

### 4.5 The `manuscript_note` apparatus

15. **Restrict it to paleography:** manuscript readings, corrections, strike-outs, marginalia,
    line breaks, and the metre with its scansion. No plot summary.
16. **Verify metre labels by scansion.** v16 (labelled Triṣṭubh/Upajāti, actually Rathoddhatā)
    and v63 (labelled Sragdharā/Mandākrāntā, actually Śārdūlavikrīḍita) are wrong.

### 4.6 Process

17. **Make the second copy genuinely independent.** The Hindi/Sanskrit in the English export
    should come from a separate reading (a separate run, without access to the first). The two
    can then be diffed, and every disagreement re-read against the scan. Otherwise, do not
    embed a second copy.
18. **Colophon.** Re-read vv. 64–66 on p118 against the p060 text in §2.4. The canto-specific
    fourth line of v66 must come from p118 itself. The same correction is due on canto 3's p086.
19. **Model tier.** GEMINI.md §7 mandates the flash tier for subagents. This canto shows the
    cost: transcription needs the strongest available vision model. Flash may be adequate for
    the English pass once the Hindi is sound.
20. **Keep the export format unchanged.** Keep dialect B exactly (`### श्लोक N`, `#### …`
    subsections, fenced ```` ```sanskrit ```` block, the italic note after the shlok) and the
    same filenames. `scripts/build_sarga4_transcripts.R` depends on them. Do not edit the
    `pNNN.yml` files; they are regenerated from the markdown.

## 5. What is good and should be kept

- Page segmentation, verse numbering and the two-verses-per-page layout are correct throughout.
- The handling of p107 v42, where no commentary was written, is correct and honest; the blank
  space is visible on the scan.
- The p089 struck-out draft is noticed and recorded rather than transcribed as a verse.
- IAST and proper nouns are consistent (Mṛkaṇḍu, Parāśara, Mudgala, Dardura, Aṅgiras).
- Where the source text is sound (v18, v26, v38, and most of v22–v38), the English is accurate
  and readable.
