import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'tasks_screen.dart';
import 'events_screen.dart';
import 'settings_screen.dart';
import 'add_task_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(), TasksScreen(), EventsScreen(), SettingsScreen(),
  ];

  void _openAddTask() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AddTaskScreen(),
        transitionsBuilder: (_, a, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    return Scaffold(
      backgroundColor: context.adaptiveSurface,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          Positioned(
            right: 24, bottom: 96 + MediaQuery.of(context).padding.bottom,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 15))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _openAddTask, borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.add, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Text(tr(context, 'new_task'), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: BottomNavBar(currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
          ),
        ],
      ),
    );
  }
}
