---
name: images-to-gallery
description: >
  Convert a group of two or more consecutive images in a Jekyll post into a
  Minimal Mistakes `{% include gallery %}` helper with YAML front matter.
  Use when a post contains multiple adjacent `<img>` tags, anchor-wrapped images,
  or Markdown images that should become a single inline gallery.
argument-hint: 'Path to the post file to process (for example _posts/2014-10-08-my-post.html)'
---

# Images To Gallery

## When To Use
- A post in `_posts/` contains two or more consecutive single images that belong together visually.
- You want to replace the group with the Minimal Mistakes `{% include gallery %}` helper and a YAML front matter `gallery:` array.

## Inputs
- Target post file path (required).
- Optional: name to use for the gallery key in front matter (default: `gallery`; use a unique name like `gallery2` when the post already has a `gallery` key).
- Optional: overall gallery caption text.

## If Unclear, Ask
- If the post contains more than one group of consecutive images, list the groups and ask which one to convert. Do not default to converting all groups.
- If the user did not specify a gallery key name and the front matter already contains `gallery:`, ask for a unique name before proceeding.
- If two or more images share the same source path, ask whether that is intentional before including duplicates.

## Gallery Mapping Rules

### Per-image entry (YAML array item under `gallery:`)
| YAML field | Source | Required |
|------------|--------|----------|
| `image_path` | image `src` or Markdown target, copied verbatim | Yes |
| `url` | anchor `href` when the image is wrapped in a link to a different or larger image | No |
| `alt` | existing `alt` attribute or Markdown alt text, copied verbatim | No |
| `title` | visible caption text adjacent to that image, if any | No |

- Use `image_path` exactly as it appears in the source. Remote URLs stay remote; local paths stay local.
- Set `url` only when the original anchor target differs from `image_path` (i.e., links to a larger image or an external page). When the anchor links to the same image, omit `url` — the theme handles popup behavior via the include tag, not the front matter.
- Omit any field for which no source value exists. Do not invent alt text, titles, or URLs.

### Include tag parameters
| Parameter | When to use |
|-----------|-------------|
| `id="<key>"` | When the gallery key is not the default `gallery` |
| `layout="half"` | Force 2-column layout (theme default for 2 images) |
| `layout="third"` | Force 3-column layout (theme default for 3+ images) |
| `caption="..."` | When a single overall caption applies to the whole gallery |
| `class="..."` | When additional CSS classes are needed on the figure element |

The theme automatically picks `half` for 2 items and `third` for 3 or more, so omit `layout` unless overriding the default.

## Procedure

### 1. Identify The Candidate Group
Find two or more consecutive single-image blocks that form a visual group:
- HTML `<img>` or anchor-wrapped `<img>` elements with no prose between them (whitespace and `<br />` only between them counts as consecutive).
- Adjacent Markdown images on separate lines with no prose between them.
- Mixed HTML/Markdown images in direct sequence.

A single isolated image is not a gallery candidate — use the `image-to-figure` skill instead.

### 2. Extract Per-Image Data
For each image in the group, collect:
- `image_path` from `src` or Markdown target
- `url` from anchor `href` when it differs from `image_path`
- `alt` from `alt` attribute or Markdown alt text
- `title` from an adjacent visible caption element or text node

### 3. Build The Front Matter Entry
Add or append to the post's YAML front matter:

```yaml
gallery:
  - image_path: /assets/images/posts/post-slug/photo1.jpg
    alt: "First photo alt text"
    title: "Optional per-image caption"
  - image_path: /assets/images/posts/post-slug/photo2.jpg
    url: /assets/images/posts/post-slug/photo2-large.jpg
    alt: "Second photo alt text"
```

When appending to existing front matter, add `gallery:` (or the chosen key) after the last existing key, before the closing `---`.

### 4. Replace The Image Group With The Include Tag
Replace the entire consecutive image block (including wrapper `<div>` elements and spacer `<br />` runs) with the gallery include:

```liquid
{% include gallery %}
```

With optional parameters when needed:

```liquid
{% include gallery id="gallery2" caption="Photos from the event." %}
```

### 5. Clean Up Surrounding Markup
After inserting the include:
- Remove now-empty wrapper `<div>` elements that contained only the images.
- Collapse any remaining redundant `<br />` runs left by the old editor.
- Preserve nearby headings, list items, and prose.
- Do not rewrite unrelated HTML elsewhere in the post.

## Completion Checks
- [ ] Front matter contains the `gallery:` array with one entry per converted image.
- [ ] Every `image_path` value matches the original `src` exactly (no alterations).
- [ ] `url` is present only for images that had an anchor pointing to a different target.
- [ ] The original image block is fully removed from the post body.
- [ ] The `{% include gallery %}` tag is in place with correct parameters.
- [ ] No alt text, title, or URL was invented without user approval.
- [ ] No prose or structural HTML outside the image group was modified.

## Examples

### Two Anchor-Wrapped Screenshots

From:

```html
<div class="separator" style="clear: both; text-align: center;">
  <a href="/assets/images/posts/post-slug/screen1-full.png" imageanchor="1">
    <img border="0" src="/assets/images/posts/post-slug/screen1-th.png" height="302" width="320" />
  </a>
  <a href="/assets/images/posts/post-slug/screen2-full.png" imageanchor="1">
    <img border="0" src="/assets/images/posts/post-slug/screen2-th.png" height="302" width="320" />
  </a>
</div>
```

Front matter addition:

```yaml
gallery:
  - image_path: /assets/images/posts/post-slug/screen1-th.png
    url: /assets/images/posts/post-slug/screen1-full.png
  - image_path: /assets/images/posts/post-slug/screen2-th.png
    url: /assets/images/posts/post-slug/screen2-full.png
```

Body replacement:

```liquid
{% include gallery %}
```

### Three Markdown Images With Alt Text

From:

```markdown
![Dashboard overview](/assets/images/posts/post-slug/dash.png)
![Settings panel](/assets/images/posts/post-slug/settings.png)
![User profile](/assets/images/posts/post-slug/profile.png)
```

Front matter addition:

```yaml
gallery:
  - image_path: /assets/images/posts/post-slug/dash.png
    alt: "Dashboard overview"
  - image_path: /assets/images/posts/post-slug/settings.png
    alt: "Settings panel"
  - image_path: /assets/images/posts/post-slug/profile.png
    alt: "User profile"
```

Body replacement:

```liquid
{% include gallery caption="Screenshots from the application." %}
```
