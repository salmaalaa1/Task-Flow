import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_utils.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;
  final int count;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = context.isDark
        ? iconColor.withValues(alpha: 0.15)
        : backgroundColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Center(child: Icon(icon, color: iconColor, size: 30)),
              if (count > 0)
                Positioned(
                  top: 4, right: 4,
                  child: Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$count',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: context.textSecondary)),
      ],
    );
  }
}
