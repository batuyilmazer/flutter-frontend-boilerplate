# 🎨 Theme Provider Pattern

Bu doküman, uygulama içinde tema yönetimini **Provider Pattern** kullanarak yapılandırmak için fazlara ayrılmış bir uygulama planını içerir.

---

## 🧱 Faz 1 — Core: Immutable Data Yönetimi (2–3 saat)

Tema token’larını merkezi ve immutable bir yapı içinde tanımla.

### Yapılacaklar

- `AppThemeData` class oluştur  
  - Tüm tema token’larını içeren immutable class
  - `Freezed` class kullanılabilir

### Theme Schemes

- Color Scheme interface
- Light & Dark scheme implementasyonları
- Typography scheme
- Spacing & Radius

> Not: Config detayları uzun süreceği için sonraki fazlara bırakılabilir.

---

## 🔁 Faz 2 — Core (Devam): State Yönetimi (2–3 saat)

Tema state’ini yönetecek notifier ve kalıcılık (persistence) katmanı.

### Theme Notifier

- `ThemeNotifier` oluştur
- `extends ChangeNotifier`
- Fonksiyonlar:
  - `toggleTheme()`
  - `setThemeMode()`

### Persistence

- Tercih saklama:
  - SharedPreferences **veya**
  - Secure Storage
- App başlangıcında tercih yükleme

### Provider Setup

- `main.dart` içine:
  - `ChangeNotifierProvider` ekleme

---

## 🧩 Faz 3 — Integration: MaterialApp Entegrasyonu (3–4 saat)

Tema datasını Flutter `ThemeData` yapısına bağlama.

### ThemeData Üretimi

- `AppThemeData` → `ThemeData` generation
- Light ve Dark için ayrı ayrı theme üret

### App Entegrasyonu

- `MaterialApp.router` güncelle
- `themeMode` değerini dinamik bağla (provider üzerinden)

---

## 🔄 Faz 4 — Migration: UI Component Migration (≈3 saat)

Mevcut component’leri yeni tema sistemine taşıma.

### Refactoring

- Context extensions yaz
- Component refactoring
- Screen refactoring

### Migration Checklist

- [ ] Core tema yapısı (AppThemeData, schemes)
- [ ] ThemeNotifier ve persistence
- [ ] Provider setup
- [ ] MaterialApp entegrasyonu
- [ ] Context extensions

### Component Migration

- [ ] AppButton migration
- [ ] AppText migration
- [ ] AppTextField migration
- [ ] AppIcon migration
- [ ] LabeledTextField migration

### Screen Migration

- [ ] AuthForm migration
- [ ] LoginScreen migration
- [ ] RegisterScreen migration
- [ ] HomeScreen migration

### Diğer

- [ ] Eski API’leri deprecated olarak işaretle

---

## 🧪 Faz 5 — Tests & Cleanup (≈2 saat)

Geriye dönük uyumluluk ve temizlik.

### Backward Compatibility

- Eski static değerleri deprecated işaretle:
  - `AppColors`
  - `AppTypography`

### Test Coverage

- ThemeNotifier testleri
- Component testleri

### Dokümantasyon

- [ ] Test coverage artır
- [ ] Documentation update