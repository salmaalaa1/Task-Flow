import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/team_task_provider.dart';
import '../models/team_task_model.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class MemberTasksScreen extends StatelessWidget {
  final String teamName;
  final String userId;
  const MemberTasksScreen({super.key, required this.teamName, required this.userId});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final labelColor = context.textHint;
    final cardColor = context.cardColor;

    final tp = context.watch<TeamTaskProvider>();
    final currentUserName = context.watch<AuthProvider>().currentUser?.name;
    // Filter tasks to show only those assigned to this authenticated member.
    final myTasks = tp.tasksForUser(userId, fallbackName: currentUserName);
    final pending = myTasks.where((t) => !t.isDone).toList();
    final completed = myTasks.where((t) => t.isDone).toList();
    final now = DateTime.now();
    final dayKeys = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final monthKeys = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.grid_view_rounded, size: 22, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  tr(context, 'my_tasks_team'),
                  style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.blue.shade700),
                ),
                const Spacer(),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.chipBg),
                  child: Icon(Icons.notifications_outlined, size: 20, color: textSecondary),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF6366F1)]),
                  ),
                  child: const Center(child: Icon(Icons.person, size: 18, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // My Day + Member badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(context, 'my_day'),
                        style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tr(context, dayKeys[now.weekday - 1])}, ${tr(context, monthKeys[now.month - 1])} ${now.day}',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF97316).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, size: 14, color: Color(0xFFF97316)),
                      const SizedBox(width: 5),
                      Text(
                        tr(context, 'member'),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFF97316)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Remaining & Completed cards — DYNAMIC (filtered for this member)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: context.subtleShadow, blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context, 'remaining').toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${pending.length}'.padLeft(2, '0'),
                          style: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: context.subtleShadow, blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context, 'completed_label'),
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${completed.length}'.padLeft(2, '0'),
                          style: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Priority Focus
            Text(
              tr(context, 'priority_focus'),
              style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
            ),
            const SizedBox(height: 16),

            if (myTasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Icon(Icons.assignment_outlined, size: 48, color: labelColor),
                    const SizedBox(height: 12),
                    Text(
                      tr(context, 'no_tasks_assigned'),
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(tr(context, 'owner_will_assign'), style: GoogleFonts.inter(fontSize: 13, color: labelColor)),
                  ],
                ),
              )
            else
              ...myTasks.map((task) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _taskCard(context, task, cardColor, isDark, textPrimary, textSecondary, tp, currentUserName))),
          ],
        ),
      ),
    );
  }

  Widget _taskCard(BuildContext context, TeamTask task, Color cardColor, bool isDark, Color textPrimary, Color textSecondary, TeamTaskProvider tp, String? currentUserName) {
    final statusColor = task.isDone
        ? const Color(0xFF22C55E)
        : task.isInProgress
        ? const Color(0xFF3B82F6)
        : const Color(0xFFF97316);
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

    final icon = task.isDone
        ? Icons.check_circle_rounded
        : task.isInProgress
        ? Icons.play_circle_rounded
        : Icons.warning_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: context.subtleShadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 22, color: statusColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary, height: 1.3, decoration: task.isDone ? TextDecoration.lineThrough : null),
                ),
                if (task.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.note,
                    style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        statusLabel,
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor, letterSpacing: 0.5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Toggle done
                    GestureDetector(
                      onTap: () => tp.toggleStatusForUser(task.id, userId, fallbackName: currentUserName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: context.chipBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(task.isDone ? Icons.undo : Icons.check, size: 13, color: const Color(0xFF22C55E)),
                            const SizedBox(width: 4),
                            Text(
                              task.isDone ? tr(context, 'undo') : tr(context, 'done'),
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF22C55E)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Add Note
                    GestureDetector(
                      onTap: () => _showNoteDialog(context, task, tp, currentUserName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: context.chipBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_note, size: 13, color: const Color(0xFF3B82F6)),
                            const SizedBox(width: 4),
                            Text(
                              tr(context, 'note'),
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
