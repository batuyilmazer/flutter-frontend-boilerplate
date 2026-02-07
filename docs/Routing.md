# Modüler Routing Sistemi

Bu dokümantasyon, uygulamanın modüler routing mimarisini detaylı olarak açıklar. Sistem, [go_router](https://pub.dev/packages/go_router) paketi üzerine inşa edilmiştir.

---

## İçindekiler

1. [Genel Bakış](#genel-bakış)
2. [Mimari Yapı](#mimari-yapı)
3. [Dosya Yapısı](#dosya-yapısı)
4. [Bileşenler](#bileşenler)
   - [Route Paths](#route-paths)
   - [Auth Guard](#auth-guard)
   - [Route Builders](#route-builders)
   - [App Router](#app-router)
   - [Shell Routing](#shell-routing)
5. [Akış Diyagramları](#akış-diyagramları)
6. [Kullanım Örnekleri](#kullanım-örnekleri)
7. [Yeni Route Ekleme](#yeni-route-ekleme)
8. [Yeni Feature Ekleme](#yeni-feature-ekleme)
9. [Test Stratejisi](#test-stratejisi)
10. [En İyi Pratikler](#en-iyi-pratikler)

---

## Genel Bakış

Routing sistemi aşağıdaki prensiplere dayanır:

- **Modülerlik**: Her feature kendi route tanımlarını yönetir
- **Merkezi Path Yönetimi**: Tüm path'ler tek bir dosyada tanımlanır
- **Guard Sistemi**: Authentication ve authorization kontrolleri merkezi bir guard üzerinden yapılır
- **Type Safety**: Dart'ın tip güvenliği maksimum düzeyde kullanılır
- **Reaktivite**: Auth state değişikliklerinde router otomatik olarak güncellenir

---

## Mimari Yapı

```
┌─────────────────────────────────────────────────────────────────┐
│                         AppRouter                                │
│                    (Ana Orchestrator)                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐  │
│  │ AuthRoutes  │  │ProfileRoutes│  │ ShellRoutes │  │ [Diğer Feat.]│  │
│  │  (Builder)  │  │  (Builder)  │  │  (Builder)  │  │  (Builder)   │  │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬───────┘  │
│         │               │                │                │          │
│         └───────────────┴────────────────┴────────────────┘          │
│                            │                                     │
│                   ┌────────▼────────┐                            │
│                   │   AuthGuard     │                            │
│                   │  (Middleware)   │                            │
│                   └────────┬────────┘                            │
│                            │                                     │
│                   ┌────────▼────────┐                            │
│                   │   AppRoutes     │                            │
│                   │  (Path'ler)     │                            │
│                   └─────────────────┘                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dosya Yapısı

```
lib/routing/
├── app_router.dart           # Ana orchestrator - GoRouter, RoutingMode, route birleştirme
├── route_paths.dart          # Merkezi path sabitleri
├── guards/
│   └── auth_guard.dart       # Authentication guard (middleware)
└── builders/
    ├── auth_routes.dart      # Auth feature route tanımları (login, register)
    ├── profile_routes.dart   # Profile feature route tanımları (home, plain mod)
    └── shell_routes.dart     # Shell layout route'ları (shell mod, bottom nav)
```

`RoutingMode.shell` kullanıldığında authenticated alan `lib/ui/layout/main_shell.dart` içindeki `MainShell` ile sarılır.

### Dosya Sorumlulukları

| Dosya | Sorumluluk |
|-------|------------|
| `app_router.dart` | GoRouter instance oluşturma, `RoutingMode` ile plain/shell seçimi, route'ları birleştirme, global konfigürasyon |
| `route_paths.dart` | Tüm route path sabitlerini tutma |
| `auth_guard.dart` | Authentication kontrolü ve yönlendirme mantığı |
| `auth_routes.dart` | Login, Register gibi auth route'larını tanımlama |
| `profile_routes.dart` | Home ve profil route'ları (sadece plain modda kullanılır) |
| `shell_routes.dart` | ShellRoute + MainShell ile sarılmış authenticated route'lar (sadece shell modda kullanılır) |

---

## Bileşenler

### Route Paths

**Dosya:** `lib/routing/route_paths.dart`

Tüm route path'leri merkezi olarak bu dosyada tanımlanır. Bu sayede:
- Typo hataları önlenir
- Path değişiklikleri tek noktadan yapılır
- IDE auto-complete desteği sağlanır

```dart
class AppRoutes {
  AppRoutes._(); // Instance oluşturmayı engeller

  // Auth routes
  static const login = '/login';
  static const register = '/register';

  // Profile routes
  static const home = '/';
}
```

#### Kullanım

```dart
// ✅ Doğru kullanım
context.go(AppRoutes.login);
context.push(AppRoutes.home);

// ❌ Yanlış kullanım (hardcoded string)
context.go('/login');
```

#### Yeni Path Ekleme

```dart
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';  // Yeni

  // Profile routes
  static const home = '/';
  static const settings = '/settings';               // Yeni
  static const editProfile = '/profile/edit';        // Yeni
}
```

---

### Auth Guard

**Dosya:** `lib/routing/guards/auth_guard.dart`

Authentication guard, her route geçişinde çalışan ve kullanıcının erişim yetkisini kontrol eden middleware'dir.

#### Sorumluluklar

1. **Korumalı Route Kontrolü**: Giriş yapmamış kullanıcıları login sayfasına yönlendirir
2. **Auth Route Kontrolü**: Giriş yapmış kullanıcıları auth sayfalarından uzak tutar
3. **Loading State Yönetimi**: Auth kontrolü devam ederken yönlendirme yapmaz

#### Kod Yapısı

```dart
class AuthGuard {
  /// Ana redirect metodu - GoRouter tarafından her navigasyonda çağrılır
  static String? redirect(
    BuildContext context,
    GoRouterState state,
    AuthNotifier authNotifier,
  ) {
    final authState = authNotifier.state;
    final isLoggedIn = authNotifier.isAuthenticated;
    final currentPath = state.matchedLocation;

    final isAuthRoute = _isAuthRoute(currentPath);
    final isProtectedRoute = _isProtectedRoute(currentPath);

    // Loading durumunda bekle
    if (authState is AuthLoadingState) {
      return null;
    }

    // Giriş yapmamış + korumalı route = login'e yönlendir
    if (!isLoggedIn && isProtectedRoute) {
      return AppRoutes.login;
    }

    // Giriş yapmış + auth route = home'a yönlendir
    if (isLoggedIn && isAuthRoute) {
      return AppRoutes.home;
    }

    return null; // Yönlendirme gerekmiyor
  }

  /// Auth route kontrolü
  static bool _isAuthRoute(String path) {
    return path == AppRoutes.login || path == AppRoutes.register;
  }

  /// Korumalı route kontrolü (varsayılan olarak auth olmayan tüm route'lar korumalı)
  static bool _isProtectedRoute(String path) {
    return !_isAuthRoute(path);
  }
}
```

#### Karar Akışı

```
                    ┌─────────────────┐
                    │ Navigasyon      │
                    │ Başladı         │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Auth Loading?   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │ Evet         │              │ Hayır
              ▼              │              ▼
    ┌─────────────────┐      │    ┌─────────────────┐
    │ null (bekle)    │      │    │ isLoggedIn?     │
    └─────────────────┘      │    └────────┬────────┘
                             │             │
                             │   ┌─────────┴─────────┐
                             │   │ Hayır             │ Evet
                             │   ▼                   ▼
                             │ ┌───────────────┐ ┌───────────────┐
                             │ │isProtectedRoute│ │ isAuthRoute?  │
                             │ └───────┬───────┘ └───────┬───────┘
                             │         │                 │
                             │   ┌─────┴─────┐     ┌─────┴─────┐
                             │   │Evet  │Hayır│    │Evet  │Hayır│
                             │   ▼      ▼     │    ▼      ▼
                             │ login   null   │   home   null
                             └────────────────┴────────────────┘
```

#### Route Kategorileri

| Kategori | Route'lar | Erişim Kuralı |
|----------|-----------|---------------|
| **Auth Routes** | `/login`, `/register` | Sadece giriş yapmamış kullanıcılar |
| **Protected Routes** | `/`, `/settings`, vb. | Sadece giriş yapmış kullanıcılar |
| **Public Routes** | (Tanımlanmamış) | Herkes erişebilir |

#### Public Route Ekleme

Eğer giriş gerektirmeyen public route'lar eklemek isterseniz:

```dart
class AuthGuard {
  // Public route'ları tanımla
  static const _publicRoutes = [
    '/about',
    '/privacy-policy',
    '/terms',
  ];

  static bool _isPublicRoute(String path) {
    return _publicRoutes.contains(path);
  }

  static bool _isProtectedRoute(String path) {
    // Public ve auth route'ları hariç tümü korumalı
    return !_isAuthRoute(path) && !_isPublicRoute(path);
  }
}
```

---

### Route Builders

Her feature kendi route tanımlarını bir builder sınıfında tutar.

#### Auth Routes

**Dosya:** `lib/routing/builders/auth_routes.dart`

```dart
class AuthRoutes {
  /// Authentication ile ilgili tüm route'ları döndürür
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ];
}
```

#### Profile Routes

**Dosya:** `lib/routing/builders/profile_routes.dart`

```dart
class ProfileRoutes {
  /// Profile ile ilgili tüm route'ları döndürür
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ];
}
```

#### Builder Pattern Avantajları

1. **Kapsülleme**: Her feature kendi route'larını yönetir
2. **Bağımsızlık**: Feature'lar birbirinden bağımsız geliştirilebilir
3. **Test Edilebilirlik**: Her builder ayrı ayrı test edilebilir
4. **Ölçeklenebilirlik**: Yeni feature eklemek kolaydır

---

### App Router

**Dosya:** `lib/routing/app_router.dart`

Ana orchestrator sınıfı. Tüm bileşenleri bir araya getirir. `RoutingMode` ile plain (doğrudan feature route'ları) veya shell (ShellRoute + bottom nav) modu seçilir.

```dart
enum RoutingMode {
  plain,
  shell,
}

class AppRouter {
  static GoRouter createRouter(
    BuildContext context, {
    RoutingMode mode = RoutingMode.plain,
  }) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) =>
          AuthGuard.redirect(context, state, authNotifier),
      refreshListenable: authNotifier,
      routes: [
        ...AuthRoutes.routes,
        if (mode == RoutingMode.plain) ...ProfileRoutes.routes,
        if (mode == RoutingMode.shell) ...ShellRoutes.routes,
      ],
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
    );
  }
}
```

Varsayılan `main.dart` çağrısı `AppRouter.createRouter(context)` şeklindedir; bu durumda `mode` belirtilmediği için `RoutingMode.plain` kullanılır.

### Shell Routing

Bu projede, authenticated alanı isteğe bağlı olarak bir **ShellRoute tabanı** üzerinde çalıştırabilirsiniz. Bu sayede:

- Alt tarafta **bottom navigation** veya benzeri bir iskelet ile
- Aynı layout içinde birden fazla tab/route yönetebilirsiniz.

Shell routing üç katmandan oluşur:

1. **Shell layout**: `lib/ui/layout/main_shell.dart`
2. **Shell route builder**: `lib/routing/builders/shell_routes.dart`
3. **Routing modu seçimi**: `RoutingMode` enum'u ve `AppRouter.createRouter` opsiyonu

#### Shell layout: `MainShell`

```dart
class ShellTabConfig {
  const ShellTabConfig({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
    required this.tabs,
  });

  final Widget child;
  final List<ShellTabConfig> tabs;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final currentIndex = _resolveCurrentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
        ],
        onTap: (index) {
          final target = tabs[index];
          if (target.path != location) {
            context.go(target.path);
          }
        },
      ),
    );
  }

  int _resolveCurrentIndex(String location) {
    for (var i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      if (location == tab.path || location.startsWith('${tab.path}/')) {
        return i;
      }
    }
    return 0;
  }
}
```

Bu layout:

- Ekranın gövdesine aktif route'un `child` içeriğini koyar
- Alt tarafa `BottomNavigationBar` ekler
- `tabs` listesinden ikon/label ve hedef path bilgilerini alır
- Tab'e tıklanınca `context.go(tab.path)` ile navigasyon yapar

#### Shell route builder: `ShellRoutes`

```dart
class ShellRoutes {
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) =>
          MainShell(tabs: _buildShellTabs(), child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
  ];

  static List<ShellTabConfig> _buildShellTabs() => const [
    ShellTabConfig(label: 'Home', icon: Icons.home, path: AppRoutes.home),
  ];
}
```

Burada:

- `ShellRoute`, tüm child route'lar için ortak iskeleti (`MainShell`) sağlar
- `tabs` listesi ile hangi tab'ların görüneceğini belirlersiniz
- Örn. daha sonra `settings`, `profile` vb. tab'lar ekleyebilirsiniz

**Uyarı — Shell içi route tekrarları:** Şu an hem `ProfileRoutes` hem `ShellRoutes` aynı ekranı (ör. home) tanımlayabiliyor: plain modda `ProfileRoutes.routes`, shell modda `ShellRoutes.routes` kullanıldığı için çakışma yok; ancak home (path + ekran) iki yerde de tanımlı. Shell'e yeni tab eklerken karar vermeniz gerekir: shell'e giren route'ları tek bir builder'da (`ShellRoutes` içinde) mi tutacaksınız, yoksa ilgili feature builder'larından (ör. `ProfileRoutes`, `SettingsRoutes`) route listesi alıp shell'in `routes` listesine mi ekleyeceksiniz. İkinci yaklaşım tek kaynak (single source of truth) sağlar; birincisi ise shell'e özel tüm route'ları tek dosyada toplar. Proje büyüdükçe hangi stratejiyi kullanacağınızı netleştirmeniz önerilir.

#### Routing modu: `RoutingMode` ve `AppRouter`

```dart
enum RoutingMode {
  plain,
  shell,
}

class AppRouter {
  static GoRouter createRouter(
    BuildContext context, {
    RoutingMode mode = RoutingMode.plain,
  }) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) =>
          AuthGuard.redirect(context, state, authNotifier),
      refreshListenable: authNotifier,
      routes: [
        ...AuthRoutes.routes,
        if (mode == RoutingMode.plain) ...ProfileRoutes.routes,
        if (mode == RoutingMode.shell) ...ShellRoutes.routes,
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.uri}'),
        ),
      ),
    );
  }
}
```

Bu sayede:

- `RoutingMode.plain` → mevcut davranış: auth sonrasında direkt `ProfileRoutes` kullanılır
- `RoutingMode.shell` → auth sonrasında tüm authenticated alan `ShellRoute` içinde (`ShellRoutes`) çalışır

#### Shell routing'i nasıl etkinleştiririm?

`main.dart` içinde:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          final router = AppRouter.createRouter(
            context,
            mode: RoutingMode.shell, // veya RoutingMode.plain
          );
          return MaterialApp.router(
            title: 'Flutter Frontend Boilerplate',
            theme: AppThemeData.light().toThemeData(),
            darkTheme: AppThemeData.dark().toThemeData(),
            themeMode: themeNotifier.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
```

