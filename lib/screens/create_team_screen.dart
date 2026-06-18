import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/team_provider.dart';
import '../l10n/translations.dart';
import '../theme/theme_utils.dart';
import 'owner_dashboard_screen.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _teamNameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _teamNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = context.adaptiveSurface;
    final cardColor = context.cardColor;
    final fieldColor = context.inputFill;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final labelColor = context.textHint;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner Panel badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: isDark ? Colors.blue.withValues(alpha: 0.15) : const Color(0xFFE0EDFF), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings_outlined, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 6),
                  Text(
                    tr(context, 'owner_panel'),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.blue.shade700, letterSpacing: 1.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              tr(context, 'create_team'),
              style: GoogleFonts.manrope(fontSize: 30, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              tr(context, 'create_team_subtitle'),
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5),
            ),
            const SizedBox(height: 28),

            // Team Name & Description card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Name
                  Text(
                    tr(context, 'team_name_label'),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(color: fieldColor, borderRadius: BorderRadius.circular(14)),
                    child: TextField(
                      controller: _teamNameCtrl,
                      style: GoogleFonts.inter(fontSize: 15, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: tr(context, 'team_name_example'),
                        hintStyle: GoogleFonts.inter(fontSize: 15, color: labelColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Description
                  Text(
                    tr(context, 'team_description_label'),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(color: fieldColor, borderRadius: BorderRadius.circular(14)),
                    child: TextField(
                      controller: _descriptionCtrl,
                      maxLines: 4,
                      style: GoogleFonts.inter(fontSize: 15, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: tr(context, 'enter_team_desc'),
                        hintStyle: GoogleFonts.inter(fontSize: 15, color: labelColor, height: 1.4),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Access Security card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: isDark ? Colors.blue.withValues(alpha: 0.15) : const Color(0xFFE0EDFF), borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.lock_outline, size: 20, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(context, 'access_security'),
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tr(context, 'access_control'),
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: labelColor, letterSpacing: 1.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Password label
                  Text(
                    tr(context, 'unified_team_password'),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(color: fieldColor, borderRadius: BorderRadius.circular(14)),
                    child: TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(fontSize: 15, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: GoogleFonts.inter(fontSize: 15, color: labelColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: labelColor),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: Colors.blue.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          tr(context, 'password_required_to_join'),
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue.shade600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Create a Team button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final teamName = _teamNameCtrl.text.trim();
                    final description = _descriptionCtrl.text.trim();
                    final password = _passwordCtrl.text.trim();

                    if (teamName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr(context, 'please_enter_team_name'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }
                    if (description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr(context, 'please_enter_description'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr(context, 'please_enter_password'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }

                    // Save team data persistently
                    final auth = context.read<AuthProvider>();
                    final teamProvider = context.read<TeamProvider>();
                    await teamProvider.createTeam(teamName: teamName, description: description, password: password, ownerUserId: auth.currentUser?.id, ownerName: auth.currentUser?.name, ownerEmail: auth.currentUser?.email);
                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => OwnerDashboardScreen(teamName: teamName)), (_) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text(
                    tr(context, 'create_team'),
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cancel button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: labelColor.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  backgroundColor: cardColor,
                ),
                child: Text(
                  tr(context, 'cancel'),
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
