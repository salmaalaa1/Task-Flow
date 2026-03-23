import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';
import '../widgets/performance_chart.dart';
import '../widgets/category_chip.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return tr(context, 'good_morning');
    if (hour < 17) return tr(context, 'good_afternoon');
    return tr(context, 'good_evening');
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final auth = context.watch<AuthProvider>();
    // Watch settings so we rebuild on language change
    context.watch<SettingsProvider>();
    final userName = auth.currentUser?.name ?? 'User';
    final firstName = userName.split(' ').first;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                    child: Center(
                      child: Text(firstName[0].toUpperCase(),
                          style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.cardColorStrong, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: context.subtleShadow, blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(children: [
                        Icon(Icons.search, size: 20, color: context.textHint),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (q) => taskProvider.setSearch(q),
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary),
                            decoration: InputDecoration(
                              hintText: tr(context, 'search_tasks'),
                              hintStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: context.textHint),
                              border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () { _searchController.clear(); taskProvider.setSearch(''); },
                            child: Icon(Icons.close, size: 18, color: context.textSecondary),
                          ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: context.cardColorStrong, borderRadius: BorderRadius.circular(12)),
                    child: Stack(children: [
                      Center(child: Icon(Icons.notifications_outlined, size: 22, color: context.textSecondary)),
                      if (taskProvider.urgentTasks.isNotEmpty)
                        Positioned(top: 8, right: 8,
                          child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.urgentRed, shape: BoxShape.circle))),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${_greeting(context)}, $firstName',
                  style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: context.textPrimary)),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: context.textSecondary),
                  children: [
                    TextSpan(text: tr(context, 'pending_prefix')),
                    TextSpan(
                      text: '${taskProvider.pendingCount}${taskProvider.pendingCount != 1 ? tr(context, 'pending_suffix_many') : tr(context, 'pending_suffix_one')}',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    TextSpan(text: tr(context, 'pending_end')),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 28),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: PerformanceChart(weeklyData: taskProvider.weeklyCompletion)),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(tr(context, 'categories'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 24), children: [
              CategoryChip(icon: Icons.work, label: tr(context, 'work'), iconColor: AppColors.categoryWork, backgroundColor: AppColors.categoryWorkBg, count: taskProvider.taskCountForCategory(TaskCategory.work)),
              const SizedBox(width: 16),
              CategoryChip(icon: Icons.favorite, label: tr(context, 'personal'), iconColor: AppColors.categoryPersonal, backgroundColor: AppColors.categoryPersonalBg, count: taskProvider.taskCountForCategory(TaskCategory.personal)),
              const SizedBox(width: 16),
              CategoryChip(icon: Icons.fitness_center, label: tr(context, 'health'), iconColor: AppColors.categoryHealth, backgroundColor: AppColors.categoryHealthBg, count: taskProvider.taskCountForCategory(TaskCategory.health)),
              const SizedBox(width: 16),
              CategoryChip(icon: Icons.school, label: tr(context, 'study'), iconColor: AppColors.categoryStudy, backgroundColor: AppColors.categoryStudyBg, count: taskProvider.taskCountForCategory(TaskCategory.study)),
              const SizedBox(width: 16),
              CategoryChip(icon: Icons.payments, label: tr(context, 'finance'), iconColor: AppColors.categoryFinance, backgroundColor: AppColors.categoryFinanceBg, count: taskProvider.taskCountForCategory(TaskCategory.finance)),
            ]),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(tr(context, 'priority_tasks'), style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimary)),
              Text('${taskProvider.priorityTasks.take(5).length} ${tr(context, 'tasks_label')}',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: taskProvider.priorityTasks.take(5).map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TaskCard(title: task.title, priority: task.priority, time: task.formattedTime,
                    metadata: task.categoryLabel, isCompleted: task.isCompleted,
                    onToggle: () => taskProvider.toggleComplete(task.id)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
