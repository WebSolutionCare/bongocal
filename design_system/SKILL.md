---
name: bongocal-design
description: Use this skill to generate well-branded interfaces and assets for BongoCal — a premium Bangla calendar app for Bangladesh — either for production or throwaway prototypes/mocks. Contains essential design guidelines, colors, type, fonts, assets, and UI kit components for prototyping.
user-invocable: true
---

Read the `README.md` file within this skill, and explore the other available files (`colors_and_type.css`, `ICONOGRAPHY.md`, `assets/`, `preview/`, `ui_kits/bongocal/`).

If creating visual artifacts (slides, mocks, throwaway prototypes, etc), copy assets out and create static HTML files for the user to view. The fastest path is to:

1. Link or inline `colors_and_type.css` for tokens.
2. Use Hind Siliguri (Bangla) and Inter (Latin) — both loaded via the CSS file's `@import`.
3. Pull components/screens from `ui_kits/bongocal/*.jsx` and adapt as needed.
4. Use the logo at `assets/logo.svg` and Lucide icons inline (see `ICONOGRAPHY.md`).

If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand. Honor the content fundamentals (Bangla + English first-class, polite `আপনি`, no emoji, Bangla numerals when surrounding text is Bangla).

If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.
