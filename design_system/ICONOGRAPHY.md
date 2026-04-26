# Iconography

BongoCal uses **Lucide** (https://lucide.dev/) at 1.5px stroke weight, rounded
linecaps and joins, outline style. Icons are loaded from CDN — no local sprite.

```html
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
<i data-lucide="calendar"></i>
<script>lucide.createIcons();</script>
```

## Standard sizes
- **24px** — bottom-nav icons, top-app-bar actions, default inline icon
- **20px** — list-row icons, input field icons
- **16px** — dense metadata, chips
- **32px** — feature illustration on empty states (rare)

## Color usage
Icons take their color from `currentColor`. Roles:
- `--fg-primary` for primary actions
- `--fg-secondary` for secondary inline icons
- `--brand-emerald` for the active state on bottom-nav
- `--brand-red` for destructive actions and the today-dot
- `--brand-gold` only for festival surfaces

## Canonical mapping (used in this design system)

| Concept | Lucide name |
|---|---|
| Calendar | `calendar` |
| Today | `calendar-clock` |
| Festival/Holiday | `sparkles` |
| Notification | `bell` |
| Settings | `settings` |
| Add event | `plus` |
| Search | `search` |
| Back | `chevron-left` |
| More | `more-horizontal` |
| Bengali calendar | `sun` |
| Hijri calendar | `moon` |
| Gregorian calendar | `globe` |

## What we do NOT use
- ❌ Emoji as icons in product UI
- ❌ Unicode glyphs (✓ ✗ ★) as icons
- ❌ Filled icons (we are an outline system)
- ❌ Multi-color/illustrated icons mixed with the outline set

## Logo
Custom mark in `logo.svg` — a Bengali **ক** (ka) glyph constructed as a
calendar-page binding, with a small red today-dot in the corner. Used on
the splash screen, app icon, settings header, and external surfaces.
`logo-wordmark.svg` is the lockup for marketing.

## Substitution flag
Lucide is a CDN substitute for "icon set TBD" in the brief. If a custom set is
provided, drop SVGs in `assets/icons/<name>.svg` and switch the references in
the UI kit's `Icon.jsx`.