#### Shell tab'larını özelleştirme

En basit senaryo: `ShellRoutes` içindeki `_buildShellTabs` fonksiyonunu düzenlemek:

```dart
static List<ShellTabConfig> _buildShellTabs() => const [
  ShellTabConfig(
    label: 'Home',
    icon: Icons.home,
    path: AppRoutes.home,
  ),
  ShellTabConfig(
    label: 'Settings',
    icon: Icons.settings,
    path: AppRoutes.settings,
  ),
];
```

Daha ileri seviye senaryoda, `MainShell`'i tamamen değiştirip:

- Bottom bar yerine side menu
- Custom FAB navigation
- Tablet/desktop için farklı layout

gibi varyantlar üretebilir, ama `ShellRoute` yapısını ve `RoutingMode.shell` kullanımını koruyarak modüler kalabilirsiniz.

#### Konfigürasyon Özellikleri

| Özellik | Açıklama |
|---------|----------|
| `createRouter(..., mode)` | `RoutingMode.plain` (varsayılan) veya `RoutingMode.shell`; hangi route setinin kullanılacağını belirler |
| `initialLocation` | Uygulama ilk açıldığında gösterilecek route |
| `redirect` | Her navigasyonda çalışan guard/middleware |
| `refreshListenable` | Dinlenen notifier değiştiğinde router'ı yeniler |
| `routes` | Auth + (plain modda ProfileRoutes, shell modda ShellRoutes) |
| `errorBuilder` | Bulunamayan route'lar için hata sayfası |

