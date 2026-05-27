# 🗺️ SYSTEM MAP — MountainKit Marketplace (Pendaki App)

> **ATURAN:** Aplikasi ini adalah sisi *Consumer*. Logika data (Models) **WAJIB** berbagi/sinkron dengan Mitra App. Dilarang duplikasi entitas data.

---

## 1. Core Logic Flow: Customer Journey
```mermaid
flowchart TD
    A["HomeScreen<br/><i>Search + Filter</i>"] -->|"Search"| B["SearchResultScreen"]
    B -->|"Product Tap"| C["ProductDetailScreen"]
    C -->|"Add to Cart"| D["CartScreen"]
    D -->|"Checkout"| E["CheckoutScreen"]
    E -->|"Simulated Payment"| F["TransactionSuccessScreen"]
    F -->|"Get Ticket/QR"| G["QR_Generator_Screen"]
    G -->|"Show QR to Mitra"| H["Mitra_Scanner_App"]

2. Inversi Hardware (PENTING)
Mitra App (Penyedia): Bertindak sebagai Scanner QR (menggunakan mobile_scanner).

Marketplace App (Pendaki): Bertindak sebagai Generator QR (menggunakan qr_flutter).

Aturan: Aplikasi ini TIDAK BUTUH kamera untuk scan. Fokus utama adalah menampilkan kode QR unik (orderId) agar dipindai oleh aplikasi Mitra.

GPS Integration: Gunakan geolocator untuk menangkap posisi pendaki, lalu hitung radius (jarak) ke toko mitra terdekat untuk sorting di BasecampPartnersScreen.

3. Directory Map (Struktur Wajib - Feature First)
Struktur ini harus sama persis dengan Mitra App untuk mempermudah transfer kode.

lib/
├── app/                  # Routing & Theme setup
├── core/
│   ├── network/          # DioClient (Bypass mode untuk demo)
│   └── constants/        # AppColors (PENTING: Gunakan AppColors dari Mitra App)
├── shared/
│   └── models/           # 🚀 COPIED FROM MITRA APP (Single Source of Truth)
├── features/             # Modul domain terisolasi
│   ├── catalog/          # Product list, Search, Detail, Cart
│   ├── booking/          # Checkout, Tracking, QR Generator
│   └── auth/             # Login/Register Pendaki
└── widgets/              # Reusable components (Copy dari Mitra)

4. Argument Passing Contract
Setiap navigasi WAJIB mengikuti kontrak data dari shared/models/.

Route,Arguments,Type,Keterangan
/product-detail,ProductModel,Object,Passing full object dari ProductListProvider
/checkout,List<CartItem>,List,Data keranjang yang dipilih
/order-detail,orderId,String,Fetch dari OrderProvider

5. Survival Mode (State Management)
State: Menggunakan flutter_riverpod.

In-Memory Storage: Semua data transaksi/order/produk disimpan di Repository sebagai List<T> (Sesuai AI_RULES.md).

No SQLite/Supabase Flutter: Bypass semua network call ke backend asli selama demo berlangsung.

6. Checklist Sinkronisasi dengan Mitra
[ ] lib/shared/models/ sudah identik dengan Mitra App?

[ ] AppColors di lib/core/constants/ sudah sama?

[ ] Decimal package sudah di-import untuk semua harga?

[ ] QR_Generator_Screen sudah menggunakan orderId sebagai data QR?