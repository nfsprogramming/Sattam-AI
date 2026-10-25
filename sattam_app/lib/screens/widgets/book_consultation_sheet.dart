import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class BookConsultationSheet extends StatefulWidget {
  final Map<String, dynamic> lawyer;

  const BookConsultationSheet({super.key, required this.lawyer});

  @override
  State<BookConsultationSheet> createState() => _BookConsultationSheetState();
}

class _BookConsultationSheetState extends State<BookConsultationSheet> {
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isBooking = false;

  final List<String> _timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:30 AM - 11:30 AM',
    '01:00 PM - 02:00 PM',
    '03:00 PM - 04:00 PM',
    '05:00 PM - 06:00 PM',
  ];

  Future<void> _handleBooking() async {
    if (_selectedDate == null || _selectedTime == null) return;

    setState(() => _isBooking = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isBooking = false);
      Navigator.pop(context, true); // true indicates success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Book Consultation',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'with ${widget.lawyer['name']}',
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            
            // Date Picker
            Text(
              'Select Date',
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: context.colors.primary,
                          onPrimary: Colors.white,
                          surface: context.colors.surface,
                          onSurface: context.colors.textPrimary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: context.colors.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null 
                          ? 'Choose a date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: GoogleFonts.plusJakartaSans(
                        color: _selectedDate == null ? context.colors.textMuted : context.colors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right_rounded, color: context.colors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Time Slots
            Text(
              'Select Time',
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _selectedTime = time);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? context.colors.primary : context.colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? context.colors.primary : context.colors.borderSubtle,
                      ),
                    ),
                    child: Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? Colors.white : context.colors.textPrimary,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedDate != null && _selectedTime != null && !_isBooking) 
                    ? _handleBooking 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: context.colors.surfaceContainerHigh,
                  disabledForegroundColor: context.colors.textMuted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isBooking
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Confirm Booking',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