---

## Akış Diyagramları

### Uygulama Başlatma Akışı

```
┌─────────────────┐
│   main.dart     │
│   MyApp()       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  MultiProvider  │
│  - AuthNotifier │
│  - ThemeNotifier│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ AppRouter       │
│ .createRouter() │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GoRouter        │
│ - routes        │
│ - redirect      │
│ - refreshable   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ MaterialApp     │
│ .router()       │
└─────────────────┘
```

### Navigasyon Akışı

```
┌─────────────────┐
│ context.go()    │
│ veya            │
│ context.push()  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GoRouter        │
│ redirect()      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ AuthGuard       │
│ .redirect()     │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌───────────┐
│ null  │ │ path      │
│       │ │ (redirect)│
└───┬───┘ └─────┬─────┘
    │           │
    ▼           ▼
┌───────┐ ┌───────────┐
│ Hedef │ │ Yeni Hedef│
│ Sayfa │ │ Sayfa     │
└───────┘ └───────────┘
```

### Auth State Değişim Akışı

```
┌─────────────────┐
│ AuthNotifier    │
│ login/logout    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ notifyListeners │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GoRouter        │
│ (refreshable)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ redirect()      │
│ tekrar çalışır  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Uygun sayfaya   │
│ yönlendirme     │
└─────────────────┘
```

