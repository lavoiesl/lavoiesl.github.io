---
name: image-to-figure
description: >
  Convert image markup in Jekyll posts into Minimal Mistakes `{% include figure %}`
  helpers. Use when a post contains `<img>`, anchor-wrapped images, or Markdown
  images that should become a single-image figure with optional caption and popup.
argument-hint: 'Path to the post file to process (for example _posts/2014-10-08-my-post.html)'
---

# Image To Figure

## When To Use
- A post in `_posts/` contains legacy image markup such as raw `<img>` tags, Blogger-style separator blocks, or anchor-wrapped screenshots.
- You want to normalize one or more images into the Minimal Mistakes figure helper instead of leaving presentational HTML in the post body.

## Inputs
- Target post file path (required).
- Optional: which image block to convert when the post contains more than one candidate.
- Optional: preferred caption text when the existing markup does not already provide one.

## If Unclear, Ask
- If more than one image block exists and the user did not explicitly request all, list the candidates and ask which one(s) to convert. Do not default to converting all.
- If the existing markup does not contain reliable alt text or caption text, ask whether to add one. Safe default: preserve the image without inventing new descriptive text.

## Figure Mapping Rules
- `image_path` is required. Use the `src` value exactly as it appears in the source — whether a local absolute path like `/assets/images/posts/<slug>/<file>.png` or a remote URL. Do not alter or localize it.
- `alt` is optional. Preserve existing alt text exactly when present. If the source has no usable alt text, omit the parameter rather than inventing one.
- `caption` is optional. Use nearby visible caption text when the post already has it. Markdown is allowed inside the caption.
- `popup=true` is optional. Use it when the original image was clickable to the same image or to a larger version of that image.
- Drop purely presentational attributes and wrappers such as `width`, `height`, `border`, `style`, `imageanchor`, `class="separator"`, and centering `<div>` containers.

## Procedure

### 1. Identify The Candidate Block
Find the smallest self-contained block that renders one image:
- Plain HTML image: `<img ... />`
- Anchor-wrapped image: `<a href="..."><img ... /></a>`
- Blogger separator wrapper around one image
- Markdown image: `![alt](path)`

Treat surrounding explanatory text as content to preserve, not part of the image block.

### 2. Extract Figure Data
Collect the values needed for the include:
- `image_path` from the image `src` or Markdown target
- `alt` from the existing `alt` attribute or Markdown alt text
- `caption` from existing visible caption text, if any
- `popup=true` when the original markup linked the image to itself or a larger image

If the anchor target is unrelated to the image itself, do not turn it into `popup=true`; preserve the link separately or ask before removing it.

### 3. Normalize Before Replacing
Before writing the include:
- Confirm the candidate block represents one image, not a gallery or figure with multiple assets.
- Remove line-break-only wrappers such as `<br />` that exist only to space the image block.
- Do not alter the image path. Remote URLs stay remote; local paths stay local.

### 4. Replace With Figure Include
Replace the original image block with the smallest equivalent Minimal Mistakes helper:

```liquid
{% include figure image_path="/assets/images/example.png" %}
```

Add optional parameters only when justified by the source markup:

```liquid
{% include figure
  popup=true
  image_path="/assets/images/example.png"
  alt="Screenshot of VMware Fusion network settings"
  caption="Custom network settings with DHCP enabled for the host."
%}
```

Keep the include on one line when it stays readable. Split across lines only when several parameters make the line hard to scan.

### 5. Clean Up The Surrounding Markup
After inserting the include:
- Remove now-empty wrapper `<div>` elements.
- Collapse redundant `<br />` runs introduced by the old editor.
- Preserve nearby headings, list items, and prose.
- Do not rewrite unrelated HTML in the same post.

## Completion Checks
- [ ] The old image block is fully removed and replaced by one `{% include figure %}`.
- [ ] `image_path` points to the intended image and uses an absolute path.
- [ ] `popup=true` is present only when the old image was explicitly clickable.
- [ ] No presentational wrapper tags remain around that converted image.
- [ ] No caption or alt text was invented without user approval.

## Examples

### Anchor-Wrapped Screenshot

From:

```html
<div class="separator" style="clear: both; text-align: center;">
  <a href="/assets/images/posts/post-slug/screenshot.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;">
    <img border="0" src="/assets/images/posts/post-slug/screenshot.png" height="302" width="320" />
  </a>
</div>
```

To:

```liquid
{% include figure popup=true image_path="/assets/images/posts/post-slug/screenshot.png" %}
```

### Plain Markdown Image With Caption Text Nearby

From:

```markdown
![Network settings](/assets/images/posts/post-slug/settings.png)

Custom network settings with DHCP enabled for the host.
```

To:

```liquid
{% include figure image_path="/assets/images/posts/post-slug/settings.png" alt="Network settings" caption="Custom network settings with DHCP enabled for the host." %}
```