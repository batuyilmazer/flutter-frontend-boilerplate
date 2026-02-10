# Documentation Style Guide (EN primary)

This repository uses **bilingual documentation** with **English as the primary language**.

- Primary docs: `docs/*.md` (English)
- Turkish docs: `docs/*.tr.md`

Every document must be written as if it came from a single author:
- same structure,
- same tone,
- same formatting,
- diagrams in Mermaid,
- minimal code dumping (prefer short snippets + file references).

---

## File naming and language pairing

For any doc `X.md`, the Turkish version is `X.tr.md`.

Example:
- `docs/Routing.md`
- `docs/Routing.tr.md`

At the very top of each file, add a language switcher:

```text
EN | [TR](../tr/Routing.tr.md)
```

and in the Turkish file:

```text
[EN](../en/Routing.md) | TR
```

---

## Standard template (apply to every doc)

Use this exact section order (omit sections only if truly not relevant):

1. `# Title`
2. 1–2 paragraph **Overview**
3. `## Contents` (ToC)
4. `## Architecture` (Mermaid diagram(s))
5. `## File structure` (short tree)
6. `## Key concepts` (bullets)
7. `## Usage` (short examples)
8. `## Developer guide` (how to extend / add new features)
9. `## Troubleshooting` (common pitfalls)
10. `## References` (links to related docs + key files)

---

## Mermaid diagrams

### When to use Mermaid

Prefer Mermaid for:
- architecture diagrams,
- data flow / request flow,
- state machines,
- routing/guard decisions,
- module relationships.

### Diagram types

- `flowchart TB`: modules and dependencies
- `sequenceDiagram`: request/response and side effects
- `stateDiagram-v2`: state machines (auth, loading, etc.)

### Mermaid conventions

- Node IDs: no spaces (`AuthNotifier`, `themeTokens`, `uiLayer`)
- Keep diagrams small: 1–2 per document (add more only if needed)
- No styling directives (let the renderer theme handle it)

---

## Code block policy (avoid code dumps)

### Allowed

- 5–30 lines showing a **key signature**, **public API**, or **usage example**
- tiny snippets to explain a pattern

### Avoid

- copying entire files into docs
- repeating long code blocks across docs

### Preferred alternative

Link to the file and explain behavior:
- “See `lib/routing/app_router.dart` for the full GoRouter configuration.”

---

## Cross-linking

- Use relative links inside `docs/` (e.g. `[Theme](ThemeProvider.md)`).
- When referencing a code file, include its path in backticks.
- Keep the project `README.md` documentation index updated and ensure every doc is listed there.

---

## Tone & terminology

- Write for developers joining the project.
- Use consistent terms:
  - “token(s)” for theme values,
  - “atoms/molecules/organisms” for UI architecture,
  - “Result/Failure” for error handling,
  - “guard/redirect” for routing protection.

---

## UI token usage rules

- Prefer `context.appColors` over `Colors.*` in UI components.
  - Use `colors.onPrimary` / `colors.onSurface` for text/icons instead of hardcoded `Colors.white`.
- Prefer semantic spacing tokens (e.g. `context.appSpacing.buttonPaddingX`) over raw scale values where a component default exists.
- Prefer semantic radius tokens (e.g. `context.appRadius.button`) over primitive radius values.
- Avoid inline `BoxShadow(...)`. Use `context.appShadows` tokens (primitive or semantic) instead.

