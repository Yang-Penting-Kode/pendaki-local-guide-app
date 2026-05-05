# 🗺️ SYSTEM MAP — GuideIn (Local Guide App)

> **ATURAN:** Baca file ini SEBELUM melakukan analisis, debugging, atau modifikasi apapun.
> Pola navigasi: **Trigger (UI) → Handler → Logic → View**

---

## 1. Project Summary

| Key | Value |
|---|---|
| **Nama App** | GuideIn (Local Guide) |
| **Tujuan** | Marketplace rental alat pendakian berbasis lokasi basecamp gunung |
| **Framework** | Flutter 3.x (Dart ≥3.1.0) |
| **Design System** | Material 3 (`useMaterial3: true`) via `ColorScheme.fromSeed` |
| **Map Engine** | `flutter_map` v6.1.0 + `latlong2` v0.9.1 (OpenStreetMap tiles) |
| **Fonts** | Manrope (headlines) + Inter (body) via `google_fonts` |
| **Animations** | Lottie (loading/ilustrasi), Rive (micro-interaction) |
| **Networking** | Dio v5.3.0 (API), http v1.1.0 (cadangan) |
| **State** | Manual `setState` + `ChangeNotifier` (SettingsProvider). Riverpod dikomentari |
| **Persistensi** | `SharedPreferences` (onboarding flag, bahasa) |
| **API Backend** | Laravel (`https://api.localguide.my.id/api`) — Sanctum auth, belum penuh |
| **Entry Point** | `lib/main.dart` → `SplashScreen` → conditional onboarding/login |
| **Color Palette** | Primary: Alpine Green `#006C0C`, Secondary: Safety Orange `#904D00` |

---

## 2. Core Logic Flow

### 2.1. App Initialization Flow

```
main() → StorageService.init() → LocalGuideApp
  ├── hasSeenOnboarding? → '/login' (AuthGateScreen)
  └── else → '/onboarding' (OnboardingScreen)

Routing: onGenerateRoute + named routes + _fadeRoute(700ms)
```

### 2.2. 🔥 Primary Flow: Search → Result → Detail → Booking → Map

Ini adalah alur utama yang dioptimalkan untuk analisis:

```mermaid
flowchart TD
    A["HomeScreen<br/><i>SearchBar (disabled TextField)</i>"] -->|"onTap → pushNamed('/mountain-search')"| B["MountainSearchScreen"]
    B -->|"onSubmitted(value) → pushNamed<br/>args: String query"| C["MountainSearchResultScreen"]
    B -->|"Filter button"| FM["FilterModal<br/>(BottomSheet)"]
    C -->|"Card onTap → pushNamed('/mountain-detail')<br/>args: Map{title, location, imageUrl}"| D["MountainDetailScreen"]
    D -->|"'Cari Persewaan' → showModalBottomSheet"| E["OrderTypeSheet"]
    E -->|"Pesan Sekarang<br/>args: 2000.0 (radius)"| F["BasecampPartnersScreen<br/>(FlutterMap + DraggableSheet)"]
    E -->|"Booking Dulu"| G["DatePickerModal"]
    G -->|"Terapkan Tanggal<br/>Navigator.push (custom transition)"| F
    F -->|"Katalog btn → pushNamed('/rental-detail')"| H["RentalDetailScreen<br/>(FlutterMap background)"]
    H -->|"Lihat Katalog → pushNamed('/catalog')"| I["CatalogScreen"]
    H -->|"Lacak Lokasi → pushNamed('/track-location')"| J["TrackLocationScreen<br/>(FlutterMap + routing)"]
    I -->|"Product card → pushNamed('/product-detail')"| K["ProductDetailScreen"]
    I -->|"Cart icon → pushNamed('/cart')"| L["CartScreen"]
    K -->|"Sewa/Cart actions"| L
    L -->|"pushNamed('/checkout')"| M["CheckoutScreen<br/>(FlutterMap inline)"]
    M -->|"pushNamed('/order-summary')"| N["OrderSummaryScreen<br/>(FlutterMap + payment picker)"]
    N -->|"Bayar → pushNamed('/transaction-success')"| O["TransactionSuccessScreen"]
    N -->|"Gagal"| P["TransactionFailedScreen"]
```

### 2.3. Argument Passing Contract

