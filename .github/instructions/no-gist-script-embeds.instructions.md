---
description: "Use when editing blog posts under _posts to prevent or remove embedded GitHub Gist script tags and replace them with static Jekyll highlight blocks plus a source link."
name: "No Gist Script Embeds In Posts"
applyTo: "_posts/**"
---
# No Gist Script Embeds In Posts

- Do not add or keep embedded GitHub Gist script tags in post content.
- Forbidden pattern: `<script src=\"https://gist.github.com/... .js\"></script>`.
- Convert each embed into static code blocks using the skill `inline-gist-to-jekyll-highlight`.
- For each Gist file, emit a Jekyll block using `{% highlight <language> linenos %}` and include the filename as the first language-appropriate comment line.
- Keep one normalized source link to the gist page URL (without `.js`) near the generated code blocks.

## Completion Check
- No remaining `<script ... gist.github.com ... .js></script>` in the edited post.
- At least one corresponding highlight block is present for each converted embed.
- A gist source anchor remains present for attribution.
