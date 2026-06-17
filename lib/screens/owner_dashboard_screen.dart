import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/translations.dart';
import '../theme/theme_utils.dart';
import 'owner_team_screen.dart';
import 'owner_settings_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  final String teamName;

  const OwnerDashboardScreen({
    super.key,
    required this.teamName,
  });

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.adaptiveSurface,
      body: _currentTab == 0
          ? OwnerTeamScreen(teamName: widget.teamName)
          : const OwnerSettingsScreen(),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    final bgColor = context.navBarColor;
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: context.subtleShadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.people_alt_rounded, tr(context, 'nav_team'), 0, isDark),
          _navItem(Icons.settings_rounded, tr(context, 'nav_team_settings'), 1, isDark),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, bool isDark) {
    final isActive = _currentTab == index;
    final activeColor = Colors.blue;
    final inactiveColor = isDark ? Colors.white38 : const Color(0xFF9CA3AF);
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: isActive ? activeColor : inactiveColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isActive ? activeColor : inactiveColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