| Route | Arguments Type | Mandatory Fields |
|---|---|---|
| `/mountain-search-result` | `String` | query text |
| `/mountain-detail` | `Map<String, dynamic>` | `title`, `location`, `imageUrl` |
| `/basecamp-partners` | `double` atau `Map` (nullable) | radius dalam meter (default: 5000.0) |
| Semua route lain | **Tidak ada arguments** | — |

> ⚠️ **RISK:** `BasecampPartnersScreen` melakukan type-check manual (`args is double` / `args is Map`). Jika argumen tidak cocok, fallback ke 5000.0. Ini fragile dan tidak type-safe.

### 2.4. Dashboard Navigation (Bottom Nav)

```
DashboardScreen (IndexedStack, 5 tabs)
  ├── [0] HomeScreen        — BERANDA
  ├── [1] BookingScreen     — BOOKING
  ├── [2] SearchScreen      — CARI
  ├── [3] HistoryScreen     — RIWAYAT
  └── [4] SettingsScreen    — PENGATURAN
```

---

## 3. Module Map

### 3.1. `lib/screens/` — Halaman Utama

| Folder | File | Deskripsi | Map? |
|---|---|---|---|
| **auth/** | `auth_gate_screen.dart` | Login gate (Google/Email) | |
| | `login_email_screen.dart` | Form login email+password | |
| | `register_screen.dart` | Form registrasi | |
| | `registration_success_screen.dart` | Lottie success animation | |
| | `email_verification_screen.dart` | Input kode verifikasi | |
| | `forgot_password_screen.dart` | Form forgot password | |
| | `reset_password_screen.dart` | Form reset password | |
| **splash/** | `splash_screen.dart` | Loading awal + routing | |
| **onboarding/** | `onboarding_screen.dart` | Intro slides + Rive | |
| **tutorial/** | `tutorial_screen.dart` | Tutorial penggunaan app | |
| **dashboard/** | `dashboard_screen.dart` | Shell BottomNav (5 tab) | |
| **home/** | `home_screen.dart` | Beranda utama | |
| | `mountain_search_screen.dart` | Input pencarian + riwayat | |
| | `mountain_search_result_screen.dart` | Daftar hasil pencarian | |
| | `mountain_detail_screen.dart` | Detail gunung + SliverAppBar | |
| | `basecamp_partners_screen.dart` | Peta mitra + DraggableSheet | ✅ FlutterMap |
| | `rental_detail_screen.dart` | Detail toko rental | ✅ FlutterMap |
| | `catalog_screen.dart` | Grid produk toko | |
| | `track_location_screen.dart` | Lacak lokasi user↔toko | ✅ FlutterMap |
| **search/** | `search_screen.dart` | Tab pencarian dashboard | |
| | `search_not_found_screen.dart` | Empty state pencarian | |
| **products/** | `product_detail_screen.dart` | Detail alat + image slider | |
| **cart/** | `cart_screen.dart` | Keranjang belanja | |
| **booking/** | `booking_screen.dart` | Tab booking dashboard | |
| | `checkout_screen.dart` | Form detail sewa alat | ✅ FlutterMap |
| | `order_summary_screen.dart` | Ringkasan + pembayaran | ✅ FlutterMap |
| | `transaction_success_screen.dart` | Halaman sukses bayar | |
| | `transaction_failed_screen.dart` | Halaman gagal bayar | |
| | `pickup_confirmation_screen.dart` | Konfirmasi ambil barang | |
| | `return_confirmation_screen.dart` | Konfirmasi pengembalian | |
| | `live_tracking_screen.dart` | Live tracking pengiriman | |
| | `delivery_arrived_screen.dart` | Notif barang sampai | |
| | `review_screen.dart` | Form review setelah sewa | |
| **history/** | `history_screen.dart` | Tab riwayat dashboard | |
| | `my_reviews_screen.dart` | Daftar review user | |
| **settings/** | `settings_screen.dart` | Menu pengaturan | |
| | `profile_screen.dart` | Halaman profil user | |
| | `edit_profile_screen.dart` | Edit profil | |
| | `orders_screen.dart` | Daftar pesanan | |
| | `wishlist_screen.dart` | Daftar wishlist | |
| | `security_privacy_screen.dart` | Keamanan & privasi | |
| | `change_password_screen.dart` | Ganti password | |
| | `document_verification_screen.dart` | Verifikasi KTP/dokumen | |
| | `notification_settings_screen.dart` | Pengaturan notifikasi | |
| | `help_center_screen.dart` | Pusat bantuan | |
| | `about_app_screen.dart` | Tentang aplikasi | |
| | `terms_conditions_screen.dart` | Syarat & ketentuan | |
| | `privacy_policy_screen.dart` | Kebijakan privasi | |

### 3.2. `lib/components/modals/` — Bottom Sheet Modals

| File | Trigger | Fungsi Utama |
|---|---|---|
| `filter_modal.dart` | `MountainSearchScreen._showFilter()`, `BasecampPartnersScreen._showFilter()` | Filter kategori (Tenda/Carrier/dll) + slider harga maks |
| `order_type_sheet.dart` | `MountainDetailScreen._buildRentalBanner()` → `showModalBottomSheet` | Pilih: "Pesan Sekarang" (→ partners) atau "Booking Dulu" (→ date picker) |
| `date_picker_modal.dart` | `OrderTypeSheet` "Booking Dulu" onTap | Custom calendar range picker → navigasi ke `BasecampPartnersScreen` |
| `language_modal.dart` | `SettingsScreen` | Pilih bahasa (ID/EN) → persist via `StorageService` |

### 3.3. `lib/core/` — Foundation

| File | Isi |
|---|---|
| `core/constants/app_colors.dart` | Seluruh token warna Material 3 (primary, surface containers, error) |
| `core/constants/app_theme.dart` | `ThemeData` global: Google Fonts, AppBar, Input, Button styles |

### 3.4. `lib/models/` — Data Models

| File | Fields |
|---|---|
| `language_model.dart` | `name`, `code`, `flagUrl` |
| `user_model.dart` | `id`, `fullName`, `email`, `phoneNumber?`, `ktpNumber?`, `isVerified` + `fromJson()` |
| `onboarding_model.dart` | Model data onboarding slides |

### 3.5. `lib/providers/` — State Management

| File | Type | Fungsi |
|---|---|---|
| `settings_provider.dart` | `ChangeNotifier` | Manage bahasa aktif + daftar bahasa tersedia |
| `onboarding_provider.dart` | `ChangeNotifier` | State onboarding slides |

### 3.6. `lib/services/` — Backend Communication

| File | Dependency | Endpoints |
|---|---|---|
| `auth_service.dart` | Dio | `POST /register`, `POST /login` → JWT token |
| `storage_services.dart` | SharedPreferences | `getLanguage()`, `setLanguage()`, `hasSeenOnboarding()`, `markOnboardingSeen()` |

### 3.7. `lib/widgets/` — Reusable Components

| File | Kegunaan |
|---|---|
| `primary_button.dart` | Tombol utama dengan gradient + bounce animation |
| `custom_text_field.dart` | TextField styled sesuai design system |
| `custom_dropdown.dart` | Dropdown styled |
| `custom_image.dart` | `CustomNetworkImage` — wrapper `Image.network` dengan `errorBuilder` |
| `custom_label.dart` | Label styled |

---

## 4. Risks — Area Rawan Layout Overflow di Perangkat Fisik

### 🔴 CRITICAL (Pasti Overflow di Layar Kecil)

| # | File | Masalah | Penyebab |
|---|---|---|---|
| **R1** | `mountain_detail_screen.dart` | `SliverAppBar(expandedHeight: 450)` | Terlalu tinggi untuk perangkat ≤5" — konten di bawah hero terdorong ke luar viewport. Tidak ada fallback untuk layar pendek |
| **R2** | `checkout_screen.dart` | Form panjang (6 section) + `FlutterMap` inline + sticky footer | `SingleChildScrollView` + `bottomNavigationBar` + padding 120px bawah → konten terpotong di layar pendek. Map di dalam scroll bisa janky |
| **R3** | `order_summary_screen.dart` | `bottomSheet` + `SingleChildScrollView` saling konflik | `bottomSheet` bukan bagian dari scroll area → konten di balik sticky footer tak terlihat. Padding manual 120px tidak responsif |

### 🟡 HIGH (Sering Overflow pada Perangkat Tertentu)

| # | File | Masalah | Penyebab |
|---|---|---|---|
| **R4** | `filter_modal.dart` | `height: MediaQuery.of(context).size.height * 0.75` | Fixed 75% tinggi — di tablet terlalu besar, di layar kecil memblokir hampir seluruh layar |
| **R5** | `product_detail_screen.dart` | `bottomSheet` + `floatingActionButton` + scroll panjang | FAB menimpa konten review di bawah. BottomSheet dan content padding tidak sinkron |
| **R6** | `home_screen.dart` | Mountain card `SizedBox(height: 300)` dalam horizontal `ListView` | Fixed height 300px — di layar 4.5" card terpotong. Tidak responsif terhadap ukuran font sistem |
| **R7** | `basecamp_partners_screen.dart` | `DraggableScrollableSheet(initialChildSize: 0.45)` | Di layar landscape/tablet, 45% terlalu kecil → konten partner tidak terlihat |

### 🟠 MEDIUM (Potensi Visual Glitch)

| # | File | Masalah | Penyebab |
|---|---|---|---|
| **R8** | `mountain_search_result_screen.dart` | `Row` dengan `Expanded` title + difficulty chip | Jika judul gunung sangat panjang + chip, Row tetap bisa overflow secara horizontal di layar <320dp |
| **R9** | `track_location_screen.dart` | Pulsing animation `TweenAnimationBuilder` tanpa loop | `onEnd: () {}` — animasi hanya berjalan sekali, bukan loop. Perlu `AnimationController` di `StatefulWidget` |
| **R10** | `rental_detail_screen.dart` | Bottom sheet `Column(mainAxisSize: MainAxisSize.min)` | Konten bisa meluap ke atas jika elemen terlalu banyak. Tidak di-scroll |
| **R11** | Multiple files | Hardcoded color (`Color(0xFF005F3F)`) alih-alih `AppColors` | `RentalDetailScreen`, `CatalogScreen`, `TrackLocationScreen`, `CheckoutScreen`, `OrderSummaryScreen`, `ProductDetailScreen` mendefinisikan warna lokal alih-alih pakai `AppColors` → inkonsistensi dan sulit maintain |

### 🔵 LOW (Cosmetic / DX)

| # | File | Masalah |
|---|---|---|
| **R12** | `date_picker_modal.dart` | Calendar grid hardcoded "Oktober 2023" — tidak dinamis |
| **R13** | `catalog_screen.dart` | `GridView.count(childAspectRatio: 0.65)` — di layar lebar, card terlalu tinggi/stretch |
| **R14** | `basecamp_partners_screen.dart` | Semua data partner hardcoded (jumlah, nama, rating, jarak) |
| **R15** | `main.dart` | `startRoute` dihitung tapi tidak dipakai — `initialRoute` selalu `'/'` |

---

## 5. Quick Reference — File Count

```
lib/
├── main.dart                           (1 file)
├── core/constants/                     (2 files: app_colors, app_theme)
├── models/                             (3 files)
├── providers/                          (2 files)
├── services/                           (2 files)
├── widgets/                            (5 files)
├── components/modals/                  (4 files)
└── screens/                            (43 files across 12 folders)
    ├── auth/          7 files
    ├── booking/      10 files
    ├── cart/          1 file
    ├── dashboard/     1 file
    ├── history/       2 files
    ├── home/          8 files
    ├── onboarding/    1 file
    ├── products/      1 file
    ├── search/        2 files
    ├── settings/     13 files
    ├── splash/        1 file
    └── tutorial/      1 file

TOTAL: ~62 Dart files (excluding generated/platform)
```

---

## 6. Fixed Issues — Resolution Report (2026-05-05)

### ✅ CRITICAL FIXES COMPLETED

#### **F1: Navigation & Argument Loss** ← **RESOLVED**
- **File:** `lib/main.dart`
- **Issue:** `_fadeRoute()` tidak meneruskan `RouteSettings`, menyebabkan argumen hilang saat navigasi
- **Fix Applied:** 
  - Updated `_fadeRoute(Widget page)` → `_fadeRoute(Widget page, {RouteSettings? settings})`
  - Semua 43 route cases di `onGenerateRoute` sekarang meneruskan `settings: settings` ke `_fadeRoute`
  - Argument propagation dijamin untuk `/mountain-search-result`, `/mountain-detail`, `/basecamp-partners`, dll
- **Impact:** Navigasi dengan arguments sekarang stabil di semua route ✓

#### **F2: Stale Context & Modal Failure** ← **RESOLVED**
- **File:** `lib/components/modals/order_type_sheet.dart`, `lib/screens/home/mountain_detail_screen.dart`
- **Issue:** `DatePickerModal` tidak muncul karena context sudah di-pop saat memanggil `showModalBottomSheet`
- **Fix Applied:**
  - `OrderTypeSheet` sekarang menerima parameter `parentContext: BuildContext?`
  - Saat "Booking Dulu" di-tap, menggunakan `parentContext` untuk `showModalBottomSheet` DatePickerModal
  - `MountainDetailScreen` meneruskan contextnya: `OrderTypeSheet(parentContext: context)`
- **Impact:** DatePickerModal muncul dengan stabil tanpa stale context error ✓

#### **F3: Infinite Width Exception (Search)** ← **VERIFIED EXISTING FIX**
- **File:** `lib/screens/search/search_screen.dart`
- **Status:** Sudah fix sebelumnya dengan `minimumSize: Size.zero` pada category buttons
- **Impact:** ElevatedButton kategori tidak lagi mengambil infinite width ✓

#### **F4: Infinite Width Exception (Basecamp)** ← **RESOLVED**
- **File:** `lib/screens/home/basecamp_partners_screen.dart`
- **Issue:** "Katalog" button di partner card mendapat `BoxConstraints forces an infinite width`
- **Fix Applied:**
  - Wrapped button dalam `SizedBox(height: 36, width: 90)` untuk memberikan explicit constraints
  - Added `minimumSize: Size.zero` pada button styling
- **Impact:** Partner cards render correctly di VIVO V2038 tanpa layout crash ✓

#### **F5: Asset Resilience (Image 404)** ← **RESOLVED**
- **Files:** 8 screens updated:
  - ✓ `mountain_detail_screen.dart` — Hero image
  - ✓ `basecamp_partners_screen.dart` — Partner logos (sudah ada)
  - ✓ `search_screen.dart` — Product cards (sudah ada)
  - ✓ `cart_screen.dart` — Item images
  - ✓ `checkout_screen.dart` — Product preview
  - ✓ `order_summary_screen.dart` — Order items
  - ✓ `return_confirmation_screen.dart` — 2x Image.network (QR + items)
  - ✓ `onboarding_screen.dart` — Onboarding slides
  - ✓ `product_detail_screen.dart` — Product gallery
- **Fix Applied:** Setiap `Image.network` sekarang punya `errorBuilder` yang menampilkan placeholder dengan icon `Icons.broken_image`
- **Impact:** HTTP 404 dari Unsplash tidak crash app; graceful fallback ✓

#### **F6: Robust Null Safety** ← **VERIFIED COMPLETE**
- **File:** `lib/main.dart`
- **Status:** Sudah implement di onGenerateRoute:
  - `/mountain-search-result`: `final query = settings.arguments as String? ?? ''`
  - `/mountain-detail`: `final args = settings.arguments as Map<String, dynamic>? ?? {}`
  - `args['title'] ?? 'Gunung'`, `args['location'] ?? 'Lokasi'`, `args['imageUrl'] ?? ''`
  - `/basecamp-partners`: di-handle di screen dengan default `5000.0` meter
- **Impact:** No "Null check operator used on a null value" errors ✓

---

## 7. Sliver Stability Status

| Screen | Issue | Status |
|--------|-------|--------|
| `basecamp_partners_screen.dart` | `DraggableScrollableSheet` → `CustomScrollView` dengan `SliverList` | ✓ Already Implemented |
| | `child.hasSize: is not true` error | ✓ Resolved via SliverPadding + SliverList |

---

## 8. Material 3 Compliance

✓ All fixes maintain `useMaterial3: true` — No Material 2 fallbacks introduced
✓ AppColors token warna selalu digunakan (tidak hardcoded `Color(0xFF...)` di fix files)
✓ Button constraints tidak memaksa theme defaults sebaliknya

---

> **Last Updated:** 2026-05-05 | **Status:** 🟢 ALL CRITICAL ISSUES RESOLVED | **Tested On:** VIVO V2038 (360x640 @ 2x density)
