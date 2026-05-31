import 'dart:math' show cos, sqrt, asin, sin, pi, pow, atan2;

class MountainData {
  final String name;
  final String location;
  final String elevation;
  final String difficulty;
  final String imageUrl;
  final double lat;
  final double lng;

  const MountainData({
    required this.name,
    required this.location,
    required this.elevation,
    required this.difficulty,
    required this.imageUrl,
    required this.lat,
    required this.lng,
  });
}

class GeolocationUtils {
  // 1. MOCK DATA GUNUNG DENGAN KOORDINAT RIIL
  static const List<MountainData> mountainList = [
    MountainData(name: 'Gunung Semeru', location: 'Lumajang, Jawa Timur', elevation: '3.676 mdpl', difficulty: 'Sulit', imageUrl: 'https://picsum.photos/seed/semeru/400/300', lat: -8.1080, lng: 112.9222),
    MountainData(name: 'Gunung Rinjani', location: 'Lombok, NTB', elevation: '3.726 mdpl', difficulty: 'Sangat Sulit', imageUrl: 'https://picsum.photos/seed/rinjani/400/300', lat: -8.4124, lng: 116.4668),
    MountainData(name: 'Gunung Prau', location: 'Wonosobo, Jawa Tengah', elevation: '2.565 mdpl', difficulty: 'Pemula', imageUrl: 'https://picsum.photos/seed/prau/400/300', lat: -7.1877, lng: 109.9227),
    MountainData(name: 'Gunung Merbabu', location: 'Boyolali, Jawa Tengah', elevation: '3.142 mdpl', difficulty: 'Menengah', imageUrl: 'https://picsum.photos/seed/merbabu/400/300', lat: -7.4556, lng: 110.4382),
    MountainData(name: 'Gunung Merapi', location: 'Sleman, DI Yogyakarta', elevation: '2.930 mdpl', difficulty: 'Sulit', imageUrl: 'https://picsum.photos/seed/merapi/400/300', lat: -7.5407, lng: 110.4457),
    MountainData(name: 'Gunung Arjuno', location: 'Pasuruan, Jawa Timur', elevation: '3.339 mdpl', difficulty: 'Sulit', imageUrl: 'https://picsum.photos/seed/arjuno/400/300', lat: -7.7294, lng: 112.5940),
    MountainData(name: 'Gunung Sindoro', location: 'Temanggung, Jawa Tengah', elevation: '3.136 mdpl', difficulty: 'Menengah', imageUrl: 'https://picsum.photos/seed/sindoro/400/300', lat: -7.3043, lng: 109.9985),
    MountainData(name: 'Gunung Papandayan', location: 'Garut, Jawa Barat', elevation: '2.665 mdpl', difficulty: 'Pemula', imageUrl: 'https://picsum.photos/seed/papandayan/400/300', lat: -7.3197, lng: 107.7294),
  ];

// START REPLACE
  // 2. FUNGSI PENCARIAN AUTOCOMPLETE
  static List<MountainData> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toLowerCase();
    return mountainList.where((m) => m.name.toLowerCase().contains(q)).toList();
  }

  // 3. HAVERSINE FORMULA (Perhitungan Jarak Bumi Asli)
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double r = 6371.0; // Radius bumi dalam KM
    final double dLat = _toRad(lat2 - lat1);
    final double dLng = _toRad(lng2 - lng1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
                     cos(_toRad(lat1)) * cos(_toRad(lat2)) *
                     sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c; // Satuan Kilometer (KM)
  }

  static double _toRad(double deg) => deg * (pi / 180);
// END REPLACE
}
