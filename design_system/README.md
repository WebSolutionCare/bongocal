# BongoCal Design System

> **তিন ক্যালেন্ডার, এক জায়গায়** — Three calendars, one place.

BongoCal is a premium Bangla calendar mobile app for Bangladesh. It unifies the
**Bengali (বঙ্গাব্দ)**, **Gregorian (English)**, and **Hijri (Islamic)**
calendars in a single beautifully designed surface, with first-class support for
Bangladeshi holidays, religious observances, and cultural festivals (Pohela
Boishakh, Eid, Independence Day, Victory Day, Durga Puja, etc.).

The product target is an Apple-grade feel — calm, considered, premium — but
rooted in Bangladeshi visual culture: deep emerald (the flag's green), the
warm red of the flag's solar disc, gold for festival moments, and beautiful
Bangla typography given equal weight to Latin.

---

## Sources & inputs

This design system was built from a written brief (no codebase or Figma was
provided). All decisions below were derived from that brief and standard
Bangladeshi cultural references.

- **Brief:** premium Bangla calendar app, iPhone-first (390×844), light + dark.
- **Inspiration cited:** Apple Calendar, Notion Calendar, Things 3.
- **Brand colors specified:** `#006A4E` emerald, `#F42A41` warm red, `#D4AF37` gold.
- **Fonts specified:** Hind Siliguri (Bangla) + Inter (Latin).

If you have a codebase, Figma file, or visual references to add, drop them in
and re-run — the system will pick them up.

---

## Index — what's in this folder

```
README.md                    ← this file (brand + content + visual foundations)
SKILL.md                     ← agent skill manifest (Claude Code compatible)
colors_and_type.css          ← all design tokens as CSS variables
BongoCal Design System.html  ← the single interactive artifact (toggle dark/light, hover states)
fonts/                       ← Hind Siliguri + Inter (loaded via Google Fonts CDN)
assets/                      ← logo, icon set, brand marks
preview/                     ← per-token preview cards rendered in the Design System tab
ui_kits/
  bongocal/                  ← mobile app UI kit (interactive prototype)
    index.html
    *.jsx
```

---

## Content fundamentals

**Bilingual by design.** Every surface is built to render in Bangla *and*
English; neither is a translation of the other — both are first-class. Bangla
appears in Hind Siliguri, English in Inter. Default app language is Bangla;
English is a one-tap toggle.

**Voice.** Calm, respectful, slightly poetic. The app is a quiet companion, not
a chirpy assistant.

- **Casing:** Sentence case for all UI strings. Never ALL CAPS (it reads as
  shouting in Bangla cultural register).
- **Pronouns:** When addressing the user in Bangla, use the polite **আপনি**
  form, never the casual **তুমি**. In English, "you" is neutral and fine.
- **No emoji** in product copy. Festival moments are marked with the gold
  badge + a subtle illustration, not 🎉.
- **Numerals:** Use Bangla numerals (০ ১ ২ ৩ ৪ ৫ ৬ ৭ ৮ ৯) when the surrounding
  text is Bangla; Latin numerals (0-9) when the surrounding text is English.
  Date cells follow the active language.
- **Dates:** Bengali dates use the format `১৪ বৈশাখ ১৪৩২`. Gregorian use
  `27 April 2026`. Hijri use `৯ যিলক্বদ ১৪৪৭` (or Latin equivalent).

**Examples**

| Context | ✅ Use | ❌ Avoid |
|---|---|---|
| Today header (Bangla) | আজ, ১৪ বৈশাখ | আজকের দিন!! |
| Empty state | আজ কোনো অনুষ্ঠান নেই | কিছু নেই 😴 |
| Add event CTA | নতুন অনুষ্ঠান | + Add |
| Holiday badge | পহেলা বৈশাখ | New Year 🎊 |
| Settings toggle | বাংলা সংখ্যা ব্যবহার করুন | Use Bangla nums? |

**Tone for system messages.** Direct, never alarming. "তথ্য সংরক্ষিত হয়েছে"
not "সফলভাবে সংরক্ষিত হয়েছে!!".

---

## Visual foundations

### Color
A tight, intentional palette. **Emerald** carries the brand; **warm red** is
reserved for today's date and Bengali holidays; **gold** appears only for
festival moments and premium surfaces. Neutrals do 80% of the work.

- **Primary:** `#006A4E` (Bangladesh flag green) — brand, primary buttons, today indicator backgrounds.
- **Accent red:** `#F42A41` — Bengali holidays, the today dot, destructive actions.
- **Gold:** `#D4AF37` — festival badges, premium surfaces. Used sparingly.
- **Neutral grays:** 50–900 cool-warm scale, slightly green-leaning.
- **Semantic:** success / warning / error / info, each with a soft tint variant for backgrounds.
- **Festival accents:** Eid gold, Pohela Boishakh red, Independence green, Victory red, Durga Puja saffron.

Imagery is **warm**, never cool/blue. Photographs are filtered toward amber
shadows, with a faint film grain on hero imagery.

### Typography
- **Bangla:** Hind Siliguri 400 / 500 / 600 / 700.
- **English:** Inter 400 / 500 / 600 / 700.
- **Display 1** 40px / 48 line-height / -1.5% tracking — used once per screen, max.
- **Heading 1** 28px / 34 / -1%
- **Heading 2** 22px / 28 / -0.5%
- **Heading 3** 18px / 24 / -0.25%
- **Body** 16px / 24 / 0
- **Body small** 14px / 20 / 0
- **Caption** 12px / 16 / +0.5% (uppercase Latin only — never Bangla)

Bangla glyphs are slightly taller than Latin at the same px size; we don't
fight it. Mixed-script lines use a single shared line-height that fits the
taller script.

### Spacing
4px base. Scale: **4, 8, 12, 16, 24, 32, 48, 64**. Most touch targets are
44–48px. Card internal padding is 16. Screen edge gutter is 20.

### Backgrounds
- **App background:** flat neutral (`bg-canvas`). No gradients, no patterns at the screen level.
- **Cards:** flat surface 1 (`bg-surface`) with a 1px hairline + small shadow. No gradient fills.
- **Festival hero card:** the *only* surface that uses an embellishment — a subtle gold-foil radial wash + a corner illustration motif.
- **Imagery:** edge-to-edge full-bleed in dedicated festival modals only; never decorative-only on standard screens.

### Motion
Quiet and quick. Nothing bounces.

- **Hover:** 120 ms `cubic-bezier(0.2, 0, 0, 1)`, 4% darker fill or 8% surface tint.
- **Press:** 80 ms, scale `0.97`, opacity `0.85`. No shadow change.
- **Sheet enter:** 280 ms `cubic-bezier(0.32, 0.72, 0, 1)` (iOS spring-ish).
- **Sheet exit:** 220 ms ease-in.
- **Page transitions:** opacity-only, 180 ms.
- **Today dot pulse:** 2.4 s ease-in-out infinite, opacity 0.6 → 1.0.

### Borders, shadows, radii
- **Hairline border:** 1px, `border-subtle` (10% black in light, 12% white in dark).
- **Radii:** `4` (chips), `8` (inputs), `12` (cards), `16` (sheets), `20` (modals), `999` (pills/avatars).
- **Shadows (4 levels):** `xs` for resting cards, `sm` for elevated cards, `md` for popovers, `lg` for sheets/modals. Shadows are tight and warm-tinted, not blue.
- No inner shadows. No neumorphism.

### Layout rules
- **Top app bar:** 56px, sticky, hairline divider when scrolled.
- **Bottom nav:** 64px + safe area, blurred translucent background (`backdrop-blur(20px)` + 80% surface).
- **Floating action:** 56px circle, `lg` shadow, 16px from bottom-nav top edge.
- **Edge gutter:** 20px on all screens.
- **Vertical rhythm:** 8px grid; section breaks are 24 or 32.

### Transparency & blur
Used in two places only: the bottom nav and modal scrims. Scrims are
`rgba(0,0,0,0.45)` in light, `rgba(0,0,0,0.6)` in dark. We don't blur cards
or sidebars.

### Hover / press state philosophy
Mobile is the primary surface, so hover is a nice-to-have. Press is the
canonical "I touched it" feedback: scale + opacity, no color change. On hover-
capable devices the same component gets a soft 8% tint.

---

## Iconography

We use **Lucide** (1.5px stroke, rounded, outline-style) as the base set,
chosen because it matches the calm/considered Apple-Calendar feel and is
CDN-available. Icons are 24×24 by default; bottom-nav icons are 24, inline
icons are 20, dense list icons are 16.

- **No emoji** in product UI.
- **No Unicode glyphs** as icons (no ✓ ✗ — use `check` / `x` from Lucide).
- **Festival markers** are NOT icons — they're a small filled gold disc
  rendered in the date cell, sometimes paired with a brand illustration on
  the festival's hero card.
- **Logo** is a custom mark in `assets/logo.svg`: a Bengali ক (ka) glyph
  geometrically constructed inside a calendar grid square.

Substitutions flagged: Lucide is a CDN substitute for "icon set TBD" — if you
have a custom set, drop the SVGs in `assets/icons/` and we'll switch.

---

## Companion files

- **`colors_and_type.css`** — every token below as CSS custom properties, with
  light + dark theme blocks. Import once at the root.
- **`BongoCal Design System.html`** — the showcase artifact. Toggle dark/light,
  hover components, click buttons.
- **`ui_kits/bongocal/index.html`** — interactive mobile app prototype.
- **`SKILL.md`** — Agent Skill manifest so this folder works inside Claude Code.
