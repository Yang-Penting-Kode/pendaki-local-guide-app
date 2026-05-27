# 🏔️ PENDAKI MARKETPLACE APP - MIGRATION & ECOSYSTEM BLUEPRINT
**Status:** Legacy MVC -> Transitioning to Feature-First (DDD-Lite) + Riverpod
**Context:** Aplikasi ini adalah sisi "Consumer/Pendaki" dari ekosistem MountainKit. Wajib tersinkronisasi dengan model data dari aplikasi Mitra.

## 1. ⚙️ PUBSPEC & DEPENDENCY SYNC (URGENT)
Sebelum menyentuh kode apapun, wajib selaraskan `pubspec.yaml`:
- **AKTIFKAN RIVERPOD:** Hapus komentar pada `flutter_riverpod: ^2.5.1` untuk menyalakan mesin state management.
- **INJEKSI DEPENDENSI WAJIB:** Tambahkan `decimal: ^3.0.2` (wajib untuk model uang/transaksi), `qr_flutter: ^4.1.0` (untuk generator tiket), dan `geolocator: ^11.1.0` (untuk melacak lokasi pendaki).

## 2. 🧬 CORE DATA MIGRATION (THE HOLY GRAIL)
Aplikasi ini DILARANG memiliki definisi model datanya sendiri untuk entitas utama.
- **HAPUS:** Direktori `lib/models/` bawaan aplikasi ini beserta seluruh isinya.
- **INJEKSI:** Salin seluruh direktori `lib/shared/models/` (beserta isinya seperti `product_model.dart`, `order_model.dart`, `store_model.dart`) dari repositori **Mitra App** ke dalam repositori ini. Ini adalah *Single Source of Truth*.

## 3. 🏛️ ARCHITECTURE RESTRUCTURING (DDD-LITE)
Migrasikan arsitektur *legacy* menuju struktur *Feature-First*:
- **Pindahkan Provider:** Relokasi `settings_provider.dart` dan `onboarding_provider.dart` ke dalam `lib/features/settings/providers/` dan `lib/features/onboarding/providers/`.
- **Hancurkan Folder Lama:** Hapus direktori `lib/providers/` secara permanen setelah isinya dipindahkan.
- **Bungkus Aplikasi:** Pastikan `runApp()` di `main.dart` dibungkus dengan `ProviderScope`.

## 4. 🔄 HARDWARE INVERSION RULES (PENDAMPING MITRA)
Fitur *hardware native* di aplikasi ini bertindak sebagai kebalikan dari aplikasi Mitra:
- **QR Code (Tiket):** Aplikasi ini TIDAK butuh scanner. Gunakan `qr_flutter` untuk **menghasilkan (generate)** barcode di layar `ReturnEquipmentScreen` atau `PickupConfirmationScreen` agar bisa dipindai oleh Mitra.
- **Sistem GPS:** Gunakan `geolocator` untuk menangkap lokasi pendaki saat membuka `BasecampPartnersScreen`, lalu urutkan data Mitra terdekat berdasarkan kalkulasi radius matriks jarak dari titik GPS tersebut.
- **UI System:** Salin utilitas UI dari Mitra (seperti `primary_button.dart`, `custom_text_field.dart`, dan file `app_colors.dart` yang sudah matang) untuk menjaga konsistensi *Design System*.