import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
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

  void _openAddEvent() {
    final ep = context.read<EventProvider>();
    final titleCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: BoxDecoration(color: context.adaptiveSurface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(tr(context, 'new_event'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary)),
          const SizedBox(height: 20),
          TextField(controller: titleCtrl, style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
              decoration: InputDecoration(hintText: tr(context, 'event_title_hint'), filled: true, fillColor: context.inputFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
          const SizedBox(height: 12),
          TextField(controller: locationCtrl, style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
              decoration: InputDecoration(hintText: tr(context, 'location'), filled: true, fillColor: context.inputFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                ep.addEvent(Event(id: DateTime.now().millisecondsSinceEpoch.toString(), title: titleCtrl.text.trim(), location: locationCtrl.text.trim(), date: ep.selectedDate));
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text(tr(context, 'add_event'), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }

  void _onFabTap() {
    if (_currentIndex == 2) {
      _openAddEvent();
    } else {
      _openAddTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    final isEventsTab = _currentIndex == 2;
    final fabLabel = isEventsTab ? tr(context, 'new_event') : tr(context, 'new_task');
    final fabIcon = isEventsTab ? Icons.event : Icons.add;

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
                  onTap: _onFabTap, borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(fabIcon, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Text(fabLabel, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
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
