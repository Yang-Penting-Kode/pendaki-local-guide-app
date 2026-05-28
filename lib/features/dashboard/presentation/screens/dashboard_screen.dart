import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/presentation/screens/booking_screen.dart';
import 'package:pendaki_local_guide_app/screens/history/history_screen.dart';
import 'package:pendaki_local_guide_app/screens/search/search_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/settings_screen.dart';
import 'package:pendaki_local_guide_app/features/home/presentation/screens/home_screen.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  // 1. Daftar 5 Halaman sesuai menu baru
  final List<Widget> _pages = [
    const HomeScreen(),
    const BookingScreen(),
    const SearchScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = ref.watch(activeOrderCountProvider);

    // Warna sesuai brand Mountain Kit
    const Color primaryColor = Color(0xFF006C0C);
    const Color unselectedColor = Color(0xFF9E9E9E);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 24,
              offset: const Offset(0, -12),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type:
              BottomNavigationBarType.fixed, // Penting agar >3 menu tidak geser
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: unselectedColor,
          showUnselectedLabels:
              true, // Biar label tetap muncul meskipun tidak diklik
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, fill: 1.0),
              label: 'BERANDA',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: activeCount > 0,
                label: Text(activeCount.toString()),
                child: const Icon(Icons.calendar_today_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: activeCount > 0,
                label: Text(activeCount.toString()),
                child: const Icon(Icons.calendar_today),
              ),
              label: 'BOOKING',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search, weight: 700),
              label: 'CARI',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history_toggle_off),
              label: 'RIWAYAT',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'PENGATURAN',
            ),
          ],
        ),
      ),
    );
  }
}
