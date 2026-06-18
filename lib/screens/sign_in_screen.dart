import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';
import 'main_shell.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();

    final success = await auth.signIn(email: _emailCtrl.text, password: _passCtrl.text);

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
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
                const SizedBox(height: 60),
                // Logo
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 28),
                Text(
                  tr(context, 'welcome_back'),
                  style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: context.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(tr(context, 'sign_in_subtitle'), style: GoogleFonts.inter(fontSize: 15, color: context.textSecondary)),
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
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, size: 20, color: AppColors.urgentRed),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            localizedAuthMessage(context, auth.error!),
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.urgentRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email
                _label(tr(context, 'email')),
                TextFormField(
                  controller: _emailCtrl,
                  validator: (value) {
                    final message = AuthProvider.validateEmail(value);
                    return message == null ? null : localizedAuthMessage(context, message);
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
                  decoration: _inputDec(tr(context, 'enter_email'), Icons.email_outlined),
                ),
                const SizedBox(height: 16),

                // Password
                _label(tr(context, 'password')),
                TextFormField(
                  controller: _passCtrl,
                  validator: (value) {
                    final message = AuthProvider.validatePassword(value);
                    return message == null ? null : localizedAuthMessage(context, message);
                  },
                  obscureText: _obscure,
                  style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
                  decoration: _inputDec(tr(context, 'enter_password'), Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: context.textSecondary),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: Text(
                      tr(context, 'forgot_password'),
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Sign In button
                SizedBox(
                  width: double.infinity,
                  height: 56,
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
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              tr(context, 'sign_in'),
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(tr(context, 'or'), style: GoogleFonts.inter(fontSize: 13, color: context.textSecondary)),
                    ),
                    Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign up link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(fontSize: 14, color: context.textSecondary),
                        children: [
                          TextSpan(text: tr(context, 'no_account')),
                          TextSpan(
                            text: tr(context, 'sign_up'),
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary),
    ),
  );

  InputDecoration _inputDec(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.inter(fontSize: 15, color: context.textHint),
    prefixIcon: Icon(icon, size: 20, color: context.textSecondary.withValues(alpha: 0.6)),
    filled: true,
    fillColor: context.inputFillStrong,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.urgentRed.withValues(alpha: 0.5)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.urgentRed.withValues(alpha: 0.5)),
    ),
    errorStyle: GoogleFonts.inter(fontSize: 11, color: AppColors.urgentRed),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );
}
