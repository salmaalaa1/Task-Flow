import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    final items = [
      _NavItem(Icons.home_outlined, Icons.home, tr(context, 'nav_home')),
      _NavItem(Icons.check_circle_outline, Icons.check_circle, tr(context, 'nav_tasks')),
      _NavItem(Icons.calendar_today_outlined, Icons.calendar_today, tr(context, 'nav_events')),
      _NavItem(Icons.settings_outlined, Icons.settings, tr(context, 'nav_settings')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.navBarColor,
        border: Border(top: BorderSide(color: context.navBarBorder, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final isActive = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(isActive ? items[i].activeIcon : items[i].icon, size: 22,
                        color: isActive ? AppColors.primary : context.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 4),
                    Text(items[i].label, style: GoogleFonts.inter(fontSize: 10,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? AppColors.primary : context.textSecondary.withValues(alpha: 0.5))),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  _NavItem(this.icon, this.activeIcon, this.label);
}
