# Canto 5: blind second opinion on 38 crops

These crops are for an independent reader, such as a paid Gemini model. Each crop shows one whole Sanskrit verse (four pādas, one per line) from a handwritten notebook in personal cursive Devanagari. The reader gets no reading from us, so that it is not anchored.

**How to use.** Upload the 38 `.jpg` files in this folder together with the prompt below. If the model accepts fewer images at a time, send them in batches; keep the prompt and send the matching rows of the table. Save its answers as `answers_<model>.md` in this folder. Claude then compares them with its own reading (CLAUDE.md, step 5).

The crops are regenerated from `spec.csv` with `scripts/tools/second_opinion_crops.ps1 -spec second_opinion\canto5\spec.csv`. They are not committed.

---

## Prompt (copy from here)

You are reading a handwritten Sanskrit poem in personal cursive Devanagari. Each attached image shows one verse, written as four lines (pādas). Several lines may also show the page's verse number above, or the start of a Hindi translation below. Ignore those.

For each image, transcribe **only the pādas listed in the table**, letter by letter, in Devanagari. Rules:

1. Transcribe what is written. Do not correct it towards a verse you know, and do not fill gaps from memory.
2. Where a letter is uncertain, give your best reading followed by the alternatives in brackets, e.g. `प्र(प्य/ह्य)`.
3. Note any struck-out letters, letters added above the line, or marginal additions.
4. The metre is given as a check. Light (।) and heavy (ऽ) syllables must fit it, but **report the written text even if it does not fit**, and say that it does not.
5. Scribal habits: initial "ह्य" is written so that it looks like "प्य"; the cursive "७" looks like a Latin "6".

Metres:
- Drutavilambita: ।।। ऽ।। ऽ।। ऽ।ऽ (12 syllables).
- Sragdharā: ऽऽऽऽ।ऽऽ ।।।।।।ऽ ऽ।ऽऽ।ऽऽ (21 syllables).
- Mālinī: ।।।।।।ऽऽ ऽ।ऽऽ।ऽऽ (15 syllables).
- Svāgatā: ऽ।ऽ ।।। ऽ।। ऽऽ (11 syllables).

Answer in this format, one block per image:

```
NN (page P, verse V)
pāda k: <transcription>   [confidence: high/medium/low; notes]
```

| # | file | page | verse | pādas to read | metre |
|---|---|---|---|---|---|
| 01 | `01_p119_v1.jpg` | 119 | 1 | 1, 4 | Drutavilambita |
| 02 | `02_p119_v2.jpg` | 119 | 2 | 3, 4 | Drutavilambita |
| 03 | `03_p120_v3.jpg` | 120 | 3 | 1 | Drutavilambita |
| 04 | `04_p120_v4.jpg` | 120 | 4 | 4 | Drutavilambita |
| 05 | `05_p121_v6.jpg` | 121 | 6 | 3 | Drutavilambita |
| 06 | `06_p122_v8.jpg` | 122 | 8 | 2 | Drutavilambita |
| 07 | `07_p123_v10.jpg` | 123 | 10 | 2, 4 | Drutavilambita |
| 08 | `08_p125_v13.jpg` | 125 | 13 | 2 | Drutavilambita |
| 09 | `09_p126_v15.jpg` | 126 | 15 | 2 | Drutavilambita |
| 10 | `10_p128_v19.jpg` | 128 | 19 | 2, 4 | Drutavilambita |
| 11 | `11_p128_v20.jpg` | 128 | 20 | 2 | Drutavilambita |
| 12 | `12_p130_v23.jpg` | 130 | 23 | 3, 4 | Drutavilambita |
| 13 | `13_p130_v24.jpg` | 130 | 24 | 1 | Drutavilambita |
| 14 | `14_p131_v26.jpg` | 131 | 26 | 4 | Drutavilambita |
| 15 | `15_p132_v27.jpg` | 132 | 27 | 2, 3, 4 | Drutavilambita |
| 16 | `16_p135_v33.jpg` | 135 | 33 | 2 | Drutavilambita |
| 17 | `17_p135_v34.jpg` | 135 | 34 | 1, 2 | Drutavilambita |
| 18 | `18_p136_v36.jpg` | 136 | 36 | 2 | Drutavilambita |
| 19 | `19_p137_v37.jpg` | 137 | 37 | 2, 3 | Drutavilambita |
| 20 | `20_p137_v38.jpg` | 137 | 38 | 3, 4 | Drutavilambita |
| 21 | `21_p138_v39.jpg` | 138 | 39 | 3 | Drutavilambita |
| 22 | `22_p138_v40.jpg` | 138 | 40 | 1 | Drutavilambita |
| 23 | `23_p139_v41.jpg` | 139 | 41 | 3 | Drutavilambita |
| 24 | `24_p140_v43.jpg` | 140 | 43 | 4 | Drutavilambita |
| 25 | `25_p141_v46.jpg` | 141 | 46 | 2, 4 | Drutavilambita |
| 26 | `26_p142_v48.jpg` | 142 | 48 | 2 | Drutavilambita |
| 27 | `27_p143_v49.jpg` | 143 | 49 | 4 | Drutavilambita |
| 28 | `28_p143_v50.jpg` | 143 | 50 | 4 | Drutavilambita |
| 29 | `29_p144_v52.jpg` | 144 | 52 | 2, 3 | Sragdharā |
| 30 | `30_p145_v54.jpg` | 145 | 54 | 1 | Drutavilambita |
| 31 | `31_p146_v56.jpg` | 146 | 56 | 3 | Drutavilambita |
| 32 | `32_p147_v58.jpg` | 147 | 58 | 2 | Drutavilambita |
| 33 | `33_p148_v59.jpg` | 148 | 59 | 3 | Drutavilambita |
| 34 | `34_p149_v61.jpg` | 149 | 61 | 3 | Drutavilambita |
| 35 | `35_p150_v63.jpg` | 150 | 63 | 1 | Drutavilambita |
| 36 | `36_p150_v64.jpg` | 150 | 64 | 1 | Drutavilambita |
| 37 | `37_p151_v66.jpg` | 151 | 66 | 2 | Mālinī |
| 38 | `38_p152_v69.jpg` | 152 | 69 | 3 | Svāgatā |
