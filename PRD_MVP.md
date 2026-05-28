# 🚀 PRODUCT REQUIREMENT DOCUMENT: MARKETPLACE MVP (CRASH SPRINT)

**Tujuan:** Demo alur *End-to-End* (Pendaki -> Mitra) untuk Investor dalam waktu 48 jam (Deadline: Jumat).
**Status:** SURVIVAL MODE (Backend Bypass, In-Memory Storage).

---

## 📅 SPRINT BREAKDOWN (5 HALF-DAY SPRINTS)

| Sprint | Fokus Waktu | Deliverables |
| :--- | :--- | :--- |
| **S1: Foundation** | Hari 1 - Pagi | Migrasi `lib/shared/models/` & `lib/core/` dari Mitra App. Setup Riverpod & Pubspec. |
| **S2: Auth Login & Register** | Hari 1 - Pagi/Siang | Implementasi `Auth Login` & `Auth Register` (In-Memory). Navigasi Search ke Home dan Logout apakah data tetap tersimpan dan bisa digunakan login. |
| **S3: Catalog & Booking** | Hari 1 - Siang/Malam | Implementasi `ProductList` & `CartProvider` (In-Memory). Navigasi Search ke Detail. |
| **S4: Checkout & QR** | Hari 2 - Pagi | Checkout UI. Simulasi pembayaran (button klik) -> Generate QR Code (`qr_flutter`). |
| **S5: UX Polish & Advanced Flows** | Hari 2 - Siang | **[NEW]** Finansial Logic (Ongkir), Sync Qty, Upload Simaksi, UI Cleanup, & QR State Validation. |
| **S6: Fire Drill** | Hari 2 - Malam | End-to-End Test: Pendaki Checkout -> Konfirmasi Pengambilan -> Mitra Scan -> Cek Status di Mitra App. |

---

## 🎯 DEMO HIGHLIGHTS (THE NEW HAPPY PATH)

1. **Pencarian, Katalog, & Keranjang Terkunci:** Pendaki mencari alat, pilih produk, dan mengatur *quantity* di Keranjang. Saat masuk Checkout, *quantity* terkunci (Sync & Lock) agar tidak terjadi manipulasi data.
2. **Checkout Finansial & Dokumen:**
   - Pendaki mengunggah gambar tiket pendakian (Simaksi) menggunakan *Image Picker* (Galeri).
   - Teks pengiriman dinamis mengikuti Gunung/Jalur via yang dipilih.
   - **Unit Economics (Ongkir):** Otomatis mengkalkulasi Biaya Pengantaran (Motor/Mobil) berdasarkan beban pesanan. Total Biaya = Harga Sewa (dengan markup) + Ongkir + Biaya Admin.
3. **Tiket QR & Validasi (The Bridge):**
   - Setelah bayar, QR Code di-generate dengan status **"Belum Valid"**.
   - Pendaki harus masuk ke *Order Detail* dan menekan tombol **"Konfirmasi Pengambilan"** untuk memvalidasi QR. Payload JSON QR dikunci rapat: `{"order_id": "...", "source": "mountain_kit_consumer"}`.
4. **End-to-End Handshake:**
   - Pendaki menunjukkan QR yang sudah "Valid".
   - Mitra membuka aplikasi Mitra (Scanner) dan memindai QR.
   - Status di aplikasi Mitra berubah dari `awaitingConfirmation` menjadi `activeRental` secara seketika.
5. **Dashboard Interactivity:** Menampilkan badge notifikasi pesanan aktif, modal notifikasi, dan *Quick Actions* langsung dari Beranda (Alat Sedang Disewa & Jadwal Pengembalian).

---

## 🛠️ ATURAN MAIN (SURVIVAL MODE)

1. **Reuse is King:** DILARANG membuat widget/model baru jika sudah ada di Mitra App. *Copy-paste* semua dari `widgets/` dan `shared/models/`.
2. **Bypass Backend:** Tidak ada integrasi API nyata. Semua data transaksi, produk, dan order **WAJIB** disimpan di `List<T>` dalam Repository (In-Memory)[cite: 5].
3. **UI Minimalis tapi Premium:** Fokus pada fungsionalitas dan interaksi Bento-Style. Hapus tombol *back* di 5 menu utama agar navigasi aman.
4. **Single Source of Truth:** `lib/shared/models/` adalah sumber kebenaran data[cite: 5]. Karena ada penambahan kalkulasi Ongkos Kirim (*Delivery Fee*), modifikasi pada `OrderModel` di aplikasi Pendaki **WAJIB** disinkronkan ke aplikasi Mitra.

---

## 🏗️ CHECKLIST MIGRASI (DAY 1 PAGI)

- [x] Update `pubspec.yaml` (Tambah `riverpod`, `decimal`, `qr_flutter`, `geolocator`, `image_picker`).
- [x] Hapus `lib/models/` lama.
- [x] Copy `lib/shared/models/` & `lib/core/` dari Mitra App.
- [x] Implementasi `ProviderScope` di `main.dart`.