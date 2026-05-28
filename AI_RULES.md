# 🛡️ ABSOLUTE AI CODING RULES (MARKETPLACE)

Dokumen ini adalah hukum tertinggi bagi AI. Setiap kali melakukan `CONTEXT_RELOAD`, AI WAJIB membaca dan mematuhi seluruh aturan di bawah ini tanpa terkecuali.

## 🤖 PART A: AI INTERACTION & PROMPT PROTOCOL
1. **ANTI-HALUSINASI (CONTEXT7 / MCP):**
   - AI dilarang menebak-nebak struktur folder, nama file, atau logika *codebase* yang ada. 
   - WAJIB berpatokan pada sumber *knowledge* `Context7` (Integrasi Model Context Protocol/MCP) sebagai sumber kebenaran (*Source of Truth*) sebelum menulis kode. Jika tidak yakin, minta pengguna memberikan file referensi.
2. **PHASE AWARENESS (`CONTEXT_RELOAD`):**
   - AI wajib memahami di tahap (Phase) mana proyek saat ini berada sebelum memberikan solusi. Gunakan instruksi `CONTEXT_RELOAD` untuk mensinkronkan memori progres.
3. **FORMAT OUTPUT KODE (`START REPLACE` & `END REPLACE`):**
   - DILARANG memberikan *output* satu file kode penuh (*full file rewrite*) jika hanya melakukan modifikasi sebagian.
   - WAJIB menggunakan blok `// START REPLACE` dan `// END REPLACE` untuk area kode yang diubah agar token efisien dan kode tidak terpotong (*cut-off*).
4. **IMMUTABILITY (HANYA SENTUH YANG PERLU):**
   - DILARANG mengubah, menghapus, atau merombak kode, UI, atau *logic* yang sudah aman dan berfungsi.
   - Fokus HANYA pada penambahan atau perbaikan yang relevan dengan instruksi Fase MVP Simulasi saat ini.

## 🏗️ PART B: ARCHITECTURE & DATA STANDARD
1. **JANGAN REINVENT THE WHEEL (Data):**
   - DILARANG keras membuat model data baru untuk `Product`, `Order`, `Store`, `Transaction`.
   - WAJIB import dari `package:mitra_mountainkit_app/shared/models/` (via git submodule atau copy manual)[cite: 5].
2. **KONTRAK DATA FINANSIAL:**
   - Semua model uang/harga WAJIB menggunakan `decimal` package[cite: 5]. Tidak boleh menggunakan `double` untuk mencegah *floating-point error*.
   - Pastikan tipe data `Decimal` tetap konsisten saat dikirim ke Backend atau divalidasi[cite: 5].
3. **STATE MANAGEMENT (RIVERPOD):**
   - Gunakan `riverpod`[cite: 5]. Alur: `UI` -> `Provider` -> `Repository` -> `Mock API/In-Memory`.
   - `Repository` wajib melakukan bypass ke InMemory Storage selama `SURVIVAL DEMO MODE`[cite: 5].
4. **HARDWARE INVERSION (MVP BRIDGE):**
   - Jangan implementasi scanner kamera (`mobile_scanner`) di sisi Pendaki[cite: 5].
   - Gunakan package `qr_flutter` untuk merender/menampilkan ID Pesanan terenkapsulasi JSON sebagai Barcode/QR[cite: 5].
   - Gunakan `geolocator` hanya untuk kalkulasi radius pencarian mitra (filter by distance)[cite: 5].
5. **UI BENTO-STYLE (Konsistensi):**
   - Ikuti Design System yang sama dengan Mitra App: `Primary: #006C0C`, `Secondary: #904D00`[cite: 5].
   - Gunakan `CustomNetworkImage` dan `PrimaryButton` yang sudah ada di proyek untuk menjaga estetik UI[cite: 5].