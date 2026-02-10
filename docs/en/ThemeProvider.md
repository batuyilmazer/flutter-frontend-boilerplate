# Theme Provider & Design Tokens

EN | [TR](../tr/ThemeProvider.tr.md)

This document explains the project’s **theme architecture** and how **design tokens** are exposed to the UI layer.
The goal is to make UI styling consistent, modular, and easily extensible (light/dark/system).

Related docs:
- UI component system: [`UI.md`](UI.md)
- Storage layer (preferences persistence): [`Storage.md`](Storage.md)

---

## Contents

1. [Architecture](#architecture)
2. [File structure](#file-structure)
3. [Design tokens](#design-tokens)
4. [Material ThemeData integration](#material-themedata-integration)
5. [Accessing tokens in UI (BuildContext extensions)](#accessing-tokens-in-ui-buildcontext-extensions)
6. [Developer guide](#developer-guide)
7. [Troubleshooting](#troubleshooting)
8. [References](#references)

---

## Architecture

```mermaid
flowchart TB
  subgraph stateLayer [State_and_Persistence]
    ThemeNotifier["ThemeNotifier (ChangeNotifier)"]
    PreferencesStorage["PreferencesStorage"]
    SecurePreferencesStorage["SecurePreferencesStorage"]
    SecureStorage["SecureStorage"]
  end

  subgraph tokenLayer [Theme_Tokens]
    AppThemeData["AppThemeData (Freezed)"]
    AppColorScheme["AppColorScheme"]
    AppTypographyScheme["AppTypographyScheme"]
    AppSpacingScheme["AppSpacingScheme"]
    AppRadiusScheme["AppRadiusScheme"]
    AppSizeScheme["AppSizeScheme"]
    AppShadowScheme["AppShadowScheme"]
  end

  subgraph materialLayer [Material_Theme]
    ThemeBuilder["ThemeBuilder.buildThemeData"]
    ThemeData["ThemeData (Material_3)"]
    MaterialApp["MaterialApp.router"]
  end

  subgraph uiLayer [UI_and_Access]
    ContextExt["BuildContext extensions"]
    UIWidgets["UI widgets (atoms/molecules/organisms)"]
  end

  ThemeNotifier --> PreferencesStorage
  PreferencesStorage -.impl.-> SecurePreferencesStorage
  SecurePreferencesStorage --> SecureStorage

  ThemeNotifier -->|currentThemeData| AppThemeData
  AppThemeData --> AppColorScheme
  AppThemeData --> AppTypographyScheme
  AppThemeData --> AppSpacingScheme
  AppThemeData --> AppRadiusScheme
  AppThemeData --> AppSizeScheme
  AppThemeData --> AppShadowScheme

  AppThemeData -->|toThemeData()| ThemeBuilder --> ThemeData --> MaterialApp
  MaterialApp --> ContextExt --> UIWidgets
```

Theme mode persistence (toggle/save/load) is part of the **Storage** architecture; see [`Storage.md`](Storage.md).

---

## File structure

```text
lib/theme/
├── theme_data.dart                         # AppThemeData (Freezed)
├── theme_builder.dart                      # AppThemeData → ThemeData mapping
├── theme_notifier.dart                     # ThemeMode state + persistence
├── color_schemes/
│   ├── app_color_scheme.dart
│   ├── light_color_scheme.dart
│   └── dark_color_scheme.dart
├── typography_schemes/app_typography_scheme.dart
├── spacing_schemes/app_spacing_scheme.dart
├── radius_schemes/app_radius_scheme.dart
├── size_schemes/app_size_scheme.dart
├── shadow_schemes/app_shadow_scheme.dart
├── extensions/
│   ├── theme_context_extensions.dart       # context.appColors/appSpacing/...
│   ├── theme_data_extensions.dart          # AppThemeData.toThemeData()
│   └── spacing_extensions.dart             # EdgeInsets helpers
└── theme.dart                              # Barrel export
```

---

## Design tokens

The token system is split into small “schemes” so they can evolve independently.

### Colors (`AppColorScheme`)

Semantic colors (examples):
- `primary`, `background`, `surface`, `surfaceVariant`, `border`, `overlay`
- `textPrimary`, `textSecondary`, `textDisabled`
- `success`, `error`, `warning`, `info`

Light and Dark implementations:
- `lib/theme/color_schemes/light_color_scheme.dart`
- `lib/theme/color_schemes/dark_color_scheme.dart`

### Typography (`AppTypographyScheme`)

Text styles:
- `headline`, `title`, `body`, `bodySmall`, `button`, `caption`

### Spacing (`AppSpacingScheme`)

Spacing scale:
`s0, s2, s4, s6, s8, s12, s16, s20, s24, s32, s40, s48, s64`

### Radius (`AppRadiusScheme`)

Radius tokens:
`none, small, medium, large, xl, full`

### Sizes (`AppSizeScheme`)

Component-level dimensions (icons/buttons/inputs/avatars) resolved via:
- `AppComponentSize.sm/md/lg`

### Shadows (`AppShadowScheme`)

Shadow tokens:
`none, sm, md, lg`

---

## Material ThemeData integration

`ThemeBuilder` maps tokens into Material 3 `ThemeData` so default Material widgets inherit your design system:
- form inputs (`InputDecorationTheme`)
- checkbox/radio/switch
- progress indicators
- tabs
- date picker
- snackbar (toast)
- drawer
- slider
- card/dialog/bottom sheet

---

## Accessing tokens in UI (BuildContext extensions)

Use `BuildContext` extensions to read tokens consistently:

```dart
final colors = context.appColors;
final spacing = context.appSpacing;
final radius = context.appRadius;
final typography = context.appTypography;
final sizes = context.appSizes;
final shadows = context.appShadows;
```

---

## Developer guide

### Add a new token group

Example: `AppBorderWidthScheme`

1. Create a scheme file under `lib/theme/<scheme_group>/...`
2. Add it as a required field to `AppThemeData`
3. Provide a default implementation
4. Expose it via `ThemeContextExtensions` (e.g. `context.appBorderWidths`)
5. Apply it in `ThemeBuilder` where relevant

### Create new UI components

Follow Atomic Design:
- `atoms`: primitives
- `molecules`: small compositions
- `organisms`: overlays/flows/composites

Always prefer tokens over hard-coded values; see [`UI.md`](UI.md).

---

## Troubleshooting

- **Theme changes not reflected**: ensure widgets read values from `context.*` and not from cached theme objects.
- **New token not accessible in UI**: verify it’s added to `AppThemeData` and exposed via `ThemeContextExtensions`.
- **Material widgets look off**: update the corresponding theme section inside `ThemeBuilder`.

---

## References

- Theme tokens: `lib/theme/theme_data.dart`
- Theme state: `lib/theme/theme_notifier.dart`
- Token accessors: `lib/theme/extensions/theme_context_extensions.dart`
- Material mapping: `lib/theme/theme_builder.dart`
- UI system: [`UI.md`](UI.md)

