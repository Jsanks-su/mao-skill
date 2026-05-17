# Selected Works Source Record

This directory contains text extracted from the user-supplied source repository:

- Source repository: https://github.com/M0rtzz/Selected-Works-of-MaoTseTung
- Source commit: `4cc981c232e1ffe8fe2974e125c00af8376829ca`
- Import script: `scripts/ingest-selected-works.ps1`
- Manifest: `MANIFEST.json`

## Import Policy

The knowledge base stores text, not images or binary editions.

Current import behavior:

- `.txt`, `.md`, and `.markdown` files are imported as full Markdown text.
- `.pdf`, `.doc`, `.docx`, and `.rtf` files are registered as Microsoft Word conversion candidates.
- image binaries are not stored in the text knowledge base.
- `.epub` and `.mobi` files are registered but not converted by the current script.

No summary-only replacement is used for imported text. The source text is preserved as body text with a small metadata header.

## Microsoft Conversion Note

The import script includes a `-ConvertWithWord` path that uses the locally installed Microsoft Word COM converter for `.pdf`, `.doc`, `.docx`, and `.rtf` files.

The full `毛泽东选集/毛泽东选集.txt` source already exists in the upstream repository and is imported directly as the canonical text copy. A test conversion of the large PDF variant through Word did not complete within the local timeout, so PDF/Office entries remain registered for controlled batch conversion instead of being marked as completed.

## Canonical Text Entry

The canonical imported Selected Works text is:

```text
references/history/selected-works-of-mao-tsetung/corpus/毛泽东选集/毛泽东选集.txt.md
```

Use this file as the primary full-text source before consulting PDF/Office variants.
