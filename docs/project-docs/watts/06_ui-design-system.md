# UI Design System

## Personality & Tone
**Professional training tool with a live-feed feel.** Think dispatch console meets simulation game: crisp, legible at a glance, high information density without feeling busy. Serious — lives and careers depend on the real thing — but modern and motivating enough that Marcus doesn't dread opening it. The near-3D classroom view has warmth and dimension (soft shadows, gentle lighting); the forms and dashboards are clinical and scannable.

---

## Colors

### Brand
| Token | Hex | Use |
|---|---|---|
| `brand-primary` | `#1D4ED8` | Primary actions, links, live state |
| `brand-primary-hover` | `#1E40AF` | Hover state of primary |
| `brand-secondary` | `#0F172A` | Secondary actions, hero text |
| `brand-accent` | `#F59E0B` | Attention without alarm — pending forms, unfilled required fields |

### Neutrals
| Token | Hex | Use |
|---|---|---|
| `background` | `#F8FAFC` | App background (light mode only in v1) |
| `surface` | `#FFFFFF` | Cards, panels, modals |
| `surface-alt` | `#F1F5F9` | Secondary surfaces, table stripes |
| `border` | `#E2E8F0` | Default border |
| `border-strong` | `#CBD5E1` | Hover / focus borders |
| `muted` | `#F1F5F9` | Disabled backgrounds |

### Text
| Token | Hex | Use |
|---|---|---|
| `text-primary` | `#0F172A` | Body, headings |
| `text-secondary` | `#475569` | Captions, helper, labels |
| `text-muted` | `#94A3B8` | Disabled, placeholder |
| `text-inverse` | `#F8FAFC` | On dark backgrounds |

### Semantic
| Token | Hex | Use |
|---|---|---|
| `success` | `#16A34A` | Form submitted, role confirmed, under budget |
| `warning` | `#F59E0B` | Approaching limit, missing signature |
| `error` | `#DC2626` | Over budget, invalid form, RLS denial |
| `info` | `#0EA5E9` | System messages, help |

---

## ICS Role Colors (domain-specific — do not substitute)

The user was specific about role-color mapping. These appear on avatars, role badges, and org chart nodes.

| Token | Hex | Applies To |
|---|---|---|
| `role-ic` | `#EC4899` | **Incident Commander** (pink) |
| `role-command` | `#DC2626` | **Command Staff** — Safety Officer, PIO, Liaison Officer (red) |
| `role-section` | `#16A34A` | **General Staff Section Chiefs** — Operations, Planning, Logistics, Finance/Admin, Intel/Investigation (green) |
| `role-boss` | `#F8FAFC` | **Supervisors / Bosses** of any division, group, branch, unit (white — use with dark border) |
| `role-staff` | `#64748B` | Line staff / assigned resources (slate) |
| `role-agency-rep` | `#7C3AED` | Agency representatives, technical specialists (purple) |

## Discipline Colors (PPE / vehicle / icon tinting)

| Token | Hex | Applies To |
|---|---|---|
| `disc-fire` | `#EA580C` | Fire service |
| `disc-ems` | `#DB2777` | EMS / medical |
| `disc-police` | `#1E40AF` | Law enforcement |
| `disc-hazmat` | `#CA8A04` | HazMat (yellow / high-vis) |
| `disc-pubworks` | `#78716C` | Public works |
| `disc-media` | `#6366F1` | Media / PIO / JIC |
| `disc-utility` | `#0369A1` | Utility / phone / power |
| `disc-cert` | `#15803D` | CERT volunteers |

## Budget Status Colors (Finance HUD)

Budget threshold bands — Finance section reads these directly:

| Token | Hex | Band |
|---|---|---|
| `budget-healthy` | `#16A34A` | 100–76% remaining |
| `budget-watch` | `#84CC16` | 75–51% remaining |
| `budget-caution` | `#F59E0B` | 50–16% remaining |
| `budget-critical` | `#EF4444` | 15–6% remaining |
| `budget-exhausted` | `#7F1D1D` | 5–0% remaining |
| `budget-over` | `#000000` | Over budget |

## Resource Availability Colors

| Token | Hex | Meaning |
|---|---|---|
| `avail-easy` | `#16A34A` | Readily available (water, basic supplies, local personnel) |
| `avail-moderate` | `#F59E0B` | Available with delay (specialist equipment, mutual aid) |
| `avail-hard` | `#DC2626` | Hard to procure (Type-1 helicopter, Type-1 hazmat entry team) |
| `avail-blocked` | `#171717` | Not available in current scenario |

---

## Typography

### Font Family
- **Primary:** `Inter` (variable font, 400–700)
- **Mono:** `JetBrains Mono` — form field numbers, incident IDs, timestamps
- **Display (optional, Phase 2+):** `Space Grotesk` for hero/welcome screens only

### Scale
| Token | Size | Use |
|---|---|---|
| `text-xs` | 12px | Form field helpers, badges |
| `text-sm` | 14px | Secondary labels, table rows |
| `text-base` | 16px | Body |
| `text-lg` | 18px | Emphasized body, card titles |
| `text-xl` | 20px | Section headings |
| `text-2xl` | 24px | Page titles |
| `text-3xl` | 30px | Dashboard headlines |
| `text-4xl` | 36px | Marketing / hero only |

