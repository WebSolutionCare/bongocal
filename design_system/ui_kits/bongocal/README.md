# BongoCal · Mobile App UI Kit

A click-thru high-fidelity recreation of the BongoCal mobile app at iPhone
13/14 size (390×844). Five core screens are wired:

1. **Splash / launch**
2. **Month view** (the main calendar)
3. **Day detail** (sheet with three-calendar breakdown)
4. **Festival hero** (Eid, Pohela Boishakh, etc.)
5. **Settings** (language, calendars, notifications)

## Files

- `index.html` — entry; loads React + the kit
- `App.jsx` — top-level state machine and screen router
- `Frame.jsx` — iPhone frame + status bar + safe area
- `AppBar.jsx` — top bar with Bangla title
- `BottomNav.jsx` — 4-tab nav
- `MonthView.jsx` — month grid + today summary
- `DateCell.jsx` — primitive cell (normal / today / selected / holiday / festival)
- `DaySheet.jsx` — bottom sheet showing the three-calendar view
- `FestivalScreen.jsx` — festival hero card
- `SettingsScreen.jsx` — settings list
- `Icon.jsx` — Lucide icon wrapper
- `data.js` — fake holidays + events

## How to run

Open `index.html`. Tap a date to open the day sheet. Tap a festival pill to
swap to the festival screen. Bottom nav switches between Calendar, Events,
Festivals, Settings.

## Notes

- All copy is in Bangla (default app language); English appears in numerals,
  Gregorian dates, and a few labels for parity.
- This is **cosmetic**, not real calendar logic. Dates are hardcoded around
  April 2026 to give a realistic-looking month grid.
