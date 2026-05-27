# 🚀 PRODUCT REQUIREMENT DOCUMENT: MARKETPLACE MVP (CRASH SPRINT)

**Tujuan:** Demo alur *End-to-End* (Pendaki -> Mitra) untuk Investor dalam waktu 48 jam (Deadline: Jumat).
**Status:** SURVIVAL MODE (Backend Bypass, In-Memory Storage).

---

## 📅 SPRINT BREAKDOWN (4 HALF-DAY SPRINTS)

| Sprint | Fokus Waktu | Deliverables |
| :--- | :--- | :--- |
| **S1: Foundation** | Hari 1 - Pagi | Migrasi `lib/shared/models/` & `lib/core/` dari Mitra App. Setup Riverpod & Pubspec. |
| **S2: Catalog & Booking** | Hari 1 - Siang/Malam | Implementasi `ProductList` & `CartProvider` (In-Memory). Navigasi Search ke Detail. |
| **S3: Checkout & QR** | Hari 2 - Pagi | Checkout UI. Simulasi pembayaran (button klik) -> Generate QR Code (`qr_flutter`). |
| **S4: Fire Drill** | Hari 2 - Siang/Malam | End-to-End Test: Pendaki Checkout -> Generate QR -> Mitra Scan -> Cek Status di Mitra App. |

---

## 🎯 DEMO HIGHLIGHTS (HAPPY PATH)

1. **Pencarian & Katalog:** Pendaki mencari alat, pilih produk, masuk keranjang. (Gunakan `ProductProvider` dari Mitra App, *hardcoded* di Repository).
2. **Tiket QR (The Bridge):** Setelah Checkout sukses, aplikasi **generate QR Code** yang berisi `orderId` transaksi menggunakan package `qr_flutter`. Ini adalah jembatan penghubung ke aplikasi Mitra.
3. **End-to-End Handshake:**
   - Pendaki menunjukkan QR di aplikasi Pendaki.
   - Mitra membuka aplikasi Mitra (Scanner).
   - Status di aplikasi Mitra berubah dari `awaitingConfirmation` menjadi `activeRental` (Real-time simulasi).

---

## 🛠️ ATURAN MAIN (SURVIVAL MODE)

1. **Reuse is King:** DILARANG membuat widget/model baru jika sudah ada di Mitra App. *Copy-paste* semua dari `widgets/` dan `shared/models/`.
2. **Bypass Backend:** Tidak ada integrasi API nyata. Semua data transaksi, produk, dan order **WAJIB** disimpan di `List<T>` dalam Repository (In-Memory).
3. **UI Minimalis:** Fokus pada fungsionalitas tombol. Jangan habiskan waktu untuk animasi rumit. Gunakan *skeleton/shimmer* yang sudah ada.
4. **Single Source of Truth:** `lib/shared/models/` adalah sumber kebenaran data. Jangan ubah field model di aplikasi Pendaki tanpa menyelaraskannya di aplikasi Mitra.

---

## 🏗️ CHECKLIST MIGRASI (DAY 1 PAGI)

- [ ] Update `pubspec.yaml` (Tambah `riverpod`, `decimal`, `qr_flutter`, `geolocator`).
- [ ] Hapus `lib/models/` lama.
- [ ] Copy `lib/shared/models/` dari Mitra App ke `lib/shared/models/`.
- [ ] Copy `lib/core/` dari Mitra App.
- [ ] Implementasi `ProviderScope` di `main.dart`.