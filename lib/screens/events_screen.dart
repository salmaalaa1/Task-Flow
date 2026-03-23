import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import '../l10n/translations.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ep = context.watch<EventProvider>();
    context.watch<SettingsProvider>();
    final events = ep.eventsForSelectedDate;
    final sel = ep.selectedDate;
    final now = DateTime.now();
    final weekStart = sel.subtract(Duration(days: sel.weekday - 1));
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(tr(context, 'events'), style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: context.textPrimary)),
              GestureDetector(
                onTap: () => _showAddEventDialog(context, ep, sel),
                child: Container(width: 40, height: 40,
                    decoration: BoxDecoration(color: context.cardColorStrong, borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.add, size: 22, color: context.textSecondary)),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        // Calendar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: context.cardBorder)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(_monthYear(context, sel), style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimary)),
                Row(children: [
                  GestureDetector(onTap: () => ep.selectDate(sel.subtract(const Duration(days: 7))),
                      child: Icon(Icons.chevron_left, size: 20, color: context.textSecondary)),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: () => ep.selectDate(sel.add(const Duration(days: 7))),
                      child: Icon(Icons.chevron_right, size: 20, color: context.textSecondary)),
                ]),
              ]),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: dayKeys.map((d) => SizedBox(width: 36,
                    child: Center(child: Text(tr(context, d), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary))))).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDays.map((day) {
                  final isSelected = day.day == sel.day && day.month == sel.month && day.year == sel.year;
                  final isToday = day.day == now.day && day.month == now.month && day.year == now.year;
                  final hasEvents = ep.allEvents.any((e) => e.isOnDate(day));
                  return GestureDetector(
                    onTap: () => ep.selectDate(day),
                    child: Container(
                      width: 36, height: 44,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        border: isToday && !isSelected ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2) : null),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('${day.day}', style: GoogleFonts.inter(fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : context.textPrimary)),
                        if (hasEvents)
                          Container(width: 4, height: 4, margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.white : AppColors.primary)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            events.isEmpty ? tr(context, 'no_events') : '${events.length} ${events.length == 1 ? tr(context, 'event_count_one').split(' ').last : tr(context, 'events')}',
            style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary)),
        ),
        const SizedBox(height: 16),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Center(child: Column(children: [
              Icon(Icons.event_available, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(tr(context, 'no_events_on_day'), style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: context.textSecondary)),
              const SizedBox(height: 4),
              Text(tr(context, 'tap_add_event'), style: GoogleFonts.inter(fontSize: 14, color: context.textHint)),
            ])),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: events.map((event) => _eventCard(context, event, ep)).toList()),
          ),
      ]),
    );
  }

  Widget _eventCard(BuildContext context, Event event, EventProvider ep) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(event.id), direction: DismissDirection.endToStart,
        onDismissed: (_) => ep.deleteEvent(event.id),
        background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(color: AppColors.urgentRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
          child: Icon(Icons.delete_outline, color: AppColors.urgentRed, size: 28)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: context.cardBorder)),
          child: Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: event.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                child: Icon(event.icon, color: event.color, size: 24)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: context.textPrimary)),
              const SizedBox(height: 4),
              Text(event.location, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondary)),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.schedule, size: 13, color: event.color.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Text(event.formattedTimeRange, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: event.color)),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }

  String _monthYear(BuildContext context, DateTime d) {
    final monthKeys = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'];
    return '${tr(context, monthKeys[d.month - 1])} ${d.year}';
  }

  void _showAddEventDialog(BuildContext context, EventProvider ep, DateTime date) {
    final titleCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: BoxDecoration(color: context.adaptiveSurface, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(tr(context, 'new_event'), style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimary)),
          const SizedBox(height: 20),
          TextField(controller: titleCtrl, style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
              decoration: InputDecoration(hintText: tr(context, 'event_title_hint'), filled: true, fillColor: context.inputFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
          const SizedBox(height: 12),
          TextField(controller: locationCtrl, style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
              decoration: InputDecoration(hintText: tr(context, 'location'), filled: true, fillColor: context.inputFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                ep.addEvent(Event(id: DateTime.now().millisecondsSinceEpoch.toString(), title: titleCtrl.text.trim(), location: locationCtrl.text.trim(), date: date));
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text(tr(context, 'add_event'), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}