---

## Kullanım Örnekleri

### Temel Navigasyon

```dart
// Declarative navigation (stack'i değiştirir)
context.go(AppRoutes.home);

// Imperative navigation (stack'e ekler)
context.push(AppRoutes.settings);

// Geri gitme
context.pop();

// Named route ile navigasyon
context.goNamed('login');
```

### Parametreli Navigasyon

```dart
// Route tanımı (profile_routes.dart)
GoRoute(
  path: '/user/:userId',
  name: 'userDetail',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserDetailScreen(userId: userId);
  },
),

// Kullanım
context.go('/user/123');
context.goNamed('userDetail', pathParameters: {'userId': '123'});
```

### Query Parameter ile Navigasyon

```dart
// Route tanımı
GoRoute(
  path: '/search',
  name: 'search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    return SearchScreen(query: query);
  },
),

// Kullanım
context.go('/search?q=flutter');
context.goNamed('search', queryParameters: {'q': 'flutter'});
```

### Extra Data ile Navigasyon

```dart
// Route tanımı
GoRoute(
  path: '/product',
  name: 'product',
  builder: (context, state) {
    final product = state.extra as Product;
    return ProductScreen(product: product);
  },
),

// Kullanım
context.go('/product', extra: myProduct);
```

### Nested Routes

