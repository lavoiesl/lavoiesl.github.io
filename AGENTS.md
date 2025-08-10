# Repository Guidelines

## Project Structure & Module Organization

- `_posts/`: Blog posts as `YYYY-MM-DD-slug.md` with YAML front matter.
- `_pages/`: Standalone pages (home, archives) with front matter and `permalink`.
- `assets/`: Static assets (e.g., `assets/images/`). Reference via `/assets/images/...`.
- `_data/`: Site data (navigation, authors) in YAML.
- `_config.yml`: Site/theme configuration (Minimal Mistakes via `remote_theme`).
- `.tools/import.rb`: Import script for migrating posts.
- `_site/`: Build output. Do not edit by hand.

## Build, Test, and Development Commands

- `ruby -v`: Ensure Ruby `3.2.2` (see `.ruby-version`).
- `bundle install`: Install gems (includes `github-pages`, `webrick`).
- `bundle exec jekyll serve --livereload`: Run locally at `http://localhost:4000` with auto-reload.
- `bundle exec jekyll build`: Produce static site into `_site/`.
- `bundle exec jekyll doctor`: Sanity-check configuration and content.

## Coding Style & Naming Conventions

- Markdown + YAML: 2-space indentation. Include `layout`, `title`, `date`, optional `tags`.
- Post filenames: `YYYY-MM-DD-my-post.md` in `_posts/` (date should match front matter).
- Pages: Place in `_pages/` and set a clear `permalink` (e.g., `/tags/`).
- Assets: Put images in `assets/images/`; reference with absolute paths (e.g., `![Alt](/assets/images/pong.gif)`).
- Ruby scripts: 2-space indentation; keep scripts in `.tools/`.

## Testing Guidelines

- No unit test suite. Validate by:
  - Building locally (`bundle exec jekyll build`) and scanning for warnings.
  - Manually verifying pages, navigation, and post metadata.
  - Optionally running `bundle exec jekyll doctor` to catch common issues.

## Commit & Pull Request Guidelines

- Commits: Small, focused, imperative present (e.g., "Add post on X", "Fix nav link").
- PRs: Clear description of what changed and why; include before/after screenshots or local URLs for visual changes.
- Links/Issues: Reference related posts or issues when relevant.
- Generated files: Do not edit `_site/`; commit source changes only.

## Security & Configuration Tips

- Do not commit secrets; this is a public static site.
- Changes to `_config.yml` require restarting `jekyll serve`.
- Theme is pinned via `remote_theme: mmistakes/minimal-mistakes@4.24.0`; update intentionally and test locally before merging.

## How to Publish

- This is a user site (`lavoiesl.github.io`), so GitHub Pages serves the default branch automatically.
- Publish by pushing to `main`; GitHub builds with the `github-pages` gem. Do not commit `_site/`.
- If a remote build fails, check Pages/Actions logs, verify locally with `bundle exec jekyll build`, then retry.
- When changing theme or plugins, test locally and in a temporary branch before merging to `main`.
