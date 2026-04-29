---
name: html-to-markdown-kramdown
description: 'Convert HTML pages to Jekyll-compatible Markdown (kramdown + Rouge) while preserving unsupported constructs as HTML. Use when migrating legacy HTML content to Markdown with strict safety rules for unsupported tags, simple table conversion, and span/style normalization.'
argument-hint: 'Path to the HTML or Markdown file to convert, plus optional strictness notes'
---

# HTML To Markdown (Kramdown + Rouge)

## Outcome
Clean, readable Markdown for content fully representable in Jekyll kramdown; unsupported or ambiguous HTML is preserved exactly as-is.

## When To Use
- Migrating old HTML posts/pages to Markdown for Jekyll.
- Reducing HTML noise without changing meaning.

## Implementation

**Always use the scripts in this skill directory — do not write ad-hoc conversion code.**

### Requirements
- Ruby 2.7+
- Nokogiri gem (in Gemfile or: `gem install nokogiri`)

### Scripts
- `html_to_markdown.rb` — Converts HTML to Markdown using Nokogiri
- `validate_conversion.rb` — Verifies no content was lost and checks for trivial leftover HTML tags (`<a>`, `<br>`)

### Workflow

```bash
# Convert
ruby .github/skills/html-to-markdown-kramdown/html_to_markdown.rb input.html output.md

# Validate (must pass before accepting the result)
# On success, this deletes input.html automatically.
ruby .github/skills/html-to-markdown-kramdown/validate_conversion.rb input.html output.md

# Optional: keep the original HTML file
ruby .github/skills/html-to-markdown-kramdown/validate_conversion.rb input.html output.md --keep-source
```

### Non-Interactive Terminal Rule

- Keep this workflow to the two Ruby commands above.
- Do not add extra `rg`/`grep` absence checks where exit code `1` means "no matches".
- For this skill, all expected-success commands should exit with code `0`.
- Source HTML deletion is handled by `validate_conversion.rb` after successful validation.

The scripts use Nokogiri for safe DOM parsing. Never use regex on raw HTML — it silently loses URLs, link text, inline code, and nested content.

## Conversion Rules

### Convert → Markdown

| HTML | Markdown |
|------|----------|
| `<h1>`–`<h6>` | `#`–`######` |
| `<p>` | paragraph (blank line between) |
| `<strong>`, `<b>` | `**text**` |
| `<em>`, `<i>` | `_text_` |
| `<a href="url">text</a>` | `[text](url)` — URL and text must be exact |
| `<code>text</code>` | `` `text` `` |
| `<pre><code>…</code></pre>` | fenced block (` ``` `), normalize language alias |
| `<ul>/<ol>/<li>` | `- item` / `1. item`, preserve nesting depth and keep nested items tight (no blank lines between list items unless a single item contains multiple paragraphs) |
| `<img src="…" alt="…">` | `![alt](src)` — drop presentational attrs |
| Simple `<table>` | GFM pipe table |
| `<span style="font-family: Courier New…">text</span>` | `` `text` `` |
| `<span style="font-family: inherit;">text</span>` | unwrap, keep text |
| Separator `<div class="separator">` | `---` |
| Plain `<div>...</div>` wrapper | unwrap, keep inner content |

Headings in output Markdown must be separated from preceding paragraph text by an empty line so they are parsed as headings by Markdown renderers.

Lists in output Markdown must be emitted as tight lists by default. Nested items should render like:

```markdown
- Foo
	- Bar
	- Baz
- Qux
```

### Keep As HTML

- `<script>`, `<style>`, embedded widgets, custom components.
- Tables with `rowspan`/`colspan`, nested tables, layout wrappers.
- Any element where conversion would lose meaning or structure.
- `<pre>` blocks with mixed markup inside.

### Language Alias Normalisation (code blocks)
`js` → `javascript` · `ts` → `typescript` · `sh` → `bash` · `py` → `python`

## Completion Criteria
- Zero content loss: every link URL, anchor text, emphasis, inline code, and list item from the source is present in the output.
- `validate_conversion.rb` exits with no errors.
- No trivial leftover HTML tags (`<a>`, `<br>`) remain in converted Markdown unless intentionally preserved.
- No plain wrapper `<div>` tags remain in converted Markdown unless intentionally preserved for unsupported constructs.
- Source `.html` file is deleted after successful validation (unless `--keep-source` is provided).
- Remaining HTML is intentional (unsupported constructs only).
- Output is valid Jekyll kramdown and Rouge-compatible.
