## 🎨 Theme Provider Overview

Bu doküman, projedeki **tema yönetimi mimarisini** ve halihazırda implemente edilen tüm bileşenleri açıklar.
Amaç, geliştirme sürecini (fazlar vb.) anlatmak değil, mevcut sistemi nasıl kullandığını ve nasıl genişletebileceğini göstermektir.

- State yönetimi: **ThemeNotifier (Provider)**
- Tema verisi: **AppThemeData (Freezed, immutable)**
- ThemeData üretimi: **ThemeBuilder + AppThemeData.toThemeData()**
- Erişim: **BuildContext extensions** (`context.appColors`, `context.appTypography`, ...)
- UI katmanı: atoms, molecules, organisms ve screen migration

### Architecture Diagram

Aşağıdaki şema, Theme Provider mimarisindeki ana bileşenleri ve veri akışını özetler:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         THEME PROVIDER ARCHITECTURE                          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  STATE & PERSISTENCE LAYER                                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────────┐              ┌──────────────────┐                 │
│   │  ThemeNotifier   │◄─────────────┤  SecureStorage    │                 │
│   │ (ChangeNotifier) │  kaydeder/   │ (SecureStorageImpl│                 │
│   │                  │   okur       │  Key: theme_mode) │                 │
│   └────────┬─────────┘              └──────────────────┘                 │
│            │                                                               │
│            │ currentThemeData                                              │
│            ▼                                                               │
└────────────┼───────────────────────────────────────────────────────────────┘
             │
┌────────────┼───────────────────────────────────────────────────────────────┐
│  THEME DATA LAYER                                                           │
├────────────┼───────────────────────────────────────────────────────────────┤
│            │                                                                │
│   ┌────────▼─────────┐                                                    │
│   │  AppThemeData    │                                                    │
│   │  (Freezed)       │                                                    │
│   │                  │                                                    │
│   │  • light()       │                                                    │
│   │  • dark()        │                                                    │
│   └───────┬──────────┘                                                    │
│           │                                                                │
│           ├──────────────┬──────────────┬──────────────┐                  │
│           │              │              │              │                  │
│   ┌───────▼──────┐ ┌─────▼──────┐ ┌─────▼──────┐ ┌─────▼──────┐          │
│   │ AppColor     │ │ AppTypography│ │ AppSpacing│ │ AppRadius │          │
│   │ Scheme       │ │ Scheme      │ │ Scheme    │ │ Scheme    │          │
│   │              │ │             │ │           │ │           │          │
│   │ • Light      │ │ • headline  │ │ • s4      │ │ • small   │          │
│   │ • Dark       │ │ • title     │ │ • s8      │ │ • medium  │          │
│   │              │ │ • body      │ │ • s12     │ │ • large   │          │
│   │              │ │ • bodySmall │ │ • s16     │ │           │          │
│   │              │ │ • button    │ │ • s24     │ │           │          │
│   │              │ │ • caption   │ │ • s32     │ │           │          │
│   └──────────────┘ └─────────────┘ └───────────┘ └───────────┘          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
             │
             │ toThemeData()
             ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  MATERIAL THEME LAYER                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────────────────┐                                             │
│   │ ThemeBuilder            │                                             │
│   │ .buildThemeData()       │                                             │
│   └───────────┬─────────────┘                                             │
│               │                                                            │
│               │                                                            │
│   ┌───────────▼─────────────┐                                             │
│   │ ThemeData              │                                             │
│   │ (light / dark)         │                                             │
│   │                        │                                             │
│   │ • colorScheme          │                                             │
│   │ • appBarTheme          │                                             │
│   │ • inputDecorationTheme │                                             │
│   │ • buttonTheme          │                                             │
│   │ • cardTheme            │                                             │
│   │ • ...                  │                                             │
│   └───────────┬─────────────┘                                             │
│               │                                                            │
│               │                                                            │
│   ┌───────────▼─────────────┐                                             │
│   │ MaterialApp.router      │                                             │
│   │                        │                                             │
│   │ • theme                │                                             │
│   │ • darkTheme            │                                             │
│   │ • themeMode            │                                             │
│   └───────────┬─────────────┘                                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
               │
               │ BuildContext
               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  UI & ACCESS LAYER                                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────────────────────────────┐                                │
