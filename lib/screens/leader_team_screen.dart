import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/team_task_provider.dart';
import '../models/team_task_model.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class LeaderTeamScreen extends StatelessWidget {
  final String teamName;
  final String department;
  const LeaderTeamScreen({super.key, required this.teamName, required this.department});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final labelColor = context.textHint;
    final cardColor = context.cardColor;
    final fieldColor = context.inputFill;

    final tp = context.watch<TeamTaskProvider>();
    final tasks = tp.allTasks;
    final completionPct = tp.totalCount == 0 ? 0.0 : tp.completionRate;

    // Group tasks by assignee
    final assignees = tp.assigneeNames;

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
                  tr(context, 'team'),
                  style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.blue.shade700),
                ),
                const Spacer(),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: fieldColor),
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
            const SizedBox(height: 24),

            // Department title
            Text(
              '$department ${tr(context, 'dept_suffix')}',
              style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(8)),
              child: Text(
                tr(context, 'leader').toUpperCase(),
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.8),
              ),
            ),
            const SizedBox(height: 28),

            // DEPARTMENT PULSE
            Text(
              tr(context, 'dept_pulse'),
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: labelColor, letterSpacing: 1.2),
            ),
            const SizedBox(height: 14),

            // Overall Completion card — DYNAMIC
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr(context, 'overall_completion'),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                      ),
                      Icon(Icons.auto_graph_rounded, size: 24, color: Colors.blue.shade400),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(completionPct * 100).toInt()}%',
                    style: GoogleFonts.manrope(fontSize: 42, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(value: completionPct, minHeight: 8, backgroundColor: const Color(0xFFE8EAF0), valueColor: const AlwaysStoppedAnimation(Color(0xFF3B82F6))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Active Tasks & Completed
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context, 'active_tasks'),
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${tp.pendingCount}',
                          style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context, 'completed_label'),
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${tp.completedCount}',
                          style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // TEAM WORKLOAD — shows tasks per member
            if (assignees.isNotEmpty) ...[
              Text(
                tr(context, 'team_workload'),
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: labelColor, letterSpacing: 1.2),
              ),
              const SizedBox(height: 16),
              ...assignees.map((name) {
                final memberTasks = tp.tasksFor(name);
                final done = memberTasks.where((t) => t.isDone).length;
                final total = memberTasks.length;
                final progress = total == 0 ? 0.0 : done / total;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                          ),
                          Text(
                            '$done / $total ${tr(context, 'tasks_suffix')}',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: isDark ? Colors.white10 : const Color(0xFFE8EAF0),
                          valueColor: AlwaysStoppedAnimation(progress >= 1.0 ? const Color(0xFF22C55E) : const Color(0xFF3B82F6)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],

            // TASK BACKLOG
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr(context, 'all_tasks'),
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: labelColor, letterSpacing: 1.2),
                ),
                Text(
                  '${tp.totalCount} ${tr(context, 'total')}',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (tasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  children: [
                    Icon(Icons.assignment_outlined, size: 48, color: labelColor),
                    const SizedBox(height: 12),
                    Text(
                      tr(context, 'no_tasks_yet'),
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr(context, 'tasks_appear_hint'),
                      style: GoogleFonts.inter(fontSize: 13, color: labelColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...tasks.map((task) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _taskItem(context, task, cardColor, isDark, textPrimary, textSecondary, labelColor))),
          ],
        ),
      ),
    );
  }

  Widget _taskItem(BuildContext context, TeamTask task, Color cardColor, bool isDark, Color textPrimary, Color textSecondary, Color labelColor) {
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
    final icon = task.isDone
        ? Icons.check_circle_rounded
        : task.isInProgress
        ? Icons.play_circle_rounded
        : Icons.radio_button_unchecked;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: statusColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary, decoration: task.isDone ? TextDecoration.lineThrough : null),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: labelColor),
                    const SizedBox(width: 4),
                    Text(
                      task.assignedTo.isNotEmpty ? task.assignedTo : tr(context, 'unassigned'),
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF3B82F6)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        statusLabel,
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: statusColor),
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
}