### Weight
- `font-normal` 400 — body
- `font-medium` 500 — emphasis in body
- `font-semibold` 600 — headings, button text
- `font-bold` 700 — hero, critical alerts

### Line Height
- `leading-tight` 1.25 — headings
- `leading-normal` 1.5 — body
- `leading-relaxed` 1.75 — long-form (course reference text)

---

## Spacing Scale (Tailwind default, 4px base)
`1:4 | 2:8 | 3:12 | 4:16 | 5:20 | 6:24 | 8:32 | 10:40 | 12:48 | 16:64 | 20:80 | 24:96`

---

## Border Radius
| Token | Size | Use |
|---|---|---|
| `rounded-none` | 0 | Tables, dense data |
| `rounded-sm` | 4px | Inputs, small badges |
| `rounded-md` | 8px | Buttons, cards (default) |
| `rounded-lg` | 12px | Modals, large cards |
| `rounded-xl` | 16px | Marketing, onboarding |
| `rounded-full` | 9999px | Avatars, pills, role badges |

**Overall feel:** subtle — 8px default. Not sharp-corporate, not bubbly.

---

## Shadows
| Token | Purpose |
|---|---|
| `shadow-sm` | Card rest state |
| `shadow-md` | Dropdowns, floating tablet UI |
| `shadow-lg` | Modals, role-select hero cards |
| `shadow-xl` | Full-screen takeovers (instructor inject events) |

**Style:** soft, warm-gray shadows. Not hard drop-shadows.

---

## Component Conventions

### Buttons
- **Primary:** filled `brand-primary`, white text
- **Secondary:** outlined, `brand-secondary` text
- **Destructive:** filled `error`, white text (for "transfer command," "remove resource")
- **Ghost:** no fill, no border, for low-weight actions
- **Sizes:**
  - `sm`: 32px height, 12px x-padding, `text-sm`
  - `md`: 40px height, 16px x-padding, `text-sm` (default)
  - `lg`: 48px height, 20px x-padding, `text-base`

### Inputs
- Height: 40px (md), 32px (sm)
- Border: `1px solid border` → `border-strong` on hover → `brand-primary` on focus (with 2px focus ring)
- Error: `error` border + helper text below in `error` color
- Required fields: asterisk in `error` color
- ICS form numeric fields use `font-mono`

### Cards
- Padding: 24px (desktop), 16px (tablet)
- Border: `1px solid border`
- Shadow: `shadow-sm` rest, `shadow-md` hover (if interactive)
- Radius: `rounded-md`

### Role Badges (sim-specific)
- Avatar-adjacent pill
- Background: the role color from the ICS Role Colors table
- Text: white for dark backgrounds (IC, Command, Section), dark for white/slate
- Font: `text-xs`, `font-semibold`, uppercase

### Tablet UI (in-sim chat / help / forms)
- Rendered as a 3D-surface card within the sim canvas
- Uses the same design tokens so a tablet modal that escapes the canvas looks identical in DOM
- Section-scoped color theming: Finance tablet has a `role-section` green header stripe, Command tablets red, etc.

---

## Icons
- **Library:** Lucide React (`lucide-react`)
- **Default size:** 20px for UI, 16px inline with body text, 24px for primary toolbar
- **Stroke:** 1.5
- **ICS-specific glyphs** (incident site marker, staging flag, EOC building, etc.) — custom SVGs in `/components/icons/ics/`

---

## Layout

### Max Widths
| Token | Value | Use |
|---|---|---|
| `max-w-content` | 768px | Long-form docs, policy pages |
| `max-w-page` | 1280px | Dashboards, forms |
| `max-w-wide` | 1536px | Instructor master view, sim canvas |
| (none) | 100% | Full-bleed sim canvas |

### Breakpoints (Tailwind default)
`sm:640 | md:768 | lg:1024 | xl:1280 | 2xl:1536`

### Grid
- 12-column grid, 24px gap (desktop), 16px gap (tablet)

---

## Animation
| Token | Duration | Use |
|---|---|---|
| `duration-fast` | 150ms | Button press, hover, input focus |
| `duration-normal` | 250ms | Card expand, modal open |
| `duration-slow` | 400ms | Avatar walk-step (Phase 3+) |
| `duration-event` | 800ms | Transfer of command, scenario inject |

**Easing:** `cubic-bezier(0.4, 0, 0.2, 1)` (Tailwind `ease-in-out` default). No bouncy easing — this is a professional tool.

**Avatar movement (Phase 3+):** walk animation is real-time on a grid; the character traverses `n` tiles at a fixed tile-per-second rate, not a canned "slide" animation.

---

## Rules Claude Must Follow
- **Never hardcode hex.** Use tokens from `tailwind.config.ts` which maps to this file.
- **Role colors are canonical** — IC = pink, Command = red, Section = green, Boss = white. Do not substitute.
- **Every interactive element needs hover + focus + active + disabled states.** Accessibility baseline.
- **Keyboard navigation first.** Every action reachable without a mouse (critical for tablet kiosk mode and accessibility).
- **Color is never the only signal.** Red for error = also an icon + text. Green for success = also a checkmark.
- **No dark mode in v1.** Do not add theme plumbing.
- **3D surfaces get lighting, DOM surfaces get flat shadows.** Consistent feel without mixing metaphors.
