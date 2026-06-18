import 'package:flutter/material.dart';
import '../l10n/translations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/team_provider.dart';
import '../providers/team_task_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import 'main_shell.dart';

class OwnerSettingsScreen extends StatelessWidget {
  const OwnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final cardColor = context.cardColor;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final labelColor = context.textHint;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(Icons.grid_view_rounded, size: 22, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Text(
                    tr(context, 'my_team'),
                    style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF6366F1)]),
                    ),
                    child: const Center(child: Icon(Icons.person, size: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          Divider(color: labelColor.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 28),

          // Title
          Text(
            tr(context, 'team_settings'),
            style: GoogleFonts.manrope(fontSize: 34, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Text(
            tr(context, 'manage_workspace'),
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5),
          ),
          const SizedBox(height: 32),

          // PROFILE & ACCOUNT
          Text(
            tr(context, 'profile'),
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: labelColor, letterSpacing: 1.2),
          ),
          const SizedBox(height: 14),

          // Profile card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF4A6B7C), const Color(0xFF2C4A5A)]),
                      ),
                      child: const Center(child: Icon(Icons.person, size: 40, color: Color(0xFF8FBCCC))),
                    ),
                    const Spacer(),
                    // Edit button
                    GestureDetector(
                      onTap: () => _editProfile(context, auth),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  user?.name ?? tr(context, 'user_fallback'),
                  style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary),
                ),
                const SizedBox(height: 12),
                // Owner badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    tr(context, 'owner').toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Go to TaskFlow button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
              },
              icon: const Icon(Icons.grid_view_rounded, size: 20, color: Colors.white),
              label: Text(
                tr(context, 'go_to_taskflow'),
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // DANGER ZONE
          Text(
            tr(context, 'danger_zone'),
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444), letterSpacing: 1.2),
          ),
          const SizedBox(height: 14),

          // Delete Team card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A1A1A) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(context, 'delete_team'),
                  style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444)),
                ),
                const SizedBox(height: 6),
                Text(
                  tr(context, 'delete_team_msg'),
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary, height: 1.4),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _confirmDeleteTeam(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      tr(context, 'delete_team'),
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context, AuthProvider auth) {
    final user = auth.currentUser;
    if (user == null) return;
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF232340) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text(tr(context, 'edit_profile'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(labelText: tr(context, 'full_name'), labelStyle: GoogleFonts.inter(fontSize: 13), prefixIcon: const Icon(Icons.person_outline, size: 20)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(labelText: tr(context, 'email'), labelStyle: GoogleFonts.inter(fontSize: 13), prefixIcon: const Icon(Icons.email_outlined, size: 20)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final ok = await auth.updateProfile(name: nameCtrl.text, email: emailCtrl.text);
                  if (ok && ctx.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr(context, 'profile_updated'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                        backgroundColor: AppColors.lowGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  tr(context, 'save'),
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTeam(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(tr(ctx, 'delete_team_q'), style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text(tr(ctx, 'delete_team_msg'), style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr(ctx, 'cancel'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Clear persisted team data
              context.read<TeamProvider>().clearTeam(deleteTeamRecord: true);
              context.read<TeamTaskProvider>().clearAll();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
            },
            child: Text(
              tr(ctx, 'delete'),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
