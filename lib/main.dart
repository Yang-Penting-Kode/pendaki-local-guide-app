import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/core/constants/app_theme.dart';
import 'package:pendaki_local_guide_app/screens/auth/auth_gate_screen.dart';
import 'package:pendaki_local_guide_app/screens/auth/email_verification_screen.dart';
import 'package:pendaki_local_guide_app/screens/auth/forgot_password_screen.dart';
import 'package:pendaki_local_guide_app/screens/auth/login_email_screen.dart';
import 'package:pendaki_local_guide_app/screens/auth/register_screen.dart';
import 'package:pendaki_local_guide_app/screens/auth/registration_success_screen.dart';
import 'package:pendaki_local_guide_app/screens/auth/reset_password_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/checkout_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/delivery_arrived_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/live_tracking_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/order_cancelled_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/order_detail_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/order_summary_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/pickup_confirmation_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/return_confirmation_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/return_equipment_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/review_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/transaction_failed_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/transaction_success_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/waiting_confirmation_screen.dart';
import 'package:pendaki_local_guide_app/screens/cart/cart_screen.dart';
import 'package:pendaki_local_guide_app/screens/dashboard/dashboard_screen.dart';
import 'package:pendaki_local_guide_app/screens/history/my_reviews_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/basecamp_partners_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/catalog_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/mountain_detail_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/mountain_search_result_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/mountain_search_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/rental_detail_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/track_location_screen.dart';
import 'package:pendaki_local_guide_app/screens/products/product_detail_screen.dart';
import 'package:pendaki_local_guide_app/screens/search/product_category_screen.dart';
import 'package:pendaki_local_guide_app/screens/search/product_search_result_screen.dart';
import 'package:pendaki_local_guide_app/screens/search/search_not_found_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/about_app_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/change_password_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/document_verification_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/edit_profile_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/help_center_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/notification_settings_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/orders_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/privacy_policy_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/profile_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/security_privacy_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/terms_conditions_screen.dart';
import 'package:pendaki_local_guide_app/screens/settings/wishlist_screen.dart';
import 'package:pendaki_local_guide_app/screens/tutorial/tutorial_screen.dart';
import 'package:pendaki_local_guide_app/services/storage_services.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  // Inisialisasi wajib untuk Flutter & SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); // 🚀 Inisialisasi storage
  runApp(const LocalGuideApp());
}