```dart
// Route tanımı
GoRoute(
  path: '/settings',
  name: 'settings',
  builder: (context, state) => const SettingsScreen(),
  routes: [
    GoRoute(
      path: 'notifications',  // Tam path: /settings/notifications
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: 'privacy',  // Tam path: /settings/privacy
      name: 'privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
  ],
),
```

### Shell Route (Bottom Navigation)

```dart
ShellRoute(
  builder: (context, state, child) {
    return MainShell(child: child);  // Bottom nav içeren scaffold
  },
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeTab(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchTab(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileTab(),
    ),
  ],
),
```

---

## Yeni Route Ekleme

### Adım 1: Path Tanımla

`route_paths.dart` dosyasına yeni path ekleyin:

```dart
class AppRoutes {
  // ... mevcut path'ler

  // Yeni path
  static const settings = '/settings';
}
```

### Adım 2: İlgili Builder'a Route Ekle

İlgili feature'ın builder dosyasına route tanımını ekleyin:

```dart
// profile_routes.dart
class ProfileRoutes {
  static List<RouteBase> get routes => [
    // ... mevcut route'lar
    
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ];
}
```

### Adım 3: Screen Oluştur

İlgili feature klasöründe screen widget'ı oluşturun:

```dart
// lib/features/profile/presentation/settings_screen.dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings')),
    );
  }
}
```