│   │ BuildContext Extensions              │                                │
│   │ ThemeContextExtensions               │                                │
│   │                                      │                                │
│   │ • context.appColors                  │                                │
│   │ • context.appTypography              │                                │
│   │ • context.appSpacing                 │                                │
│   │ • context.appRadius                  │                                │
│   │ • context.themeNotifier              │                                │
│   └───────────┬──────────────────────────┘                                │
│               │                                                            │
│               │                                                            │
│   ┌───────────▼──────────────────────────┐                                │
│   │ UI Widgets                           │                                │
│   │                                      │                                │
│   │ • AppButton                          │                                │
│   │ • AppText                            │                                │
│   │ • AppTextField                       │                                │
│   │ • AppIcon                            │                                │
│   │ • LabeledTextField                   │                                │
│   │ • AuthForm                           │                                │
│   │ • LoginScreen                        │                                │
│   │ • RegisterScreen                     │                                │
│   │ • HomeScreen                         │                                │
│   │ • ...                                │                                │
│   └───────────────────────────────────────┘                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  VERİ AKIŞI (Data Flow)                                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. Kullanıcı tema tercihi                                                 │
│     └─► ThemeNotifier.setThemeMode()                                       │
│         └─► SecureStorage.write('theme_mode', ...)                          │
│                                                                             │
│  2. App başlangıcı                                                          │
│     └─► ThemeNotifier constructor                                          │
│         └─► SecureStorage.read('theme_mode')                                │
│             └─► _themeMode = ThemeMode.light/dark                           │
│                                                                             │
│  3. ThemeNotifier.currentThemeData                                         │
│     └─► AppThemeData.light() veya AppThemeData.dark()                     │
│                                                                             │
│  4. AppThemeData.toThemeData()                                             │
│     └─► ThemeBuilder.buildThemeData()                                      │
│         └─► ThemeData (Material 3)                                         │
│                                                                             │
│  5. MaterialApp.router                                                      │
│     └─► theme: AppThemeData.light().toThemeData()                          │
│     └─► darkTheme: AppThemeData.dark().toThemeData()                      │
│     └─► themeMode: themeNotifier.themeMode                                 │
│                                                                             │
│  6. Widget'lar                                                              │
│     └─► context.appColors.primary                                          │
│     └─► context.appTypography.body                                         │
│     └─► context.appSpacing.s16                                             │
│     └─► context.appRadius.medium                                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

Bu diyagram:
- Tema tercihinin **state + persistence** (ThemeNotifier + SecureStorage) katmanında yönetildiğini,
- `ThemeNotifier.currentThemeData` ile `AppThemeData`'ya ulaşıldığını,
- `AppThemeData.toThemeData()` ve `ThemeBuilder` üzerinden `ThemeData` üretildiğini,
- UI katmanının `BuildContext` extension'ları ile hem `ThemeNotifier`'a hem de tema token'larına eriştiğini görselleştirir.

---

## 🧱 Immutable Theme Data (AppThemeData & Schemes)

### AppThemeData

**Dosya:** `lib/theme/theme_data.dart`

İmplementasyon:
- Freezed ile immutable data class
- Alanlar (tema token grupları):
  - `AppColorScheme colors`
  - `AppTypographyScheme typography`
  - `AppSpacingScheme spacing`
  - `AppRadiusScheme radius`
- Factory constructor'lar:
  - `AppThemeData.light()`
  - `AppThemeData.dark()`

Amaç:
- Tüm tema token'larını **tek bir merkezde** toplamak
- Light/Dark gibi farklı tema varyantlarını kolayca oluşturmak
- İleride yeni token grupları ekleyebilmek (ör: elevation, shadows, borderWidths vb.)

Kullanım örneği:

```dart
final appTheme = AppThemeData.light();       // Light tema
final darkAppTheme = AppThemeData.dark();    // Dark tema

// Örnek token erişimi
final primaryColor = appTheme.colors.primary;
final headlineStyle = appTheme.typography.headline;
final padding = appTheme.spacing.s16;
final cardRadius = appTheme.radius.medium;
```

### Color Schemes

**Dosyalar:**
- `lib/theme/color_schemes/app_color_scheme.dart`
- `lib/theme/color_schemes/light_color_scheme.dart`
- `lib/theme/color_schemes/dark_color_scheme.dart`

