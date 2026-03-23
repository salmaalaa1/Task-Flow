import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TaskProvider>();
    context.watch<SettingsProvider>();
    final liveTask = tp.allTasks.where((t) => t.id == task.id).firstOrNull;
    if (liveTask == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) Navigator.of(context).pop(); });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: context.adaptiveSurface,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 24, 0),
              child: Row(children: [
                IconButton(onPressed: () => Navigator.of(context).pop(),
                  icon: Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: context.cardColorStrong, borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: context.textPrimary))),
                const SizedBox(width: 12),
                Expanded(child: Text(tr(context, 'task_details'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary))),
                GestureDetector(
                  onTap: () => _confirmDelete(context, tp),
                  child: Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.urgentRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.delete_outline, size: 22, color: AppColors.urgentRed))),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: liveTask.priorityColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: liveTask.priorityColor)),
                  const SizedBox(width: 6),
                  Text('${liveTask.priorityLabel} ${tr(context, 'priority')}',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: liveTask.priorityColor)),
                ]),
              ),
              const SizedBox(height: 12),
              Text(liveTask.title, style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.2, color: context.textPrimary)),
            ]),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () => tp.toggleComplete(liveTask.id),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: (liveTask.isCompleted ? AppColors.lowGreen : AppColors.primary).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (liveTask.isCompleted ? AppColors.lowGreen : AppColors.primary).withValues(alpha: 0.3))),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(liveTask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 20, color: liveTask.isCompleted ? AppColors.lowGreen : AppColors.primary),
                  const SizedBox(width: 8),
                  Text(liveTask.isCompleted ? tr(context, 'completed') : tr(context, 'mark_complete'),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600,
                          color: liveTask.isCompleted ? AppColors.lowGreen : AppColors.primary)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (liveTask.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _card(context, [
                Text(tr(context, 'description'), style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimary)),
                const SizedBox(height: 12),
                Text(liveTask.description, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.6, color: context.textSecondary)),
              ]),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              _infoChip(context, Icons.calendar_today, '${liveTask.dueDate.day}/${liveTask.dueDate.month}/${liveTask.dueDate.year}'),
              const SizedBox(width: 12),
              _infoChip(context, Icons.schedule, liveTask.formattedTime),
            ]),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              _infoChip(context, liveTask.categoryIcon, liveTask.categoryLabel),
              const SizedBox(width: 12),
              _infoChip(context, Icons.flag, '${liveTask.priorityLabel} ${tr(context, 'priority')}'),
            ]),
          ),
          const SizedBox(height: 28),
          if (liveTask.checklist.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _card(context, [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(tr(context, 'checklist'), style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimary)),
                  Text('${liveTask.completedChecklistCount}/${liveTask.checklist.length}',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ]),
                const SizedBox(height: 4),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: liveTask.checklist.isEmpty ? 0 : liveTask.completedChecklistCount / liveTask.checklist.length,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 4)),
                const SizedBox(height: 16),
                ...liveTask.checklist.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => tp.toggleChecklistItem(liveTask.id, item.id),
                    child: Row(children: [
                      Container(width: 22, height: 22,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                          border: Border.all(color: item.isCompleted ? AppColors.primary : AppColors.outlineVariant, width: 2),
                          color: item.isCompleted ? AppColors.primary : Colors.transparent),
                        child: item.isCompleted ? const Icon(Icons.check, size: 13, color: Colors.white) : null),
                      const SizedBox(width: 12),
                      Expanded(child: Text(item.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500,
                          color: item.isCompleted ? context.textSecondary : context.textPrimary,
                          decoration: item.isCompleted ? TextDecoration.lineThrough : null))),
                    ]),
                  ),
                )),
              ]),
            ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskProvider tp) {
    showDialog(context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(tr(context, 'delete_task_title'), style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text('${tr(context, 'delete_task_msg_prefix')}${task.title}${tr(context, 'delete_task_msg_suffix')}', style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(tr(context, 'cancel'), style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
          TextButton(
            onPressed: () { tp.deleteTask(task.id); Navigator.of(ctx).pop(); Navigator.of(context).pop(); },
            child: Text(tr(context, 'delete'), style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.urgentRed))),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, List<Widget> children) => Container(
        width: double.infinity, padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: context.cardBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));

  Widget _infoChip(BuildContext context, IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: context.chipBg.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: context.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: context.textSecondary)),
        ]));
}
