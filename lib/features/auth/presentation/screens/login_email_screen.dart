// START REPLACE
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class LoginEmailScreen extends ConsumerStatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  ConsumerState<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends ConsumerState<LoginEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// END REPLACE

  @override
  Widget build(BuildContext context) {
    // Definisi warna dari Tailwind Config HTML
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: Colors.white, // bg-surface-container-lowest
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo Section
              Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C871E), // primary-container
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1C871E).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Icon(Icons.explore,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mountain Kit',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const Text(
                    'Marketplace Rental Alat Outdoor untuk Pendakian',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // 2. Login Form
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  _buildLabel('EMAIL'),
// START REPLACE
                  _buildTextField(
                    hint: 'nama@email.com',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),

                  // Password Field Label + Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('KATA SANDI'),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Password Field Input
                  _buildTextField(
                    hint: '••••••••',
                    isPassword: true,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
// END REPLACE
                ],
              ),
              const SizedBox(height: 32),

              // 3. Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
// START REPLACE
                  onPressed: _isLoading ? null : () {
                    setState(() => _isLoading = true);
                    final result = ref.read(authProvider.notifier).login(
                          _emailController.text,
                          _passwordController.text,
                        );
                    setState(() => _isLoading = false);

                    if (result.isSuccess) {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message ?? 'Login gagal'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Masuk',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                      if (!_isLoading) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ],
                  ),
// END REPLACE
                ),
              ),

              // 4. Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ATAU',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: onSurfaceVariant.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),

              // 5. Social Login (Google)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                    backgroundColor: surfaceColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                        height: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Lanjutkan dengan Google',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Footer Note (biar ga redundan)
              // const SizedBox(height: 48),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text('Belum punya akun? ', style: TextStyle(color: onSurfaceVariant)),
              //     GestureDetector(
              //       onTap: () => Navigator.pushNamed(context, '/register'),
              //       child: const Text(
              //         'Daftar Sekarang',
              //         style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: const Color(0xFF3F4A3B).withOpacity(0.6),
        ),
      ),
    );
  }

// START REPLACE
  // Helper Widget TextField
  Widget _buildTextField({
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return Container(
// END REPLACE
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
// START REPLACE
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
// END REPLACE
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF006C0C), width: 2),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
