# Dokümantasyon Stil Rehberi (EN primary)

Bu repository **iki dilli dokümantasyon** kullanır ve **primary dil İngilizce’dir**.

- Primary dokümanlar: `docs/*.md` (İngilizce)
- Türkçe dokümanlar: `docs/*.tr.md`

Tüm dokümanlar tek bir elden çıkmış gibi görünmeli:
- aynı yapı,
- aynı ton,
- aynı format,
- Mermaid diyagram standardı,
- minimum “kod dökümü” (kısa snippet + dosya referansı).

---

## Dosya isimleri ve dil eşleştirmesi

Her `X.md` dokümanının Türkçe karşılığı `X.tr.md` olmalıdır.

Örnek:
- `docs/Routing.md`
- `docs/Routing.tr.md`

Her dokümanın en üstüne dil seçici koyun:

```text
EN | [TR](../tr/Routing.tr.md)
```

Türkçe dosyada:

```text
[EN](../en/Routing.md) | TR
```

---

## Standart şablon (tüm dokümanlara uygulanır)

Aşağıdaki bölüm sırası korunmalı (yalnızca gerçekten alakasızsa bölüm atlanabilir):

1. `# Başlık`
2. 1–2 paragraf **Genel Bakış**
3. `## Contents` (İçindekiler/ToC)
4. `## Architecture` (Mermaid diyagram(lar)ı)
5. `## File structure` (kısa klasör ağacı)
6. `## Key concepts` (madde madde)
7. `## Usage` (kısa örnekler)
8. `## Developer guide` (nasıl genişletilir / yeni şey nasıl eklenir)
9. `## Troubleshooting` (yaygın hatalar)
10. `## References` (ilgili doc linkleri + kritik dosya yolları)

> Not: Başlıklar EN kalabilir; önemli olan standardın tüm dosyalarda aynı olmasıdır.

---

## Mermaid diyagramları

### Ne zaman Mermaid kullanılmalı?

Mermaid şunlar için tercih edilmeli:
- mimari şemalar,
- data flow / request flow,
- state machine’ler,
- routing/guard karar akışları,
- modül ilişkileri.

### Diyagram tipleri

- `flowchart TB`: modüller ve bağımlılıklar
- `sequenceDiagram`: request/response ve side-effect’ler
- `stateDiagram-v2`: state machine (auth/loading vb.)

### Mermaid konvansiyonları

- Node ID’leri boşluk içermez (`AuthNotifier`, `themeTokens`, `uiLayer`)
- Diyagramlar küçük olmalı: doküman başına genelde 1–2 adet
- Stil/class tanımları eklemeyin (render tema tarafından yönetilsin)

---

## Kod blokları politikası (kod dökümünden kaçın)

### Olabilir

- 5–30 satır: **public API**, **imza**, **kullanım örneği**
- bir pattern’i anlatmak için küçük snippet

### Kaçınılmalı

- tüm dosyaları dokümana kopyalamak
- aynı uzun kodları farklı dokümanlarda tekrar etmek

### Alternatif (önerilen)

Dosyaya referans verip davranışı anlatın:
- “Tam GoRouter konfigürasyonu için `lib/routing/app_router.dart` dosyasına bakın.”

---

## Cross-link standardı

- `docs/` içinde relative link kullanın (örn. `[Theme](ThemeProvider.md)`).
- Kod dosyası referanslarında path’i backtick ile belirtin.
- Proje kök `README.md` içindeki dokümantasyon index'i güncel tutulmalı; her doküman listelenmeli.

---

## Ton ve terminoloji

- Dokümanlar, projeye yeni katılan geliştiriciye rehber olacak şekilde yazılmalı.\n+- Terimler tutarlı kullanılmalı:\n+  - theme değerleri için “token(lar)”,\n+  - UI mimarisi için “atoms/molecules/organisms”,\n+  - hata modeli için “Result/Failure”,\n+  - routing koruması için “guard/redirect”.\n+
