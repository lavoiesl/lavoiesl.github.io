---
name: inline-gist-to-jekyll-highlight
description: 'Inline embedded GitHub Gists in Jekyll posts by replacing script tags with {% highlight ... linenos %} blocks and a View Gist link. Use when converting <script src="https://gist.github.com/...js"></script> embeds into static, readable code blocks with per-file language detection and filename comments.'
argument-hint: 'Path to the post or markdown/html file to convert'
---

# Inline Gist To Jekyll Highlight

## When To Use
- A Jekyll post contains one or more embedded Gist script tags.
- You want code visible in-page without client-side script execution.
- You want syntax highlighting with line numbers and a retained source link.

## Inputs
- Target file path (for example, a file in _posts).
- Optional override for language mapping rules.

## Tooling Policy (No Authorization Prompts)
- Default to agent-native web retrieval tools for Gist API access.
- Do not use terminal commands like `curl` or `jq` for normal conversions.
- Preferred retrieval call:
   - URL: `https://api.github.com/gists/<gist-id>`
   - Use a web-fetch tool and parse JSON in-agent.
- Use shell commands only when explicitly requested by the user or when the fetch tool is unavailable.
- If shell fallback is required, use a single minimal command and explain why.

## Procedure
1. Find each embedded Gist script tag.
2. Extract the Gist URL and normalize it:
   - From: https://gist.github.com/<owner>/<gist-id>.js
   - To: https://gist.github.com/<owner>/<gist-id>
3. Fetch the Gist metadata and files from the GitHub API:
   - GET https://api.github.com/gists/<gist-id>
   - Use non-shell web-fetch tooling first to avoid authorization prompts.
4. Identify files to convert:
   - Include all files in the Gist by default.
   - Keep the file order returned by the API unless the user requests a custom order.
5. For each Gist file, capture:
   - filename
   - language (from API language first; fallback from extension)
   - content
6. Build one Jekyll block per file:
   - Start: {% highlight <language> linenos %}
   - For PHP files: Place the opening `<?php` tag first, then the filename comment on the next line.
   - For all other languages: First content line must be the filename as a language-appropriate comment.
   - Then append the remaining file content exactly as fetched.
   - End: {% endhighlight %}
7. Replace the original script tag with:
   - <a href="https://gist.github.com/<owner>/<gist-id>">...</a>
   - Link text policy: preserve existing/custom text when available; otherwise use `View Gist`.
8. Insert the generated highlight block(s) at the script tag location, before the link.
9. Preserve surrounding Markdown/HTML formatting and spacing as much as possible.

## Filename Comment Conventions
- C-like (c, cpp, csharp, css, go, java, javascript, js, kotlin, php, rust, scala, swift, typescript, ts): // filename
- Shell/YAML/Python/Ruby/Perl/R/Makefile/TOML (bash, shell, sh, zsh, yaml, yml, python, py, ruby, rb, perl, pl, r, makefile, toml): # filename
- SQL/Lua/Haskell/Ada: -- filename
- HTML/XML/Markdown: <!-- filename -->
- Lisp family: ; filename
- Unknown text fallback: # filename

**PHP-specific rule:** For PHP files, the `<?php` opening tag must appear first, followed by the filename comment on the next line:
```
{% highlight php linenos %}
<?php
// filename.php
```

## Language Mapping Rules
- Prefer API `language` when present.
- Normalize to Jekyll/Rouge-friendly identifiers (examples):
  - JavaScript -> javascript
  - TypeScript -> typescript
  - C# -> csharp
  - Shell -> bash
  - HTML -> html
  - Markdown -> markdown
- If API language is null, infer from extension.
- If still unknown, use `text`.

## Quality Checks
- Every converted script tag has:
   - At least one {% highlight ... linenos %} block
   - An anchor with the normalized non-.js URL and expected link text policy
- Every block includes a filename comment line before code.
- Content is byte-for-byte equivalent to Gist file content (except inserted filename comment line).
- No remaining matching Gist script tag for converted entries.

## Edge Cases
- Single-file gist: one highlight block + one link.
- Multi-file gist: multiple highlight blocks (one per file) + one link.
- Missing or failed fetch:
  - Stop conversion for that embed.
  - Leave original script tag untouched.
  - Report the failure with gist id and reason.
- Truncated content from API:
  - Refetch via `raw_url` for full content.

## Fallback Strategy
- First attempt: web-fetch tool against Gist API URL.
- Second attempt: web-fetch tool against each `raw_url` for files marked truncated.
- Last resort: shell retrieval only if web-fetch is unavailable or failing, and only after noting that this may trigger user authorization.

## Example
Input:

<script src="https://gist.github.com/lavoiesl/0ac2d841b07ea122bfd0.js"></script>

Output:

{% highlight php linenos %}
<?php
// file.php
echo 1;
{% endhighlight %}
<a href="https://gist.github.com/lavoiesl/0ac2d841b07ea122bfd0">View Gist</a>

If custom text already exists, keep it:

<a href="https://gist.github.com/lavoiesl/0ac2d841b07ea122bfd0">Original Source</a>
