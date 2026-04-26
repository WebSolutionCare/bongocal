# Fonts

This system uses two web fonts, both loaded from **Google Fonts** via the
`@import` in `colors_and_type.css`:

- **Hind Siliguri** — Bangla script (300, 400, 500, 600, 700)
- **Inter** — Latin script (400, 500, 600, 700)

No `.ttf` / `.woff2` files are stored locally because both faces are reliably
CDN-available. If you need offline use, download the subsets from
https://fonts.google.com/ and drop the `.woff2` files in this folder, then
add `@font-face` blocks at the top of `colors_and_type.css`.

> **Substitution flag:** None. Both fonts were specified by name in the brief.
