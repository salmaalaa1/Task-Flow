import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/team_provider.dart';
import '../providers/team_task_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import 'sign_in_screen.dart';
import 'main_shell.dart';

class MemberSettingsScreen extends StatelessWidget {
  const MemberSettingsScreen({super.key});

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
                  // Person avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.chipBg,
                    ),
                    child: Center(
                      child: Icon(Icons.person, size: 20, color: textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.notifications_outlined, size: 22, color: textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Divider
          Divider(color: labelColor.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 28),

          // Profile card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                      BoxShadow(
                        color: context.subtleShadow,
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              children: [
                // Avatar with edit icon
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFCD34D), Color(0xFFF59E0B)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 46, color: Colors.white70),
                      ),
                    ),
                    // Edit badge
                    Positioned(
                      right: -6,
                      top: -4,
                      child: GestureDetector(
                        onTap: () => _editProfile(context, auth),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.edit, size: 14, color: Color(0xFF3B82F6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // MEMBER badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'MEMBER',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  user?.name ?? 'Alex Rivera',
                  style: GoogleFonts.manrope(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),

                // Email
                Text(
                  user?.email ?? 'alex.rivera@fluidworkspace.com',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // DESIGNER badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'DESIGNER',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainShell()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.grid_view_rounded, size: 20, color: Colors.white),
              label: Text(
                'Go to TaskFlow',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // DANGER ZONE divider
          Row(
            children: [
              Expanded(child: Divider(color: labelColor.withValues(alpha: 0.2))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'DANGER ZONE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEF4444),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(child: Divider(color: labelColor.withValues(alpha: 0.2))),
            ],
          ),
          const SizedBox(height: 20),

          // Leave Team card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF3A1A1A)
                  : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Leave Team',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You will lose access to all shared tasks and workspace assets.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 180,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmLeaveTeam(context),
                    icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
                    label: Text(
                      'Leave Team',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Dots indicator
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(labelColor.withValues(alpha: 0.3)),
                const SizedBox(width: 6),
                _dot(labelColor.withValues(alpha: 0.3)),
                const SizedBox(width: 6),
                _dot(labelColor.withValues(alpha: 0.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  void _editProfile(BuildContext context, AuthProvider auth) {
    final user = auth.currentUser;
    if (user == null) return;
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    final isDark = context.isDark;
    final surfaceColor = context.cardColor;

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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Edit Profile', style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: GoogleFonts.inter(fontSize: 13),
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.inter(fontSize: 13),
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
              ),
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
                        content: Text('Profile updated', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
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
                child: Text('Save', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLeaveTeam(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Leave Team?', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text(
          'You will lose access to all shared tasks and workspace assets. This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Clear persisted team data
              context.read<TeamProvider>().clearTeam();
              context.read<TeamTaskProvider>().clearAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainShell()),
                (_) => false,
              );
            },
            child: Text(
              'Leave',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