Özellikler:
- `AppColorScheme` interface:
  - `primary`, `background`, `textPrimary`, `textSecondary`, `error`, `success`, `surface`
  - `ColorScheme get materialColorScheme`
- `LightColorScheme` ve `DarkColorScheme`:
  - Farklı paletler, Material 3 `ColorScheme.fromSeed` ile entegre

### Typography Scheme

**Dosya:** `lib/theme/typography_schemes/app_typography_scheme.dart`

Özellikler:
- `AppTypographyScheme`:
  - `headline`, `title`, `body`, `bodySmall`, `button`, `caption`
- `DefaultTypographyScheme`:
  - Varsayılan font ağırlıkları ve boyutlar (24/18/16/14/15/12)

### Spacing & Radius Schemes

**Dosyalar:**
- `lib/theme/spacing_schemes/app_spacing_scheme.dart`
- `lib/theme/radius_schemes/app_radius_scheme.dart`

Özellikler:
- `AppSpacingScheme`: `s4`, `s8`, `s12`, `s16`, `s24`, `s32`
- `AppRadiusScheme`: `small`, `medium`, `large`
- `DefaultSpacingScheme` ve `DefaultRadiusScheme` ile standart değerler

---

## 🔁 Theme State Management & Persistence

### ThemeNotifier

**Dosya:** `lib/theme/theme_notifier.dart`

Sorumluluklar:
- `ThemeMode` state'ini yönetir (`light`, `dark`, `system`)
- Tema tercihlerini **SecureStorage** üzerinden kalıcı hale getirir
- Değişiklik olduğunda `notifyListeners()` ile UI'ı günceller

Önemli alanlar:
- `ThemeMode _themeMode;`
- `SecureStorage _storage;`

Önemli metodlar:
- `ThemeMode get themeMode`
- `AppThemeData get currentThemeData`
- `Future<void> setThemeMode(ThemeMode mode)`
- `Future<void> toggleTheme()`
- `_loadThemePreference()` / `_saveThemePreference()`

### Tema tercih persist edilmesi

**Dosyalar:**
- `lib/core/storage/secure_storage.dart`
- `lib/core/storage/secure_storage_impl.dart`

Değişiklikler:
- `SecureStorageKeys.themeMode` eklendi (`'theme_mode'`)
- `ThemeNotifier`, tema modunu bu key üzerinden okuyor/yazıyor

Davranış:
- App ilk açıldığında:
  - Storage'da `theme_mode` varsa, o değer yüklenir
  - Yoksa `ThemeMode.light` ile başlar
- Tema değiştiğinde:
  - `_saveThemePreference()` ile yeni değer saklanır

---

## 🧩 ThemeData Factory & MaterialApp Entegrasyonu

### ThemeBuilder

**Dosya:** `lib/theme/theme_builder.dart`

Amaç:
- `AppThemeData` → Flutter `ThemeData` dönüşümü
- Tüm Material component theme'lerini tek bir yerden yönetmek

Ana API:
- `static ThemeData buildThemeData(AppThemeData appTheme)`

Öne çıkan ayarlar:
- `colorScheme: appTheme.colors.materialColorScheme`
- `useMaterial3: true`
- `scaffoldBackgroundColor: appTheme.colors.background`
- `appBarTheme`:
  - `backgroundColor: appTheme.colors.surface`
  - `foregroundColor: appTheme.colors.textPrimary`
  - `titleTextStyle: appTheme.typography.title`
- `inputDecorationTheme`:
  - Border radius: `appTheme.radius.medium`
  - Renkler: `appTheme.colors.textSecondary`, `primary`, `error`
  - Label/hint/error style: `appTheme.typography.bodySmall/caption`
  - Padding: `appTheme.spacing.s16/s12`
- Button theme'leri:
  - Text/Elevated/Outlined butonlar `appTheme.colors` ve `appTheme.typography.button` ile yapılandırıldı
- Card, Dialog, BottomSheet, Chip, Switch, Divider, TextTheme hepsi AppThemeData token’ları ile bağlandı.

### AppThemeData → ThemeData extension

**Dosya:** `lib/theme/extensions/theme_data_extensions.dart`

