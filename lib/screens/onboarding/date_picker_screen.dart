import 'package:flutter/material.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime? initialDate;
  const DatePickerScreen({super.key, this.initialDate});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime _viewMonth;
  DateTime? _selected;

  static const Color kBg       = Color(0xFFF5F0FA);
  static const Color kCard     = Color(0xFFFFFEF6);
  static const Color kPrimary  = Color(0xFF2F0A56);
  static const Color kBorder   = Color(0xFFF0D4FF);
  static const Color kCalBg    = Color(0xFFEDE0FF); // rgba(230,190,240,0.2)
  static const Color kDayBg    = Color(0xFFFFFFFF);
  static const Color kSelected = Color(0xFF2F0A56);
  static const Color kYellow   = Color(0xFFD9E366); // rgba(217,227,102,0.24) header bg
  static const Color kNavBg    = Color(0xFFE6C6F7); // rgba(230,198,247,0.47)
  static const Color kWeekBg   = Color(0xFFE6C6F7);
  static const Color kConfirm  = Color(0xFF2F0A56);

  static const List<String> _weekdays = [
    'MON', 'TUE', 'WED', 'THURS', 'FRI', 'SAT', 'SUN'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(
      widget.initialDate?.year ?? now.year,
      widget.initialDate?.month ?? now.month,
    );
    _selected = widget.initialDate;
  }

  String get _monthLabel {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[_viewMonth.month - 1]} ${_viewMonth.year}';
  }

  void _prevMonth() => setState(() {
        _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
      });

  /// Returns list of day numbers (null = empty cell) for the grid.
  /// Week starts on Monday.
  List<int?> _buildDays() {
    final firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final daysInMonth =
        DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    // weekday: Mon=1 … Sun=7
    final startOffset = firstDay.weekday - 1; // 0-based offset
    final cells = <int?>[];
    for (int i = 0; i < startOffset; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) cells.add(d);
    // Pad to full rows
    while (cells.length % 7 != 0) cells.add(null);
    return cells;
  }

  bool _isSelected(int day) =>
      _selected != null &&
      _selected!.year == _viewMonth.year &&
      _selected!.month == _viewMonth.month &&
      _selected!.day == day;

  @override
  Widget build(BuildContext context) {
    final days = _buildDays();
    final rows = days.length ~/ 7;

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ── Big decorative circle ──────────────────────────────────
          Positioned(
            top: -151,
            left: -70,
            child: Container(
              width: 587,
              height: 462,
              decoration: const BoxDecoration(
                color: Color(0x4DE6BEF0),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Header ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.chevron_left_rounded,
                            color: kPrimary, size: 28),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: kPrimary,
                          letterSpacing: -0.01 * 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Calendar card ───────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kCard,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: const Color(0xFFF8F8F8), width: 10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // ── Month nav ─────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                // Prev arrow
                                GestureDetector(
                                  onTap: _prevMonth,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: kNavBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chevron_left_rounded,
                                      color: kPrimary,
                                      size: 18,
                                    ),
                                  ),
                                ),

                                // Month + year with yellow highlight
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: kYellow.withOpacity(0.24),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _monthLabel,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: kPrimary,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),

                                // Next arrow
                                GestureDetector(
                                  onTap: _nextMonth,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: kNavBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chevron_right_rounded,
                                      color: kPrimary,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Calendar grid ─────────────────────
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0x33E6BEF0), // rgba(230,190,240,0.2)
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                      color: const Color(0xFFF0D4FF), // #F0D4FF
                                      width: 6),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    8, 10, 8, 10),
                                child: Column(
                                  children: [
                                    // Weekday headers
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      decoration: BoxDecoration(
                                        color: kWeekBg,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: _weekdays
                                            .map((d) => Expanded(
                                                  child: Text(
                                                    d,
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: kPrimary,
                                                      letterSpacing: -0.1,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    // Day cells
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                        children: List.generate(
                                          rows,
                                          (r) => Row(
                                            children: List.generate(
                                              7,
                                              (c) {
                                                final day =
                                                    days[r * 7 + c];
                                                final sel = day != null &&
                                                    _isSelected(day);
                                                return Expanded(
                                                  child: GestureDetector(
                                                    onTap: day == null
                                                        ? null
                                                        : () => setState(
                                                              () => _selected =
                                                                  DateTime(
                                                                _viewMonth
                                                                    .year,
                                                                _viewMonth
                                                                    .month,
                                                                day,
                                                              ),
                                                            ),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets
                                                              .all(2),
                                                      height: 30,
                                                      decoration:
                                                          BoxDecoration(
                                                        color: sel
                                                            ? kSelected
                                                            : (day != null
                                                                ? kDayBg
                                                                : Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    6),
                                                      ),
                                                      child: Center(
                                                        child: day != null
                                                            ? Text(
                                                                '$day',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: sel
                                                                      ? Colors
                                                                          .white
                                                                      : kPrimary,
                                                                  letterSpacing:
                                                                      -0.1,
                                                                ),
                                                              )
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Confirm button ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 28),
                  child: SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, _selected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kConfirm,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
