import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _success = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();

    final ok = await auth.resetPassword(
      email: _emailCtrl.text,
      newPassword: _passCtrl.text,
    );

    if (ok && mounted) {
      setState(() => _success = true);
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
                Text('Reset Password',
                    style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: context.textPrimary)),
                const SizedBox(height: 8),
                Text('Enter your email and a new password',
                    style: GoogleFonts.inter(fontSize: 15, color: context.textSecondary)),
                const SizedBox(height: 32),

                if (_success) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lowGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.lowGreen.withValues(alpha: 0.3)),
                    ),
                    child: Column(children: [
                      Icon(Icons.check_circle, size: 48, color: AppColors.lowGreen),
                      const SizedBox(height: 12),
                      Text('Password Reset Successfully!',
                          style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimary)),
                      const SizedBox(height: 8),
                      Text('You can now sign in with your new password.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 14, color: context.textSecondary)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Back to Sign In',
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ]),
                  ),
                ] else ...[
                  if (auth.error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.urgentRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
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

                  _label('Email'),
                  TextFormField(
                    controller: _emailCtrl,
                    validator: AuthProvider.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.inter(fontSize: 15),
                    decoration: _inputDec('Enter your email', Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),

                  _label('New Password'),
                  TextFormField(
                    controller: _passCtrl,
                    validator: AuthProvider.validatePassword,
                    obscureText: _obscure,
                    style: GoogleFonts.inter(fontSize: 15),
                    decoration: _inputDec('Min 6 characters', Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20, color: context.textSecondary),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _label('Confirm New Password'),
                  TextFormField(
                    controller: _confirmCtrl,
                    validator: (v) => AuthProvider.validateConfirmPassword(_passCtrl.text, v),
                    obscureText: true,
                    style: GoogleFonts.inter(fontSize: 15),
                    decoration: _inputDec('Re-enter password', Icons.lock_outline),
                  ),
                  const SizedBox(height: 28),

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
                          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(width: 24, height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : Text('Reset Password',
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
      );

  InputDecoration _inputDec(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 15, color: context.textHint),
        prefixIcon: Icon(icon, size: 20, color: context.textSecondary.withValues(alpha: 0.6)),
        filled: true,
        fillColor: context.inputFillStrong,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.urgentRed.withValues(alpha: 0.5))),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.urgentRed.withValues(alpha: 0.5))),
        errorStyle: GoogleFonts.inter(fontSize: 11, color: AppColors.urgentRed),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      );
}