Extension:
```dart
extension AppThemeDataExtensions on AppThemeData {
  ThemeData toThemeData() => ThemeBuilder.buildThemeData(this);
}
```

Kullanım:
```dart
final lightTheme = AppThemeData.light().toThemeData();
final darkTheme  = AppThemeData.dark().toThemeData();
```

### MaterialApp.router konfigürasyonu

**Dosya:** `lib/main.dart`

Değişiklikler:
- `MultiProvider` ile:
  - `AuthNotifier`
  - `ThemeNotifier`
- `MaterialApp.router` konfigürasyonu:
  ```dart
  theme: AppThemeData.light().toThemeData(),
  darkTheme: AppThemeData.dark().toThemeData(),
  themeMode: themeNotifier.themeMode,
  ```

---

## 🔄 BuildContext Extensions & UI Kullanımı

### Tema için BuildContext extension’ları

**Dosya:** `lib/theme/extensions/theme_context_extensions.dart`

Extension:
```dart
extension ThemeContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;

  ThemeNotifier get themeNotifier => read<ThemeNotifier>();
  AppThemeData get appTheme => themeNotifier.currentThemeData;

  AppColorScheme get appColors => appTheme.colors;
  AppTypographyScheme get appTypography => appTheme.typography;
  AppSpacingScheme get appSpacing => appTheme.spacing;
  AppRadiusScheme get appRadius => appTheme.radius;
}
```

Amaç:
- Tema erişimini standart hale getirmek:
  - `context.appColors.primary`
  - `context.appTypography.body`
  - `context.appSpacing.s16`
  - `context.appRadius.medium`
- `ThemeNotifier` erişimini sadeleştirmek:
  - `context.themeNotifier`

### Atom Component Migration

#### AppButton

**Dosya:** `lib/ui/atoms/app_button.dart`

Değişiklikler:
- `AppColors/AppSpacing/AppRadius/AppTypography` → `context.appColors/appSpacing/appRadius/appTypography`
- Variant bazlı stiller:
  - `primary`: `backgroundColor: context.appColors.primary`
  - `secondary`: `backgroundColor: context.appColors.surface`
  - `outline`: text & border renkleri `appColors.textPrimary/textSecondary`
  - `text`: `foregroundColor: context.appColors.primary`
- Loading state:
  - Renkler: `context.appColors.primary`

#### AppText

**Dosya:** `lib/ui/atoms/app_text.dart`

Değişiklikler:
- `AppTypography.*` bağımlılığı kaldırıldı.
- `_AppTextVariant` enum ile constructor'lar (headline/title/body/bodySmall/caption) AppTypographyScheme'e map ediliyor:
  - `context.appTypography.headline`, `title`, `body`, `bodySmall`, `caption`
- Custom stil:
  - Ana constructor `style` alırsa, `_AppTextVariant.custom` ile kullanılıyor.

#### AppTextField

**Dosya:** `lib/ui/atoms/app_text_field.dart`

Değişiklikler:
- `AppTypography` → `context.appTypography`
- `AppColors` → `context.appColors`
- `AppRadius` → `context.appRadius`
- `AppSpacing` → `context.appSpacing`
- InputDecoration(border, label/hint/error style, fillColor, padding) tamamen AppThemeData token'larına bağlandı.

#### AppIcon

**Dosya:** `lib/ui/atoms/app_icon.dart`

Değişiklikler:
- Varsayılan renk: `color ?? context.appColors.textPrimary`

### Molecules & Organisms bileşenleri

#### LabeledTextField

**Dosya:** `lib/ui/molecules/labeled_text_field.dart`

Değişiklikler:
- Label rengi: `context.appColors.textPrimary`
- Required yıldız rengi: `context.appColors.error`
- Spacing: `SizedBox(height: context.appSpacing.s8)`

#### AuthForm

**Dosya:** `lib/ui/organisms/auth_form.dart`

Değişiklikler:
- Spacing: `SizedBox(height: context.appSpacing.s16/s24)`
- LabeledTextField ve AppButton zaten yeni tema sistemini kullanıyor.

### Screens (Login, Register, Home)

#### LoginScreen

**Dosya:** `lib/features/auth/presentation/login_screen.dart`

Değişiklikler:
- Padding & spacing:
  - `EdgeInsets.all(context.appSpacing.s24)`
  - `SizedBox(height: context.appSpacing.s32/s16/s8)`
