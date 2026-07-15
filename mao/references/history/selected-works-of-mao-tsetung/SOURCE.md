# Selected Works Source Record

This directory contains text extracted from the user-supplied source repository:

- Source repository: https://github.com/M0rtzz/Selected-Works-of-MaoTseTung
- Source commit: `4cc981c232e1ffe8fe2974e125c00af8376829ca`
- Import script: `scripts/ingest-selected-works.ps1`
- Converter requirement: `requirements-markitdown.txt`
- Manifest: `MANIFEST.json`

## Import Policy

The knowledge base stores text, not images or binary editions.

Current import behavior:

- `.txt`, `.md`, and `.markdown` files are imported as full Markdown text.
- `.pdf`, `.doc`, `.docx`, `.rtf`, `.pptx`, `.xlsx`, `.epub`, `.mobi`, HTML, and image files are registered as Microsoft MarkItDown conversion candidates.
- MarkItDown output is cleaned so Markdown image embeds and HTML image tags are not stored in the text knowledge base.

No summary-only replacement is used for imported text. The source text is preserved as body text with a small metadata header.

## MarkItDown Conversion Note

The import script includes a `-ConvertWithMarkItDown` path that uses Microsoft's MarkItDown package for document-to-Markdown conversion:

```powershell
python -m pip install -r requirements-markitdown.txt
powershell -ExecutionPolicy Bypass -File .\scripts\ingest-selected-works.ps1 -ConvertWithMarkItDown -ConvertPath "毛泽东选集/毛泽东选集.docx" -MaxMarkItDownConversions 1
```

The full `毛泽东选集/毛泽东选集.txt` source already exists in the upstream repository and is imported directly as the canonical text copy. MarkItDown conversion is used for document variants that need structure extraction, such as DOCX/PDF/EPUB. Large files should be converted in controlled batches and marked imported only after the script completes successfully.

## Canonical Text Entry

The canonical imported Selected Works text is:

```text
references/history/selected-works-of-mao-tsetung/corpus/毛泽东选集/毛泽东选集.txt.md
```

Use this file as the primary full-text source before consulting PDF/Office variants.
