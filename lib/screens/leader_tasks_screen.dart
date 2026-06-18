import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/team_task_provider.dart';
import '../models/team_task_model.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class LeaderTasksScreen extends StatelessWidget {
  final String teamName;
  final String userId;
  const LeaderTasksScreen({super.key, required this.teamName, required this.userId});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final labelColor = context.textHint;
    final cardColor = context.cardColor;

    final tp = context.watch<TeamTaskProvider>();
    final currentUserName = context.watch<AuthProvider>().currentUser?.name;
    // Filter tasks to show only those assigned to this authenticated leader.
    final myTasks = tp.tasksForUser(userId, fallbackName: currentUserName);
    final pending = myTasks.where((t) => !t.isDone).toList();
    final completed = myTasks.where((t) => t.isDone).toList();
    final now = DateTime.now();
    final dayKeys = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final monthKeys = ['jan_short', 'feb_short', 'mar_short', 'apr_short', 'may_short', 'jun_short', 'jul_short', 'aug_short', 'sep_short', 'oct_short', 'nov_short', 'dec_short'];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF2C3E50), Color(0xFF1A252F)]),
                    border: Border.all(color: isDark ? Colors.white24 : const Color(0xFFE0E0E0), width: 2),
                  ),
                  child: const Center(child: Icon(Icons.person, size: 22, color: Color(0xFF7FB3D0))),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 13, color: Color(0xFF1A1A2E)),
                        const SizedBox(width: 4),
                        Text(
                          tr(context, 'leader').toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF1A1A2E), letterSpacing: 1.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Title & Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(context, 'my_tasks_team'),
                        style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${pending.length} ${tr(context, 'pending_label').toLowerCase()} · ${completed.length} ${tr(context, 'done').toLowerCase()}',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      Text(
                        '${tr(context, dayKeys[now.weekday - 1])}, ${tr(context, monthKeys[now.month - 1])}',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 0.8),
                      ),
                      Text(
                        '${now.day}',
                        style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Empty state
            if (myTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(22)),
                child: Column(
                  children: [
                    Icon(Icons.assignment_outlined, size: 56, color: labelColor),
                    const SizedBox(height: 16),
                    Text(
                      tr(context, 'no_tasks_assigned'),
                      style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(tr(context, 'owner_will_assign'), style: GoogleFonts.inter(fontSize: 13, color: labelColor)),
                  ],
                ),
              )
            else ...[
              // Pending tasks
              if (pending.isNotEmpty) ...[
                Text(
                  tr(context, 'pending_label'),
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: labelColor, letterSpacing: 1.0),
                ),
                const SizedBox(height: 10),
                ...pending.map((task) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _taskCard(context, task, cardColor, isDark, textPrimary, textSecondary, labelColor, tp, currentUserName))),
                const SizedBox(height: 20),
              ],

              // Completed tasks
              if (completed.isNotEmpty) ...[
                Text(
                  tr(context, 'completed_label'),
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF22C55E), letterSpacing: 1.0),
                ),
                const SizedBox(height: 10),
                ...completed.map((task) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _taskCard(context, task, cardColor, isDark, textPrimary, textSecondary, labelColor, tp, currentUserName))),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _taskCard(BuildContext context, TeamTask task, Color cardColor, bool isDark, Color textPrimary, Color textSecondary, Color labelColor, TeamTaskProvider tp, String? currentUserName) {
    final statusColor = task.isDone
        ? const Color(0xFF22C55E)
        : task.isInProgress
        ? const Color(0xFF3B82F6)
        : const Color(0xFFF59E0B);
    final statusLabel = task.isDone
        ? tr(context, 'done_label')
        : task.isInProgress
        ? tr(context, 'in_progress')
        : tr(context, 'pending_label');
    final statusBg = task.isDone
        ? const Color(0xFFF0FDF4)
        : task.isInProgress
        ? const Color(0xFFEBF0FF)
        : const Color(0xFFFFF7ED);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: isDark ? statusColor.withValues(alpha: 0.15) : statusBg, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: statusColor, letterSpacing: 0.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary, decoration: task.isDone ? TextDecoration.lineThrough : null),
          ),
          if (task.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.note,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              // Toggle done button
              ElevatedButton(
                onPressed: () => tp.toggleStatusForUser(task.id, userId, fallbackName: currentUserName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isDone ? const Color(0xFF22C55E) : const Color(0xFF1A1A2E),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(task.isDone ? Icons.undo : Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      task.isDone ? tr(context, 'undo') : tr(context, 'mark_done'),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Add note button
              GestureDetector(
                onTap: () => _showNoteDialog(context, task, tp, currentUserName),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_note, size: 16, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 4),
                      Text(
                        tr(context, 'note'),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNoteDialog(BuildContext context, TeamTask task, TeamTaskProvider tp, String? currentUserName) {
    final noteCtrl = TextEditingController(text: task.note);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(tr(ctx, 'add_note'), style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(hintText: tr(ctx, 'write_note'), hintStyle: GoogleFonts.inter(fontSize: 14)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr(ctx, 'cancel'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              tp.updateNoteForUser(task.id, userId, noteCtrl.text.trim(), fallbackName: currentUserName);
            },
            child: Text(
              tr(ctx, 'save'),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6)),
            ),
          ),
        ],
      ),
    );
  }
}
