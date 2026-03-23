import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import 'sign_in_screen.dart';
import 'main_shell.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();

    final success = await auth.signUp(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: context.adaptiveSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Back
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: context.cardColorStrong,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_back_ios_new, size: 18, color: context.textPrimary),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Create Account',
                    style: GoogleFonts.manrope(
                        fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: context.textPrimary)),
                const SizedBox(height: 8),
                Text('Sign up to get started with TaskFlow',
                    style: GoogleFonts.inter(fontSize: 15, color: context.textSecondary)),
                const SizedBox(height: 32),

                // Error banner
                if (auth.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.urgentRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.urgentRed.withValues(alpha: 0.3)),
                    ),
                    child: Row(children: [
                      Icon(Icons.error_outline, size: 20, color: AppColors.urgentRed),
                      const SizedBox(width: 10),
                      Expanded(child: Text(auth.error!,
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.urgentRed))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],

                // Full Name
                _label('Full Name'),
                _field(_nameCtrl, 'Enter your full name', Icons.person_outline,
                    validator: AuthProvider.validateName),
                const SizedBox(height: 16),

                // Email
                _label('Email'),
                _field(_emailCtrl, 'Enter your email', Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthProvider.validateEmail),
                const SizedBox(height: 16),

                // Password
                _label('Password'),
                _field(_passCtrl, 'Min 6 characters', Icons.lock_outline,
                    obscure: _obscurePass,
                    validator: AuthProvider.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20, color: context.textSecondary),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    )),
                const SizedBox(height: 16),

                // Confirm Password
                _label('Confirm Password'),
                _field(_confirmCtrl, 'Re-enter your password', Icons.lock_outline,
                    obscure: _obscureConfirm,
                    validator: (v) => AuthProvider.validateConfirmPassword(_passCtrl.text, v),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20, color: AppColors.onSurfaceVariant),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    )),
                const SizedBox(height: 28),

                // Sign Up button
                SizedBox(
                  width: double.infinity, height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 15))],
                    ),
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                      ),
                      child: auth.isLoading
                          ? const SizedBox(width: 24, height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text('Create Account',
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign in link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(style: GoogleFonts.inter(fontSize: 14, color: context.textSecondary), children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(text: 'Sign In', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
      );

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {bool obscure = false, TextInputType? keyboardType,
      String? Function(String?)? validator, Widget? suffixIcon}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 15, color: context.textHint),
        prefixIcon: Icon(icon, size: 20, color: context.textSecondary.withValues(alpha: 0.6)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: context.inputFillStrong,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.urgentRed.withValues(alpha: 0.5))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.urgentRed.withValues(alpha: 0.5))),
        errorStyle: GoogleFonts.inter(fontSize: 11, color: AppColors.urgentRed),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
