# Mahākāvya manuscript digitization

Digitizing a handwritten Sanskrit *mahākāvya* composed by my grandfather, from 32 photographed notebook pages, into a website preserving the original page structure (shlok, translation, and notes for each half-page).

## Status

- [x] Photos rotated to upright orientation, ordered by manuscript page number (`Images/pages/`)
- [x] Site generator + template built (`scripts/build_site.R`)
- [x] Sarga 1 (pages 1-32) and Sarga 2 (pages 33-60) transcribed, with English translations, and live
- [ ] Remaining sargas — in progress, added incrementally
- [x] Pushed to GitHub and published via GitHub Pages

## Transcription

Claude's own reading of the handwriting was tested and found unreliable for this particular cursive hand. Transcription is done via Google Lens / the antigravity tool instead. Once a page's Devanagari and (optionally) English translation text is available, structure it into `transcripts/Sarg_N/pNNN.yml` following the schema documented in `CLAUDE.md`, then regenerate the site.

## Building the site

```
Rscript scripts/build_site.R
node scripts/serve_docs.js   # preview at http://localhost:8731/
```

## Publishing

`docs/` is a fully static site, published via GitHub Pages (Settings -> Pages -> Deploy from a branch -> `main` -> `/docs`). Once published, adding a new sarga is just:

```
# 1. add/edit transcripts/Sarg_N/*.yml
Rscript scripts/build_site.R
git add -A
git commit -m "Add sarga N"
git push
```

GitHub Pages redeploys automatically from `docs/` on every push to `main` — no separate publish step needed.
