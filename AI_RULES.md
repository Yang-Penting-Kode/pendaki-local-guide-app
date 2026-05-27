---

### 2. `AI_RULES.md` (Marketplace Edition)
Aturan ini memastikan kita tidak "lari" dari arsitektur yang sudah kita bangun susah payah.

```markdown
# 🛡️ ABSOLUTE AI CODING RULES (MARKETPLACE)

1. **JANGAN REINVENT THE WHEEL (Data):**
   - DILARANG keras membuat model data baru untuk `Product`, `Order`, `Store`, `Transaction`.
   - WAJIB import dari `package:mitra_mountainkit_app/shared/models/` (via git submodule atau copy manual).
   
2. **KONTRAK DATA:**
   - Semua model uang/harga WAJIB menggunakan `decimal` package (Aturan #3).
   - Pastikan tipe data `Decimal` tetap konsisten saat dikirim ke Backend.

3. **STATE MANAGEMENT:**
   - Gunakan `riverpod`. Alur: `UI` -> `Provider` -> `Repository` -> `Dio`.
   - `Repository` wajib melakukan bypass ke InMemory Storage selama `SURVIVAL DEMO MODE`.

4. **HARDWARE INVERSION:**
   - Jangan implementasi `mobile_scanner` di sisi Pendaki. Gunakan `qr_flutter` untuk menampilkan ID Pesanan sebagai Barcode/QR.
   - Gunakan `geolocator` hanya untuk kalkulasi radius pencarian mitra (filter by distance).

5. **UI BENTO-STYLE (Konsistensi):**
   - Ikuti Design System yang sama dengan Mitra App: `Primary: #006C0C`, `Secondary: #904D00`.
   - Gunakan `CustomNetworkImage` dan `PrimaryButton` yang sudah ada di Mitra App.