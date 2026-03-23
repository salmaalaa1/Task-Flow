import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class PerformanceChart extends StatelessWidget {
  final List<double> weeklyData;
  const PerformanceChart({super.key, this.weeklyData = const []});

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    final days = [tr(context, 'mon'), tr(context, 'tue'), tr(context, 'wed'), tr(context, 'thu'), tr(context, 'fri')];
    final data = weeklyData.isNotEmpty ? weeklyData : [0.60, 0.80, 0.70, 0.95, 0.50];
    final avg = data.isEmpty ? 0.0 : data.reduce((a, b) => a + b) / data.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.overlayLight, borderRadius: BorderRadius.circular(40),
        border: Border.all(color: context.cardBorder),
        boxShadow: [BoxShadow(color: context.cardShadow, blurRadius: 40, offset: const Offset(0, 15))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr(context, 'weekly_performance'),
                style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary)),
            const SizedBox(height: 2),
            Text('${tr(context, 'daily_average')}: ${(avg * 100).toInt()}%',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondary)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: context.isDark ? const Color(0xFF15803D).withValues(alpha: 0.2) : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.trending_up, size: 14, color: Color(0xFF15803D)),
              const SizedBox(width: 4),
              Text('${(avg * 100).toInt() > 50 ? '+' : ''}${((avg - 0.5) * 100).toInt()}%',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF15803D))),
            ]),
          ),
        ]),
        const SizedBox(height: 24),
        SizedBox(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (i) {
              final isToday = i == DateTime.now().weekday - 1;
              final value = i < data.length ? data[i].clamp(0.0, 1.0) : 0.3;
              final barHeight = 50.0 + value * 90;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      width: double.infinity, height: barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: context.isDark ? 0.15 : 0.1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isToday ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3 + value * 0.3),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(days[i], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700,
                        color: isToday ? AppColors.primary : context.textSecondary)),
                  ]),
                ),
              );
            }),
          ),
        ),
      ]),
    );
  }
}
