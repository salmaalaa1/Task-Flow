import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';
import '../services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.work;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(hour: (TimeOfDay.now().hour + 1) % 24, minute: TimeOfDay.now().minute);

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'enter_title_error'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            backgroundColor: AppColors.urgentRed, behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      );
      return;
    }
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority, category: _category,
      startTime: _startTime, endTime: _endTime,
    );
    final sp = context.read<SettingsProvider>();
    context.read<TaskProvider>().addTask(task);
    if (sp.soundEffects) {
      NotificationService.instance.playSound();
      NotificationService.instance.haptic();
    }
    if (sp.notifications && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ ${tr(context, 'task_created_msg')}', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            backgroundColor: AppColors.lowGreen, behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2)),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    final priorityLabels = {TaskPriority.urgent: tr(context, 'urgent'), TaskPriority.medium: tr(context, 'medium'), TaskPriority.low: tr(context, 'low')};
    final categoryKeys = {TaskCategory.work: 'work', TaskCategory.personal: 'personal', TaskCategory.health: 'health', TaskCategory.study: 'study', TaskCategory.finance: 'finance'};

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
                      child: Icon(Icons.close, size: 20, color: context.textPrimary))),
                const SizedBox(width: 12),
                Expanded(child: Text(tr(context, 'new_task'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary))),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          _sectionLabel(tr(context, 'task_title')),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _inputField(_titleController, tr(context, 'enter_task_title'))),
          const SizedBox(height: 20),
          _sectionLabel(tr(context, 'description')),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _inputField(_descController, tr(context, 'add_description'), maxLines: 3)),
          const SizedBox(height: 24),
          _sectionLabel(tr(context, 'priority')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: TaskPriority.values.map((p) {
                final isActive = _priority == p;
                final color = p == TaskPriority.urgent ? AppColors.urgentRed : p == TaskPriority.medium ? AppColors.mediumAmber : AppColors.lowGreen;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: Container(
                      margin: EdgeInsets.only(right: p != TaskPriority.low ? 10 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isActive ? color.withValues(alpha: 0.15) : context.inputFill,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isActive ? color : context.cardBorder, width: isActive ? 2 : 1)),
                      child: Center(child: Text(priorityLabels[p]!,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isActive ? color : context.textSecondary))),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _sectionLabel(tr(context, 'category')),
          SizedBox(
            height: 44,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 24),
              children: TaskCategory.values.map((c) {
                final isActive = _category == c;
                return GestureDetector(
                  onTap: () => setState(() => _category = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : context.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isActive ? AppColors.primary : context.cardBorder)),
                    child: Center(child: Text(tr(context, categoryKeys[c]!),
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : context.textSecondary))),
                  ),
                );
              }).toList()),
          ),
          const SizedBox(height: 24),
          _sectionLabel(tr(context, 'time_range')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              Expanded(child: GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: _startTime);
                  if (time != null) setState(() => _startTime = time);
                },
                child: _infoBox(Icons.play_arrow_rounded, '${tr(context, 'from')}: ${_formatTime(_startTime)}'))),
              const SizedBox(width: 12),
              Expanded(child: GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: _endTime);
                  if (time != null) setState(() => _endTime = time);
                },
                child: _infoBox(Icons.stop_rounded, '${tr(context, 'to')}: ${_formatTime(_endTime)}'))),
            ]),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(width: double.infinity, height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(9999),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 15))]),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                  child: Text(tr(context, 'create_task'), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
        child: Text(text, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: context.textPrimary)));

  Widget _inputField(TextEditingController ctrl, String hint, {int maxLines = 1}) => TextField(
        controller: ctrl, maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
        decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.inter(fontSize: 15, color: context.textHint),
            filled: true, fillColor: context.inputFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)));

  Widget _infoBox(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: context.inputFill, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.cardBorder)),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary)),
        ]));

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }
}
