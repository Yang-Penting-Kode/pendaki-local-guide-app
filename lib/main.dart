import 'package:flutter/material.dart';
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
import 'package:pendaki_local_guide_app/screens/booking/order_summary_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/pickup_confirmation_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/return_confirmation_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/review_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/transaction_failed_screen.dart';
import 'package:pendaki_local_guide_app/screens/booking/transaction_success_screen.dart';
import 'package:pendaki_local_guide_app/screens/cart/cart_screen.dart';
import 'package:pendaki_local_guide_app/screens/dashboard/dashboard_screen.dart';
import 'package:pendaki_local_guide_app/screens/history/my_reviews_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/basecamp_partners_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/catalog_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/mountain_search_result_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/mountain_search_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/rental_detail_screen.dart';
import 'package:pendaki_local_guide_app/screens/home/track_location_screen.dart';
import 'package:pendaki_local_guide_app/screens/products/product_detail_screen.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007A52)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _fadeRoute(const SplashScreen());
          case '/onboarding':
            return _fadeRoute(const OnboardingScreen());
          case '/login':
            return _fadeRoute(const AuthGateScreen());
          case '/register':
            return _fadeRoute(const RegisterScreen());
          case '/register-success':
            return _fadeRoute(const RegistrationSuccessScreen());
          case '/tutorial':
            return _fadeRoute(const TutorialScreen());
          case '/verify-email':
            return _fadeRoute(const EmailVerificationScreen());
          case '/login-email':
            return _fadeRoute(const LoginEmailScreen());
          case '/forgot-password':
            return _fadeRoute(const ForgotPasswordScreen());
          case '/reset-password':
            return _fadeRoute(const ResetPasswordScreen());
          case '/dashboard':
            return _fadeRoute(const DashboardScreen());
          case '/mountain-search':
            return _fadeRoute(const MountainSearchScreen());
          case '/mountain-search-result':
            final query = settings.arguments as String;
            return _fadeRoute(MountainSearchResultScreen(searchQuery: query));
          case '/basecamp-partners':
            return _fadeRoute(const BasecampPartnersScreen());
          case '/rental-detail':
            return _fadeRoute(const RentalDetailScreen());
          case '/track-location':
            return _fadeRoute(const TrackLocationScreen());
          case '/catalog':
            return _fadeRoute(const CatalogScreen());
          case '/product-detail':
            return _fadeRoute(const ProductDetailScreen());
          case '/cart':
            return _fadeRoute(const CartScreen());
          case '/checkout':
            return _fadeRoute(const CheckoutScreen());
          case '/order-summary':
            return _fadeRoute(const OrderSummaryScreen());
          case '/transaction-success':
            return _fadeRoute(const TransactionSuccessScreen());
          case '/transaction-failed':
            return _fadeRoute(const TransactionFailedScreen());
          case '/pickup-confirmation':
            return _fadeRoute(const PickupConfirmationScreen());
          case '/return-confirmation':
            return _fadeRoute(const ReturnConfirmationScreen());
          case '/review':
            return _fadeRoute(const ReviewScreen());
          case '/search-empty':
            return _fadeRoute(const SearchNotFoundScreen());
          case '/my-reviews':
            return _fadeRoute(const MyReviewsScreen());
          case '/live-tracking':
            return _fadeRoute(const LiveTrackingScreen());
          case '/delivery-arrived':
            return _fadeRoute(const DeliveryArrivedScreen());
          case '/profile':
            return _fadeRoute(const ProfileScreen());
          case '/edit-profile':
            return _fadeRoute(const EditProfileScreen());
          case '/orders':
            return _fadeRoute(const OrdersScreen());
          case '/wishlist':
            return _fadeRoute(const WishlistScreen());
          case '/security-privacy':
            return _fadeRoute(const SecurityPrivacyScreen());
          case '/change-password':
            return _fadeRoute(const ChangePasswordScreen());
          case '/terms-conditions':
            return _fadeRoute(const TermsConditionsScreen());
          case '/privacy-policy':
            return _fadeRoute(const PrivacyPolicyScreen());
          case '/document-verification':
            return _fadeRoute(const DocumentVerificationScreen());
          case '/notification-settings':
            return _fadeRoute(const NotificationSettingsScreen());
          case '/help-center':
            return _fadeRoute(const HelpCenterScreen());
          case '/about-app':
            return _fadeRoute(const AboutAppScreen());
          default:
            return null;
        }
      },
    );
  }

  // 🔄 Fungsi transisi Fade halus antar halaman[cite: 6]
  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
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