- Metin renkleri:
  - `color: context.appColors.textPrimary`
  - `color: context.appColors.textSecondary`
  - Linkler için `color: context.appColors.primary`
- Snackbar renkleri:
  - Error: `backgroundColor: context.appColors.error`
  - Info: `backgroundColor: context.appColors.textSecondary`

#### RegisterScreen

**Dosya:** `lib/features/auth/presentation/register_screen.dart`

Benzer şekilde:
- Spacing: `context.appSpacing`
- Metin renkleri: `context.appColors.textSecondary/primary`
- Snackbar rengi: `context.appColors.error`

#### HomeScreen

**Dosya:** `lib/features/profile/presentation/home_screen.dart`

Değişiklikler:
- Padding & spacing: `context.appSpacing.s24/s8/s32/s16`
- Butonlar zaten `AppButton` üzerinden yeni tema sistemini kullanıyor.

---

## 🧪 Testler & Doğrulama

### Tema sistemi testleri

**ThemeData & AppThemeData:**
- `test/theme/theme_data_test.dart`
  - `light()` ve `dark()` factory'lerinin doğru scheme'lerle çalıştığı
  - `copyWith` ve equality davranışları

**ThemeNotifier:**
- `test/theme/theme_notifier_test.dart`
  - Initial state (`ThemeMode.light`)
  - `setThemeMode` ile güncelleme
  - `toggleTheme` ile light/dark geçişi
  - Persistence ile storage’a yazma/okuma (`MockSecureStorage` ile)

**ThemeBuilder & Extensions:**
- `test/theme/theme_builder_test.dart`
  - `buildThemeData(AppThemeData.light/dark)` → geçerli `ThemeData` üretimi
  - Tüm major component theme'lerinin set edildiği
  - Renklerin ve typography'nin doğru alanlara map edildiği
  - `AppThemeData.toThemeData()` ile `ThemeBuilder.buildThemeData` sonuçlarının eşitliği

### Backward Compatibility

**Dosya:** `lib/theme/app_theme.dart`

Değişiklikler (eski API’leri korurken yenisine yönlendirme):
- `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`:
  - `@Deprecated('Use AppThemeData + context extensions ...')`
- `AppTheme.light`:
  - İçeride `AppThemeData.light().toThemeData()` kullanıyor.
  - Eski kodu kırmadan yeni sistemi kullanmak için bir adapter görevi görüyor.

---

## 🧭 Migration ve Genişletme Rehberi

### Eski koddaki statik tema sınıfları

Eski kullanım:

```dart
// ESKİ
color: AppColors.textPrimary;
padding: EdgeInsets.all(AppSpacing.s16);
borderRadius: BorderRadius.circular(AppRadius.medium);
style: AppTypography.body;
```

Yeni kullanım:

```dart
// YENİ
final colors = context.appColors;
final spacing = context.appSpacing;
final radius = context.appRadius;
final typography = context.appTypography;

color: colors.textPrimary;
padding: EdgeInsets.all(spacing.s16);
borderRadius: BorderRadius.circular(radius.medium);
style: typography.body;
```

### Kısa Özet

Bu mimari ile:

- Tema token'ları **immutable** ve merkezi (`AppThemeData`).
- Light/Dark ve gelecekteki tema varyantları için **genişletilebilir** yapı var.
- Tema durumu `ThemeNotifier` ile yönetiliyor; tercih kalıcı (`SecureStorage`).
- Flutter `ThemeData` üretimi tek yerden kontrol ediliyor (`ThemeBuilder`).
- UI katmanı, static sınıflar yerine `BuildContext` extension'ları ile **modüler** ve **esnek** bir şekilde temaya erişiyor.
- Eski API'ler (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppTheme.light`) **deprecated** ama backward compatible tutuluyor.

Yeni UI veya feature geliştirirken:
- Renkler: `context.appColors`
- Typography: `context.appTypography`
- Spacing: `context.appSpacing`
- Radius: `context.appRadius`
- Theme mode: `context.themeNotifier.themeMode / toggleTheme()`

Bu sayede hem mevcut proje hem de gelecekteki projeler için tekrar kullanılabilir, temiz ve genişletilebilir bir Theme Provider altyapısı sağlanmış oldu.

