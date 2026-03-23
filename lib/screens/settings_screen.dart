import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';
import 'sign_in_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final cardColor = context.cardColor;
    final borderColor = context.cardBorder;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Text(tr(context, 'settings'),
                style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          ),
        ),
        const SizedBox(height: 28),
        // Profile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () => _editProfile(context, auth),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
              child: Row(children: [
                Container(width: 56, height: 56,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                    child: Center(child: Text(user != null ? user.name[0].toUpperCase() : 'U',
                        style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user?.name ?? 'User', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.onSurfaceVariant)),
                ])),
                Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle(context, tr(context, 'preferences')),
        const SizedBox(height: 12),
        _toggleItem(Icons.dark_mode_outlined, tr(context, 'dark_mode'), sp.isDarkMode, (v) => sp.toggleDarkMode(v), cardColor, borderColor),
        const SizedBox(height: 8),
        _toggleItem(Icons.notifications_outlined, tr(context, 'push_notifications'), sp.notifications, (v) => sp.toggleNotifications(v), cardColor, borderColor),
        const SizedBox(height: 8),
        _toggleItem(Icons.volume_up_outlined, tr(context, 'sound_effects'), sp.soundEffects, (v) => sp.toggleSoundEffects(v), cardColor, borderColor),
        const SizedBox(height: 24),
        _sectionTitle(context, tr(context, 'general')),
        const SizedBox(height: 12),
        _menuItemTap(Icons.language, tr(context, 'language'), sp.isArabic ? 'العربية' : 'English', () => _pickLanguage(context, sp), cardColor, borderColor),
        const SizedBox(height: 8),
        _menuItem(Icons.info_outline, tr(context, 'about'), 'v1.0.0', cardColor, borderColor),
        const SizedBox(height: 8),
        _menuItem(Icons.help_outline, tr(context, 'help_support'), '', cardColor, borderColor),
        const SizedBox(height: 24),
        // Sign out
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: Text(tr(context, 'sign_out_title'), style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                  content: Text(tr(context, 'sign_out_msg'), style: GoogleFonts.inter()),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(tr(context, 'cancel'))),
                    TextButton(onPressed: () => Navigator.pop(ctx, true),
                        child: Text(tr(context, 'sign_out'), style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.urgentRed))),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await auth.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()), (_) => false);
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.urgentRed.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.logout, size: 20, color: AppColors.urgentRed),
                const SizedBox(width: 8),
                Text(tr(context, 'sign_out'), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.urgentRed)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  void _editProfile(BuildContext context, AuthProvider auth) {
    final user = auth.currentUser;
    if (user == null) return;
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: BoxDecoration(color: context.adaptiveSurface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(tr(context, 'edit_profile'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          TextField(controller: nameCtrl, style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(labelText: tr(context, 'full_name'), labelStyle: GoogleFonts.inter(fontSize: 13),
                  prefixIcon: const Icon(Icons.person_outline, size: 20))),
          const SizedBox(height: 12),
          TextField(controller: emailCtrl, style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(labelText: tr(context, 'email'), labelStyle: GoogleFonts.inter(fontSize: 13),
                  prefixIcon: const Icon(Icons.email_outlined, size: 20))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () async {
                final ok = await auth.updateProfile(name: nameCtrl.text, email: emailCtrl.text);
                if (ok && ctx.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr(context, 'profile_updated'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                        backgroundColor: AppColors.lowGreen, behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                } else if (auth.error != null && ctx.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(auth.error!, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                        backgroundColor: AppColors.urgentRed, behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text(tr(context, 'save'), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }

  void _pickLanguage(BuildContext context, SettingsProvider sp) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: context.adaptiveSurface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(tr(context, 'select_language'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          _langOption(ctx, sp, 'English', 'en', Icons.language),
          const SizedBox(height: 8),
          _langOption(ctx, sp, 'العربية (Arabic)', 'ar', Icons.translate),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _langOption(BuildContext ctx, SettingsProvider sp, String label, String code, IconData icon) {
    final isActive = sp.language == code;
    return GestureDetector(
      onTap: () { sp.setLanguage(code); Navigator.of(ctx).pop(); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? AppColors.primary.withValues(alpha: 0.3) : AppColors.outlineVariant.withValues(alpha: 0.3))),
        child: Row(children: [
          Icon(icon, size: 22, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: isActive ? AppColors.primary : null))),
          if (isActive) Icon(Icons.check_circle, size: 22, color: AppColors.primary),
        ]),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(title, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: context.textSecondary)),
      );

  Widget _toggleItem(IconData icon, String label, bool value, ValueChanged<bool> onChanged, Color cardColor, Color borderColor) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
          child: Row(children: [
            Icon(icon, size: 22, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500))),
            Switch.adaptive(value: value, onChanged: onChanged, activeTrackColor: AppColors.primary, activeThumbColor: Colors.white),
          ]),
        ),
      );

  Widget _menuItem(IconData icon, String label, String trailing, Color cardColor, Color borderColor) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
          child: Row(children: [
            Icon(icon, size: 22, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500))),
            if (trailing.isNotEmpty) Text(trailing, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
          ]),
        ),
      );

  Widget _menuItemTap(IconData icon, String label, String trailing, VoidCallback onTap, Color cardColor, Color borderColor) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: Row(children: [
              Icon(icon, size: 22, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500))),
              Text(trailing, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
            ]),
          ),
        ),
      );
}
