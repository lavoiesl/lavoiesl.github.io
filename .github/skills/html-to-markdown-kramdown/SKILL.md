---
name: html-to-markdown-kramdown
description: 'Convert HTML pages to Jekyll-compatible Markdown (kramdown + Rouge) while preserving unsupported constructs as HTML. Use when migrating legacy HTML content to Markdown with strict safety rules for unsupported tags, simple table conversion, and span/style normalization.'
argument-hint: 'Path to the HTML or Markdown file to convert, plus optional strictness notes'
---

# HTML To Markdown (Kramdown + Rouge)

## Outcome
Produce clean, readable Markdown for content that is fully representable in Markdown supported by Jekyll kramdown, while preserving unsupported or ambiguous HTML exactly.

## When To Use
- Migrating old HTML pages/posts to Markdown for Jekyll.
- Reducing HTML noise without changing meaning.
- Keeping browser-dependent or non-Markdown elements in raw HTML.

## Conversion Policy
- Convert only when there is an exact Markdown equivalent supported by kramdown.
- If conversion would lose semantics or structure, keep the original HTML.
- Treat unsupported elements (for example `<script>`) as non-convertible and preserve them as HTML.

## Decision Flow
1. Parse the document block-by-block (headings, paragraphs, lists, tables, inline spans, separators, code).
2. For each element, decide:
   - Exact Markdown support exists: convert.
   - Support is partial/ambiguous or needs non-standard extensions: keep as HTML.
3. Apply special normalization rules for known span/div patterns.
4. Run quality checks and stop if unsafe conversions are detected.

## Element Rules

### Headings, Paragraphs, Links, Emphasis, Lists
- Convert standard HTML headings (`<h1>`-`<h6>`) to `#`-style headings.
- Convert `<p>` to Markdown paragraphs.
- Convert `<a>` to Markdown links when href/text mapping is direct.
- Ignore `target="_blank"` when converting links.
- Convert `<strong>/<b>` and `<em>/<i>` to Markdown emphasis.
- Convert `<ul>/<ol>/<li>` to Markdown lists when nesting maps cleanly.

### Images
- Always convert `<img>` to Markdown image syntax.
- Preserve meaningful `alt` text when present; if missing, use an empty alt (`![](...)`).
- Ignore presentational attributes/styles (for example `width`, `height`, `style`, `class`) in Markdown output.

### Code
- Convert inline `<code>` to backticks.
- Convert `<pre><code>` blocks to fenced code blocks.
- Use fenced code blocks compatible with Rouge highlighting.
- Preserve language hints when present and normalize aliases to Rouge-friendly names when possible (for example `js` -> `javascript`, `ts` -> `typescript`, `sh` -> `bash`, `py` -> `python`).

### Tables
- Convert only simple HTML tables to Markdown tables.
- Simple table criteria:
  - Straight header/body row structure.
  - No merged cells (`rowspan`/`colspan`).
  - No nested tables.
  - No layout-only wrappers required for meaning.
- Ignore minor stylistic differences such as text alignment during conversion.
- If advanced markup is present, keep the entire table as HTML.

### Spans And Font Rules
- Monospace style spans:
  - Pattern example: `<span style="font-family: Courier New, Courier, monospace;">text</span>`
  - Convert contents to inline code: `` `text` ``
- Inherit font spans:
  - Pattern example: `<span style="font-family: inherit;">text</span>`
  - Remove wrapper and keep only contents.
- If styling does not change text semantics, drop styling and keep plain Markdown text.
- If styling carries semantics that cannot be represented in Markdown, keep HTML.

### Separators
- Convert separator blocks like:
  - `<div class="separator" style="clear: both; text-align: center;"> ... </div>`
- Replace with a standard Markdown thematic break:
  - `---`
- If separator div also carries meaningful non-separator content, keep HTML.

### Unsupported Or Risky HTML
- Preserve as HTML when no exact Markdown equivalent exists, including:
  - `<script>`, `<style>`, embedded widgets, custom components, complex interactive markup.
- Do not attempt approximate rewrites for unsupported behavior.

## Procedure
1. Identify target file and scan for obvious non-convertible blocks first (`<script>`, advanced tables, embeds).
2. Convert clearly supported block-level elements.
3. Convert supported inline elements (including links and images), then apply span normalization rules.
4. Convert simple tables only after validating criteria.
5. Keep all non-convertible structures in HTML.
6. Review final content for accidental semantic drift.

## Quality Checks
- No unsupported constructs are force-converted.
- `<script>` and similar non-Markdown elements remain HTML.
- Anchor conversion ignores `target="_blank"` and keeps standard Markdown link syntax.
- `<img>` elements are converted to Markdown images.
- Monospace font spans are converted to inline backticks.
- `font-family: inherit` spans are unwrapped.
- Non-semantic styles are dropped instead of preserved as HTML.
- Separator div patterns become `---` when safe.
- Simple tables become Markdown tables; advanced tables remain HTML.
- Fenced code block language aliases are normalized to Rouge-friendly names.
- Output is valid for Jekyll with kramdown and compatible with Rouge code highlighting.

## Completion Criteria
- Conversion is conservative and reversible in intent.
- Markdown readability improves without changing document meaning.
- Remaining HTML is intentional and justified by unsupported syntax.