### Adım 4: Guard Güncelle (Gerekirse)

Eğer route özel bir koruma gerektiriyorsa `auth_guard.dart` dosyasını güncelleyin.

---

## Yeni Feature Ekleme

### Adım 1: Feature Klasörü Oluştur

```
lib/features/
└── orders/                    # Yeni feature
    ├── data/
    │   └── orders_repository.dart
    └── presentation/
        ├── orders_screen.dart
        └── order_detail_screen.dart
```

### Adım 2: Route Paths Ekle

```dart
// route_paths.dart
class AppRoutes {
  // ... mevcut path'ler

  // Orders routes
  static const orders = '/orders';
  static const orderDetail = '/orders/:orderId';
}
```

### Adım 3: Route Builder Oluştur

```dart
// lib/routing/builders/orders_routes.dart
import 'package:go_router/go_router.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../route_paths.dart';

/// Route definitions for the orders feature.
class OrdersRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.orders,
      name: 'orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderDetail,
      name: 'orderDetail',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderDetailScreen(orderId: orderId);
      },
    ),
  ];
}
```

### Adım 4: App Router'a Ekle

```dart
// app_router.dart
import 'builders/orders_routes.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    // ...
    return GoRouter(
      // ...
      routes: [
        ...AuthRoutes.routes,
        ...ProfileRoutes.routes,
        ...OrdersRoutes.routes,  // Yeni feature eklendi
      ],
    );
  }
}
```

---

## Test Stratejisi

### Route Paths Testi

```dart
void main() {
  group('AppRoutes', () {
    test('login path should be /login', () {
      expect(AppRoutes.login, equals('/login'));
    });

    test('home path should be /', () {
      expect(AppRoutes.home, equals('/'));
    });
  });
}
```

### Auth Guard Testi

```dart
void main() {
  group('AuthGuard', () {
    late MockAuthNotifier mockAuthNotifier;
    late MockGoRouterState mockState;
    late MockBuildContext mockContext;

    setUp(() {
      mockAuthNotifier = MockAuthNotifier();
      mockState = MockGoRouterState();
      mockContext = MockBuildContext();
    });

    test('should redirect to login when not authenticated and accessing protected route', () {
      when(mockAuthNotifier.isAuthenticated).thenReturn(false);
      when(mockAuthNotifier.state).thenReturn(UnauthenticatedState());
      when(mockState.matchedLocation).thenReturn('/');

      final result = AuthGuard.redirect(
        mockContext,
        mockState,
        mockAuthNotifier,
      );

      expect(result, equals(AppRoutes.login));
    });

    test('should redirect to home when authenticated and accessing login', () {
      when(mockAuthNotifier.isAuthenticated).thenReturn(true);
      when(mockAuthNotifier.state).thenReturn(AuthenticatedState(mockUser));
      when(mockState.matchedLocation).thenReturn('/login');

      final result = AuthGuard.redirect(
        mockContext,
        mockState,
        mockAuthNotifier,
      );

      expect(result, equals(AppRoutes.home));
    });

    test('should return null when loading', () {
      when(mockAuthNotifier.state).thenReturn(AuthLoadingState());
      when(mockState.matchedLocation).thenReturn('/');

      final result = AuthGuard.redirect(
        mockContext,
        mockState,
        mockAuthNotifier,
      );

      expect(result, isNull);
    });
  });
}
```

