import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/team_task_provider.dart';
import '../providers/team_provider.dart';
import '../models/team_task_model.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class OwnerTeamScreen extends StatelessWidget {
  final String teamName;
  const OwnerTeamScreen({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final labelColor = context.textHint;
    final cardColor = context.cardColor;
    final bgColor = context.adaptiveSurface;

    final tp = context.watch<TeamTaskProvider>();
    final teamProv = context.watch<TeamProvider>();
    tp.watchTeamTasks(teamId: teamProv.teamId, createdByUserId: teamProv.userId, createdByRole: 'owner');
    final completionPct = tp.totalCount == 0 ? 0.0 : tp.completionRate;
    final healthScore = tp.totalCount == 0 ? 0 : (completionPct * 100).toInt();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  Icon(Icons.grid_view_rounded, size: 22, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    tr(context, 'my_team'),
                    style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  const Spacer(),
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

              // ── ADD TASK Button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showAssignTaskDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 22, color: Colors.white),
                  label: Text(
                    tr(context, 'add_task'),
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── ALL TASKS LIST ──
              Text(
                tr(context, 'all_tasks'),
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: 1.2),
              ),
              const SizedBox(height: 16),

              if (tp.allTasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Icon(Icons.assignment_outlined, size: 56, color: labelColor),
                      const SizedBox(height: 16),
                      Text(
                        tr(context, 'no_tasks_yet'),
                        style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(tr(context, 'assign_tasks_hint'), style: GoogleFonts.inter(fontSize: 13, color: labelColor)),
                    ],
                  ),
                )
              else
                ...tp.allTasks.map((task) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _taskItem(context, task, cardColor, isDark, textPrimary, textSecondary, labelColor, tp))),

              const SizedBox(height: 32),

              // ── PERFORMANCE Section ──
              Text(
                tr(context, 'performance'),
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: 1.2),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isDark ? [] : [BoxShadow(color: context.subtleShadow, blurRadius: 14, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Text(
                      tr(context, 'team_health_score'),
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: labelColor, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$healthScore',
                            style: GoogleFonts.manrope(fontSize: 52, fontWeight: FontWeight.w800, color: const Color(0xFF3B82F6)),
                          ),
                          TextSpan(
                            text: '/100',
                            style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w600, color: labelColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _performanceRow(tr(context, 'tasks_completed'), '${tp.completedCount}', const Color(0xFF22C55E), textPrimary),
                    const SizedBox(height: 14),
                    _performanceRow(tr(context, 'tasks_pending'), '${tp.pendingCount}', const Color(0xFF3B82F6), textPrimary),
                    const SizedBox(height: 14),
                    _performanceRow(tr(context, 'team_members'), '${teamProv.members.length}', const Color(0xFF8B5CF6), textPrimary),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ──

  Widget _statCard(BuildContext context, Color cardColor, bool isDark, Color labelColor, Color textPrimary, Color textSecondary, IconData icon, Color iconColor, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark ? [] : [BoxShadow(color: context.subtleShadow, blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: iconColor),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _taskItem(BuildContext context, TeamTask task, Color cardColor, bool isDark, Color textPrimary, Color textSecondary, Color labelColor, TeamTaskProvider tp) {
    final statusColor = task.isDone ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);
    final icon = task.isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => tp.deleteTask(task.id),
      child: GestureDetector(
        onTap: () => tp.toggleStatus(task.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isDark ? [] : [BoxShadow(color: context.subtleShadow, blurRadius: 10, offset: const Offset(0, 3))],
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
                    // Show who it's assigned to
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: labelColor),
                        const SizedBox(width: 4),
                        Text(
                          task.assignedTo.isNotEmpty ? task.assignedTo : tr(context, 'unassigned'),
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF3B82F6)),
                        ),
                        if (task.note.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text('•', style: GoogleFonts.inter(fontSize: 12, color: labelColor)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.note,
                              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 22, color: textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _performanceRow(String label, String value, Color valueColor, Color textPrimary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
        ),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor),
        ),
      ],
    );
  }

  Color _avatarColor(int index) {
    const colors = [Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF0EA5E9), Color(0xFF6366F1), Color(0xFFEC4899)];
    return colors[index % colors.length];
  }

  // ── Dialogs ──

  void _showAddMemberDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(tr(context, 'add_member'), style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: nameCtrl,
          style: GoogleFonts.inter(fontSize: 15),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: tr(context, 'enter_member_name'), hintStyle: GoogleFonts.inter(fontSize: 14), prefixIcon: const Icon(Icons.person_add_alt_1, size: 20)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr(ctx, 'cancel'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (nameCtrl.text.trim().isNotEmpty) {
                context.read<TeamProvider>().addMember(nameCtrl.text.trim());
              }
            },
            child: Text(
              tr(ctx, 'add'),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveMember(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('${tr(ctx, 'remove_member_q_prefix')}$name${tr(ctx, 'remove_member_q_suffix')}', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text(tr(ctx, 'remove_member_msg'), style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr(ctx, 'cancel'), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TeamProvider>().removeMember(name);
            },
            child: Text(
              tr(ctx, 'remove'),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignTaskDialog(BuildContext context) {
    TeamMemberInfo? selectedMember;
    final members = context.read<TeamProvider>().memberInfos;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = ctx.isDark;
          final sheetBg = ctx.cardColor;
          final textPrimary = ctx.textPrimary;
          final labelColor = ctx.textHint;

          return Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.55),
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: isDark ? Colors.white24 : const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(2)),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                  child: Row(
                    children: [
                      Text(
                        tr(ctx, 'assign_to_member'),
                        style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Icon(Icons.close, size: 22, color: labelColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Members list
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: members.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: ctx.cardBorder),
                    itemBuilder: (_, i) {
                      final member = members[i];
                      final isSelected = selectedMember?.userId == member.userId;

                      return GestureDetector(
                        onTap: () => setState(() => selectedMember = member),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [_avatarColor(i), _avatarColor(i).withValues(alpha: 0.7)]),
                                ),
                                child: Center(
                                  child: Text(
                                    member.name[0].toUpperCase(),
                                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Name + dept
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          member.name,
                                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                                        ),
                                        const SizedBox(width: 6),
                                        if (isSelected)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF22C55E)),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      member.email.isNotEmpty ? member.email : member.department,
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: labelColor, letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              // Radio
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : (isDark ? Colors.white30 : const Color(0xFFD1D5DB)), width: 2),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF3B82F6)),
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // CONTINUE button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: selectedMember != null
                          ? () {
                              Navigator.pop(ctx);
                              _showNewTaskScreen(context, selectedMember!);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        disabledBackgroundColor: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        tr(ctx, 'continue_btn'),
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showNewTaskScreen(BuildContext context, TeamMemberInfo member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _NewTaskScreen(
          member: member,
          onTaskCreated: (TeamTask task) {
            context.read<TeamTaskProvider>().addTask(task);
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Full-page New Task creation screen
// ─────────────────────────────────────────────────────────────────────
class _NewTaskScreen extends StatefulWidget {
  final TeamMemberInfo member;
  final void Function(TeamTask task) onTaskCreated;

  const _NewTaskScreen({required this.member, required this.onTaskCreated});

  @override
  State<_NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<_NewTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: now, firstDate: now.subtract(const Duration(days: 30)), lastDate: now.add(const Duration(days: 365)));
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'mm/dd/yyyy';
    return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
  }

  void _sendTask() {
    if (_titleCtrl.text.trim().isEmpty) return;
    widget.onTaskCreated(TeamTask(id: DateTime.now().millisecondsSinceEpoch.toString(), title: _titleCtrl.text.trim(), note: _detailsCtrl.text.trim(), assignedTo: widget.member.name, assignedToUserId: widget.member.userId));
    setState(() => _sent = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = context.adaptiveSurface;
    final cardColor = context.cardColor;
    final textPrimary = context.textPrimary;
    final labelColor = context.textHint;
    final fieldBg = context.inputFill;

    if (_sent) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF22C55E)),
                child: const Icon(Icons.check_rounded, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                tr(context, 'task_sent'),
                style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text('${tr(context, 'assigned_to')} ${widget.member.name}', style: GoogleFonts.inter(fontSize: 14, color: labelColor)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${tr(context, 'new_task_for')} ${widget.member.name}',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF6366F1)]),
              ),
              child: const Center(child: Icon(Icons.person, size: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: [
            // Form Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDark ? [] : [BoxShadow(color: context.subtleShadow, blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  Text(
                    tr(context, 'task_title'),
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _titleCtrl,
                    style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                    decoration: InputDecoration(
                      hintText: tr(context, 'what_needs_done'),
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: labelColor),
                      filled: true,
                      fillColor: fieldBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // From
                  Text(
                    tr(context, 'from'),
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _pickDate(true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 18, color: const Color(0xFF3B82F6)),
                          const SizedBox(width: 12),
                          Text(_formatDate(_fromDate), style: GoogleFonts.inter(fontSize: 14, color: _fromDate != null ? textPrimary : labelColor)),
                          const Spacer(),
                          Icon(Icons.calendar_month_rounded, size: 20, color: labelColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // To
                  Text(
                    tr(context, 'to'),
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _pickDate(false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 18, color: const Color(0xFF3B82F6)),
                          const SizedBox(width: 12),
                          Text(_formatDate(_toDate), style: GoogleFonts.inter(fontSize: 14, color: _toDate != null ? textPrimary : labelColor)),
                          const Spacer(),
                          Icon(Icons.calendar_month_rounded, size: 20, color: labelColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Details
                  Text(
                    tr(context, 'details'),
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _detailsCtrl,
                    style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: tr(context, 'add_context'),
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: labelColor),
                      filled: true,
                      fillColor: fieldBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Send Task button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _titleCtrl.text.trim().isNotEmpty ? _sendTask : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  disabledBackgroundColor: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr(context, 'send_task'),
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.send_rounded, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Info text
            Text(
              '${tr(context, 'task_visible_prefix')}${widget.member.name}${tr(context, 'task_visible_suffix')}',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: labelColor, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
