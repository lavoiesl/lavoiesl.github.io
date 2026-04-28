---
name: localize-remote-images
description: >
  Download remote images referenced in a Jekyll post, save them to
  assets/images/posts/<post-slug>/<filename>.<ext>, and rewrite the
  HTML/Markdown references to use the local path /assets/images/posts/....
  Use when a post hotlinks external images that should be self-hosted.
argument-hint: 'Path to the post file to process (e.g., _posts/2014-11-05-my-post.html)'
---

# Localize Remote Images

## When To Use
- A Jekyll post (`_posts/`) contains `<img src="https://...">` tags or Markdown `![alt](https://...)` that hotlink external images.
- You want to self-host those images under `assets/images/posts/` so the blog does not depend on third-party URLs.

## Inputs
- Target post file path (required).
- Optional: list of specific image URLs to process (default: all remote images in the file).

## Path Conventions
- **Post slug**: derived from the filename by stripping the leading date (`YYYY-MM-DD-`) and the extension.
  - Example: `_posts/2014-11-05-starting-text-editor.html` → slug = `starting-text-editor`
- **Local asset directory**: `assets/images/posts/<post-slug>/`
- **Public URL path**: `/assets/images/posts/<post-slug>/<filename>.<ext>`
- **Filename**: preserve the original remote filename and extension.
  - If the URL has no discernible filename (e.g., ends in `/` or has a query string), derive a short name from the alt text or the URL path, and keep the extension (`.png`, `.jpg`, `.gif`, `.webp`, etc.).
  - If extension is unknown, inspect the first few bytes or Content-Type header to determine the correct extension.

## Procedure

### 1. Discover Remote Images
Scan the target file for all remote image references:
- HTML: `<img src="http[s]://...">` (also `srcset` when present)
- Markdown: `![alt](http[s]://...)`

Build a list of `(url, alt, context)` tuples. Skip data URIs, relative paths, and paths that already start with `/assets/`.

### 2. Plan Local Paths
For each remote URL, compute:
- `<post-slug>` from the post filename.
- `<filename>.<ext>` from the URL (see Path Conventions above).
- `local_disk_path` = `assets/images/posts/<post-slug>/<filename>.<ext>` (relative to repo root).
- `local_url_path` = `/assets/images/posts/<post-slug>/<filename>.<ext>`.

If two URLs would map to the same filename, append a numeric suffix (`-2`, `-3`, etc.) to disambiguate.

### 3. Download Images
For each image, call the bundled helper script from the **repository root**:

```sh
.github/skills/localize-remote-images/download-image.sh "<url>" "<local_disk_path>"
```

The script:
- Creates the destination directory if missing.
- Downloads with `curl --fail --location`.
- Exits non-zero on any error.

**If a download fails:** log the failure, skip that image, and continue with the rest. Report all failures at the end.

### 4. Rewrite References
After successful downloads, replace each remote reference in the file:

- HTML `<img>`:
  - Replace `src="<remote-url>"` with `src="<local_url_path>"`.
  - Replace inside `srcset` as well when present.
  - Do not modify any other attributes.
- Markdown `![alt](<remote-url>)`:
  - Replace `(<remote-url>)` with `(<local_url_path>)`.
  - Preserve the alt text exactly.
- Anchor-wrapped images `<a href="..."><img src="..."></a>`:
  - Rewrite only the `<img src>`, not the `<a href>`.

Apply replacements in a single pass (use `multi_replace_string_in_file` when possible).

### 5. Report
After all changes, output a summary table:

| Remote URL | Local Path | Status |
|------------|-----------|--------|
| https://... | /assets/images/posts/.../foo.png | saved |
| https://... | — | failed (reason) |

## Quality Checks
- [ ] No remote `http[s]://` image URLs remain in the file after processing (except any that failed to download).
- [ ] Every saved file exists on disk at the expected path.
- [ ] No other attributes or content were modified.

## Error Handling
- Redirect loops, 404s, or timeouts from `curl`: report as failed, skip.
- Filename collision: append numeric suffix before retrying.
- Write permission error: abort and report.