### Integration Test

```dart
void main() {
  testWidgets('should navigate from login to home after successful login', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Login ekranında olduğumuzu doğrula
    expect(find.byType(LoginScreen), findsOneWidget);

    // Login işlemini simüle et
    await tester.enterText(find.byKey(Key('email')), 'test@test.com');
    await tester.enterText(find.byKey(Key('password')), 'password');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pumpAndSettle();

    // Home ekranına yönlendirildiğini doğrula
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
```

---

## En İyi Pratikler

### 1. Path'leri Hardcode Etmeyin

```dart
// ❌ Yanlış
context.go('/login');

// ✅ Doğru
context.go(AppRoutes.login);
```

### 2. Named Routes Kullanın

```dart
// Route tanımında name verin
GoRoute(
  path: AppRoutes.userDetail,
  name: 'userDetail',  // ✅ Name tanımlı
  builder: (context, state) => UserDetailScreen(),
),

// Named navigation
context.goNamed('userDetail', pathParameters: {'id': '123'});
```

### 3. Type-Safe Extra Data

```dart
// ❌ Yanlış - runtime hatası riski
final product = state.extra as Product;

// ✅ Doğru - null check ve type guard
final product = state.extra;
if (product is! Product) {
  return ErrorScreen(message: 'Invalid product data');
}
return ProductScreen(product: product);
```

### 4. Deep Link Desteği

```dart
// Tüm route'lar deep link destekler
// myapp://host/orders/123 → OrderDetailScreen(orderId: '123')

// App link'leri için AndroidManifest.xml ve Info.plist yapılandırması gerekir
```

### 5. Route Transition Animasyonları

```dart
GoRoute(
  path: AppRoutes.detail,
  pageBuilder: (context, state) => CustomTransitionPage(
    child: const DetailScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  ),
),
```

### 6. Redirect Sonrası Orijinal URL'i Koru

```dart
// Login sonrası kullanıcıyı orijinal hedefine yönlendir
static String? redirect(
  BuildContext context,
  GoRouterState state,
  AuthNotifier authNotifier,
) {
  if (!authNotifier.isAuthenticated && _isProtectedRoute(state.matchedLocation)) {
    // Orijinal URL'i query param olarak sakla
    return '${AppRoutes.login}?redirect=${state.matchedLocation}';
  }
  // ...
}

// Login sonrası redirect
final redirect = state.uri.queryParameters['redirect'] ?? AppRoutes.home;
context.go(redirect);
```

### 7. Error Handling

```dart
// Global error handler
errorBuilder: (context, state) => ErrorScreen(
  error: state.error,
  onRetry: () => context.go(AppRoutes.home),
),

// Route-specific error handling
GoRoute(
  path: '/user/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    if (id == null || int.tryParse(id) == null) {
      return const ErrorScreen(message: 'Invalid user ID');
    }
    return UserScreen(userId: int.parse(id));
  },
),
```

---

## Özet

Bu modüler routing sistemi:

- ✅ **Ölçeklenebilir**: Yeni feature'lar kolayca eklenebilir
- ✅ **Bakımı Kolay**: Her bileşen tek sorumluluğa sahip
- ✅ **Type-Safe**: Compile-time hata kontrolü
- ✅ **Test Edilebilir**: Her katman bağımsız test edilebilir
- ✅ **Reaktif**: Auth state değişikliklerine otomatik tepki verir
- ✅ **Güvenli**: Guard sistemi ile route koruması sağlar

---

## İlgili Kaynaklar

- [go_router Paketi](https://pub.dev/packages/go_router)
- [Flutter Navigation ve Routing](https://docs.flutter.dev/ui/navigation)
- [Provider Paketi](https://pub.dev/packages/provider)
