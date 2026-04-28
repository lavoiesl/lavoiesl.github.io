# Repository Skills

Project-local Copilot skills live under `.github/skills/`.

- `html-to-markdown-kramdown`: Convert legacy HTML pages into Jekyll-friendly Markdown while preserving unsupported constructs safely.
- `image-to-figure`: Convert legacy single-image markup in posts into Minimal Mistakes `{% include figure %}` helpers.
- `images-to-gallery`: Convert a group of two or more consecutive images in a post into a Minimal Mistakes `{% include gallery %}` helper with YAML front matter.
- `inline-gist-to-jekyll-highlight`: Replace embedded GitHub Gist script tags with static Jekyll highlight blocks and source links.
- `localize-remote-images`: Download remote post images into `assets/images/posts/<slug>/` and rewrite the post to use local asset paths.