class LocalGuideApp extends StatelessWidget {
  const LocalGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String startRoute =
        StorageService.hasSeenOnboarding() ? '/login' : '/onboarding';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mountain Kit',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _fadeRoute(const SplashScreen(), settings: settings);
          case '/onboarding':
            return _fadeRoute(const OnboardingScreen(), settings: settings);
          case '/login':
            return _fadeRoute(const AuthGateScreen(), settings: settings);
          case '/register':
            return _fadeRoute(const RegisterScreen(), settings: settings);
          case '/register-success':
            return _fadeRoute(const RegistrationSuccessScreen(),
                settings: settings);
          case '/tutorial':
            return _fadeRoute(const TutorialScreen(), settings: settings);
          case '/verify-email':
            return _fadeRoute(const EmailVerificationScreen(),
                settings: settings);
          case '/login-email':
            return _fadeRoute(const LoginEmailScreen(), settings: settings);
          case '/forgot-password':
            return _fadeRoute(const ForgotPasswordScreen(), settings: settings);
          case '/reset-password':
            return _fadeRoute(const ResetPasswordScreen(), settings: settings);
          case '/dashboard':
            return _fadeRoute(const DashboardScreen(), settings: settings);
          case '/mountain-search':
            return _fadeRoute(const MountainSearchScreen(), settings: settings);
          case '/mountain-search-result':
            final query = settings.arguments as String? ?? '';
            return _fadeRoute(MountainSearchResultScreen(searchQuery: query),
                settings: settings);
          case '/mountain-detail':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return _fadeRoute(
              MountainDetailScreen(
                title: args['title'] ?? 'Gunung',
                location: args['location'] ?? 'Lokasi',
                imageUrl: args['imageUrl'] ?? '',
              ),
              settings: settings,
            );
          case '/basecamp-partners':
            return _fadeRoute(const BasecampPartnersScreen(),
                settings: settings);
          case '/rental-detail':
            return _fadeRoute(const RentalDetailScreen(), settings: settings);
          case '/track-location':
            return _fadeRoute(const TrackLocationScreen(), settings: settings);
          case '/catalog':
            return _fadeRoute(const CatalogScreen(), settings: settings);
          case '/product-detail':
            return _fadeRoute(const ProductDetailScreen(), settings: settings);
          case '/cart':
            return _fadeRoute(const CartScreen(), settings: settings);
          case '/checkout':
            return _fadeRoute(const CheckoutScreen(), settings: settings);
          case '/order-summary':
            return _fadeRoute(const OrderSummaryScreen(), settings: settings);
          case '/transaction-success':
            return _fadeRoute(const TransactionSuccessScreen(),
                settings: settings);
          case '/transaction-failed':
            return _fadeRoute(const TransactionFailedScreen(),
                settings: settings);
          case '/order-detail':
            return _fadeRoute(const OrderDetailScreen(), settings: settings);
          case '/pickup-confirmation':
            return _fadeRoute(const PickupConfirmationScreen(),
                settings: settings);
          case '/return-equipment':
            return _fadeRoute(const ReturnEquipmentScreen(),
                settings: settings);
          case '/return-confirmation':
            return _fadeRoute(const ReturnConfirmationScreen(),
                settings: settings);
          case '/waiting-confirmation':
            return _fadeRoute(const WaitingConfirmationScreen(),
                settings: settings);
          case '/order-cancelled':
            return _fadeRoute(const OrderCancelledScreen(), settings: settings);
          case '/review':
            return _fadeRoute(const ReviewScreen(), settings: settings);
          case '/search-empty':
            return _fadeRoute(const SearchNotFoundScreen(), settings: settings);
          case '/product-search-result':
            final query = settings.arguments as String? ?? '';
            return _fadeRoute(ProductSearchResultScreen(initialQuery: query),
                settings: settings);
          case '/product-category':
            return _fadeRoute(const ProductCategoryScreen());
          case '/my-reviews':
            return _fadeRoute(const MyReviewsScreen(), settings: settings);
          case '/live-tracking':
            return _fadeRoute(const LiveTrackingScreen(), settings: settings);
          case '/delivery-arrived':
            return _fadeRoute(const DeliveryArrivedScreen(),
                settings: settings);
          case '/profile':
            return _fadeRoute(const ProfileScreen(), settings: settings);
          case '/edit-profile':
            return _fadeRoute(const EditProfileScreen(), settings: settings);
          case '/orders':
            return _fadeRoute(const OrdersScreen(), settings: settings);
          case '/wishlist':
            return _fadeRoute(const WishlistScreen(), settings: settings);
          case '/security-privacy':
            return _fadeRoute(const SecurityPrivacyScreen(),
                settings: settings);
          case '/change-password':
            return _fadeRoute(const ChangePasswordScreen(), settings: settings);
          case '/terms-conditions':
            return _fadeRoute(const TermsConditionsScreen(),
                settings: settings);
          case '/privacy-policy':
            return _fadeRoute(const PrivacyPolicyScreen(), settings: settings);
          case '/document-verification':
            return _fadeRoute(const DocumentVerificationScreen(),
                settings: settings);
          case '/notification-settings':
            return _fadeRoute(const NotificationSettingsScreen(),
                settings: settings);
          case '/help-center':
            return _fadeRoute(const HelpCenterScreen(), settings: settings);
          case '/about-app':
            return _fadeRoute(const AboutAppScreen(), settings: settings);
          default:
            return null;
        }
      },
    );
  }

  // 🔄 Fungsi transisi Fade halus antar halaman dengan RouteSettings[cite: 6]
  PageRouteBuilder _fadeRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
          child: child,
        );
      },
    );
  }
}
