import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TaskProvider>();
    context.watch<SettingsProvider>();
    final tasks = tp.filteredTasks;
    final filterKeys = {'All': 'all', 'Today': 'today', 'Upcoming': 'upcoming', 'Done': 'done'};

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(tr(context, 'my_tasks'),
                  style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: context.textPrimary)),
              Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: context.cardColorStrong, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.filter_list, size: 22, color: context.textSecondary)),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        // Progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer]),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 15))],
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr(context, 'daily_progress'), style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  '${tr(context, 'tasks_remaining_prefix')}${tp.pendingCount}${tp.pendingCount != 1 ? tr(context, 'tasks_remaining_suffix_many') : tr(context, 'tasks_remaining_suffix_one')}',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ])),
              SizedBox(
                width: 64, height: 64,
                child: Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 64, height: 64,
                    child: CircularProgressIndicator(value: tp.completionRate, strokeWidth: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), strokeCap: StrokeCap.round)),
                  Text('${(tp.completionRate * 100).toInt()}%',
                      style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 28),
        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: ['All', 'Today', 'Upcoming', 'Done'].map((label) {
              final isActive = tp.activeFilter == label;
              return GestureDetector(
                onTap: () => tp.setFilter(label),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: isActive ? AppColors.primary : context.chipBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(tr(context, filterKeys[label]!),
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : context.textSecondary)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Center(child: Column(children: [
              Icon(Icons.check_circle_outline, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(tr(context, 'no_tasks_found'), style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: context.textSecondary)),
              const SizedBox(height: 4),
              Text(tr(context, 'tap_new_task'), style: GoogleFonts.inter(fontSize: 14, color: context.textHint)),
            ])),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: tasks.map((task) => _taskListItem(context, task, tp)).toList()),
          ),
      ]),
    );
  }

  Widget _taskListItem(BuildContext context, Task task, TaskProvider tp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(task.id), direction: DismissDirection.endToStart,
        onDismissed: (_) => tp.deleteTask(task.id),
        background: Container(
          alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(color: AppColors.urgentRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
          child: Icon(Icons.delete_outline, color: AppColors.urgentRed, size: 28)),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => TaskDetailScreen(task: task),
            transitionsBuilder: (_, a, __, child) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)), child: child),
            transitionDuration: const Duration(milliseconds: 350))),
          child: AnimatedOpacity(
            opacity: task.isCompleted ? 0.5 : 1.0, duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.cardBorder),
                  boxShadow: [BoxShadow(color: context.cardShadow, blurRadius: 12, offset: const Offset(0, 4))]),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () => tp.toggleComplete(task.id),
                  child: Container(width: 24, height: 24, margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      border: Border.all(color: task.isCompleted ? AppColors.primary : AppColors.outlineVariant, width: 2),
                      color: task.isCompleted ? AppColors.primary : Colors.transparent),
                    child: task.isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(task.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimary,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: task.priorityColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(task.priorityLabel, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: task.priorityColor))),
                  ]),
                  const SizedBox(height: 6),
                  Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, height: 1.4, color: context.textSecondary)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.schedule, size: 14, color: context.textSecondary.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Text(task.formattedTime, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondary.withValues(alpha: 0.6))),
                    const SizedBox(width: 12),
                    Icon(task.categoryIcon, size: 14, color: context.textSecondary.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Text(task.categoryLabel, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondary.withValues(alpha: 0.6))),
                  ]),
                ])),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
