import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final TaskPriority priority;
  final String time;
  final String metadata;
  final bool isCompleted;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.priority,
    required this.time,
    required this.metadata,
    this.isCompleted = false,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color priorityColor;
    final String priorityLabel;
    switch (priority) {
      case TaskPriority.urgent:
        priorityColor = AppColors.urgentRed;
        priorityLabel = 'Urgent';
        break;
      case TaskPriority.medium:
        priorityColor = AppColors.mediumAmber;
        priorityLabel = 'Medium';
        break;
      case TaskPriority.low:
        priorityColor = AppColors.lowGreen;
        priorityLabel = 'Low';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: isCompleted ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: context.cardBorder),
            boxShadow: [BoxShadow(color: context.cardShadow, blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (onToggle != null)
                    GestureDetector(
                      onTap: onToggle,
                      child: Container(
                        width: 24, height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isCompleted ? AppColors.primary : AppColors.outlineVariant, width: 2),
                          color: isCompleted ? AppColors.primary : Colors.transparent,
                        ),
                        child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                      ),
                    ),
                  Expanded(
                    child: Text(title,
                        style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimary,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: priorityColor)),
                      const SizedBox(width: 4),
                      Text(priorityLabel, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: priorityColor)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: context.textSecondary.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  Text(time, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondary.withValues(alpha: 0.6))),
                  const SizedBox(width: 16),
                  Icon(Icons.label_outline, size: 14, color: context.textSecondary.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  Text(metadata, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondary.withValues(alpha: 0.6))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
