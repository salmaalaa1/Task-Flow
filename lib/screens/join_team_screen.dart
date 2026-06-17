import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/team_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import 'member_dashboard_screen.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  final _teamNameCtrl = TextEditingController();
  final _teamPasswordCtrl = TextEditingController();
  final _userIdCtrl = TextEditingController(text: 'TF-992-UX');
  bool _obscurePassword = true;

  int _selectedDept = 0; // 0 = Programming, 1 = Media, 2 = Operation

  final List<String> _departments = ['Programming', 'Media', 'Operation'];

  @override
  void dispose() {
    _teamNameCtrl.dispose();
    _teamPasswordCtrl.dispose();
    _userIdCtrl.dispose();
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
            // Title
            Text(
              'Join a Team',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your credentials to synchronize with your team atelier.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Divider
            Divider(color: labelColor.withValues(alpha: 0.3), height: 1),
            const SizedBox(height: 24),

            // Team Name
            Text(
              'TEAM NAME',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: labelColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _teamNameCtrl,
                style: GoogleFonts.inter(fontSize: 15, color: textSecondary),
                decoration: InputDecoration(
                  hintText: 'Creative Studio X',
                  hintStyle: GoogleFonts.inter(fontSize: 15, color: labelColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Team Password
            Text(
              'TEAM PASSWORD',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: labelColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _teamPasswordCtrl,
                obscureText: _obscurePassword,
                style: GoogleFonts.inter(fontSize: 15, color: textPrimary),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: GoogleFonts.inter(fontSize: 15, color: labelColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined,
                      size: 20,
                      color: labelColor,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.red.shade400),
                const SizedBox(width: 6),
                Text(
                  'Required to verify association',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // User ID Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'USER ID',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.fingerprint, size: 24, color: Colors.teal.shade400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _userIdCtrl.text,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Icon(Icons.edit_outlined, size: 18, color: labelColor),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 28),

            // Department Selection
            Text(
              'DEPARTMENT SELECTION',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: labelColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_departments.length, (i) {
                final isSelected = _selectedDept == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDept = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : fieldColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? Colors.blue : labelColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _departments[i],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : textSecondary,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 36),

            // Establish Connection Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final teamName = _teamNameCtrl.text.trim();
                    final teamPassword = _teamPasswordCtrl.text.trim();
                    final userId = _userIdCtrl.text.trim();
                    final deptNames = ['Programming', 'Media', 'Operation'];

                    // Validate all fields
                    if (teamName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter team name', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }
                    if (teamPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter team password', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }
                    if (userId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter your user ID', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }
                    final department = deptNames[_selectedDept];

                    // Save team data persistently
                    final teamProvider = context.read<TeamProvider>();
                    teamProvider.joinTeamAsMember(
                      teamName: teamName,
                      password: teamPassword,
                      userId: userId,
                      department: department,
                    );

                    // Navigate to member dashboard
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => MemberDashboardScreen(
                        teamName: teamName,
                        department: department,
                        userId: userId,
                      )),
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Join a Team',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
