import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/app_nav.dart';
import 'simulation_report_screen.dart';

class SimulationActiveScreen extends StatefulWidget {
  final String roleName;
  final String scenarioName;
  final String difficulty;

  const SimulationActiveScreen({
    super.key,
    this.roleName      = 'Senior Web Developer',
    this.scenarioName  = 'Internship Interview',
    this.difficulty    = 'Medium',
  });

  @override
  State<SimulationActiveScreen> createState() =>
      _SimulationActiveScreenState();
}

class _SimulationActiveScreenState extends State<SimulationActiveScreen>
    with TickerProviderStateMixin {
  int _seconds = 0; // start from 00:00
  Timer? _timer;
  bool _running = true;
  int _navIndex = 1;

  late AnimationController _pulseCtrl;
  late AnimationController _waveCtrl;

  static const Color kBg       = Color(0xFF1C0E4E);
  static const Color kCard     = Color(0xFF3D2490);
  static const Color kPrimary  = Color(0xFF5B2DD9);
  static const Color kYellow   = Color(0xFFC8F55A);
  static const Color kYellowDk = Color(0xFF1C0E4E);
  static const Color kSubtitle = Color(0xFFB9A8E8);
  static const Color kMuted    = Color(0xFF7B6AB5);
  static const Color kOrange   = Color(0xFFE8860A);
  static const Color kRed      = Color(0xFFCC3333);
  static const Color kStop     = Color(0xFFFF4A6E);
  static const Color kNavBg    = Color(0xFF290451);
  static const Color kNavActive= Color(0xFFD9E366);
  static const Color kNavInact = Color(0xFF7A50A0);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_running) setState(() => _seconds++);
    });
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  String get _timeLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Timer + Stop ──────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('In progress',
                          style: TextStyle(
                              fontSize: 12, color: kSubtitle)),
                      Text(
                        _timeLabel,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _timer?.cancel();
                      _waveCtrl.stop();
                      setState(() => _running = false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SimulationReportScreen(
                            roleName: widget.roleName,
                            selectedAI: 2,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: kStop,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Stop',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Context bar ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text('💻',
                        style: TextStyle(
                            fontSize: 11, color: kYellow)),
                    const SizedBox(width: 6),
                    Text(widget.roleName,
                        style: const TextStyle(
                            fontSize: 11, color: kSubtitle)),
                    Container(
                      width: 1,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: kPrimary,
                    ),
                    Text(widget.scenarioName,
                        style: const TextStyle(
                            fontSize: 11, color: kSubtitle)),
                    Container(
                      width: 1,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: kPrimary,
                    ),
                    Text(
                      widget.difficulty,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: kYellow,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── AI Avatar ─────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) {
                        final scale =
                            1.0 + 0.05 * sin(_pulseCtrl.value * pi);
                        return Transform.scale(
                          scale: scale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring (faint)
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: kYellow.withOpacity(0.12),
                                    width: 0.6,
                                  ),
                                ),
                              ),
                              // Middle ring
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: kYellow.withOpacity(0.25),
                                    width: 1,
                                  ),
                                ),
                              ),
                              // Inner circle
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE6BEF0),
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'AI',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: kYellow,
                                      ),
                                    ),
                                    Container(
                                      width: 28,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius:
                                            BorderRadius.circular(5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Yellow bar (mouth indicator)
                    Container(
                      width: 48,
                      height: 8,
                      decoration: BoxDecoration(
                        color: kYellow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Coach + Therapist · Listening...',
                      style: TextStyle(
                          fontSize: 11, color: kSubtitle),
                    ),

                    const SizedBox(height: 12),

                    // Waveform
                    AnimatedBuilder(
                      animation: _waveCtrl,
                      builder: (_, __) => CustomPaint(
                        size: Size(
                            MediaQuery.of(context).size.width * 0.7,
                            40),
                        painter: _WaveformPainter(
                          progress: _waveCtrl.value,
                          color: kYellow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── AI Question card ──────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kPrimary, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('"',
                            style: TextStyle(
                                fontSize: 22, color: kYellow)),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'You said you know React — walk me through how you\'d architect a real-time dashboard with live data updates.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const Text('"',
                            style: TextStyle(
                                fontSize: 22, color: kYellow)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ARIA · Senior Dev Role',
                        style: TextStyle(
                            fontSize: 10, color: kYellow),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Live metrics card ─────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _MetricRow(
                        label: 'Speed',
                        value: 'Fast ↑',
                        valueColor: kOrange),
                    _divider(),
                    _MetricRow(
                        label: 'Emotion',
                        value: 'Nervous',
                        valueColor: kOrange,
                        dot: true,
                        dotColor: kOrange),
                    _divider(),
                    _MetricRow(
                        label: 'Volume',
                        value: 'Good',
                        valueColor: kYellow),
                    _divider(),
                    _MetricRow(
                        label: 'Confidence',
                        value: 'Low ↓',
                        valueColor: kRed),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Session progress ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Session progress',
                      style: TextStyle(
                          fontSize: 11, color: kMuted)),
                  const Text('1:48 / 5:00',
                      style: TextStyle(
                          fontSize: 11, color: kMuted)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 108 / 300,
                  minHeight: 6,
                  backgroundColor: kCard,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(kYellow),
                ),
              ),

              const SizedBox(height: 14),

              // ── Stats row ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12),
                      decoration: BoxDecoration(
                        color: kCard,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Text('Questions asked',
                              style: TextStyle(
                                  fontSize: 11, color: kSubtitle)),
                          SizedBox(height: 4),
                          Text('3 / 8',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12),
                      decoration: BoxDecoration(
                        color: kCard,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Text('Avg response time',
                              style: TextStyle(
                                  fontSize: 11, color: kSubtitle)),
                          SizedBox(height: 4),
                          Text('12 sec',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Divider(
      color: Colors.white.withOpacity(0.06), height: 1, thickness: 1);

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      (Icons.home_outlined,         'Home'),
      (Icons.show_chart_rounded,    'Progress'),
      (Icons.headset_mic_outlined,  'Support'),
      (Icons.person_outline_rounded,'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: kNavBg,
        border: Border(
            top: BorderSide(color: Color(0xFF3D2A7A), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = _navIndex == i;
          final color  = active ? kNavActive : kNavInact;
          return GestureDetector(
            onTap: () => navigateTo(context, i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[i].$1, color: color, size: 22),
                const SizedBox(height: 3),
                Text(items[i].$2,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: active
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: color,
                    )),
                if (active) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: kNavActive, shape: BoxShape.circle),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Metric row ─────────────────────────────────────────────────────────────────
class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool dot;
  final Color? dotColor;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.dot = false,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFFB9A8E8))),
          const Spacer(),
          if (dot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor,
              )),
        ],
      ),
    );
  }
}

// ── Waveform painter ───────────────────────────────────────────────────────────
class _WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;

  static const List<double> _h = [
    0.3, 0.5, 0.4, 0.8, 0.6, 1.0, 0.9, 0.7, 1.0, 0.8,
    0.6, 0.9, 0.7, 0.5, 0.8, 0.6, 0.4, 0.7, 0.5, 0.3,
    0.2, 0.15, 0.1,
  ];

  const _WaveformPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final count = _h.length;
    final barW  = (size.width * 0.032).clamp(3.0, 7.0);
    final gap   = (size.width - count * barW) / (count - 1);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final phase = (progress + i / count) % 1.0;
      final anim  = 0.65 + 0.35 * sin(phase * 2 * pi);
      final h     = _h[i] * size.height * anim;
      final x     = i * (barW + gap);
      final y     = (size.height - h) / 2;
      // Fade toward edges
      final opacity = (0.2 + 0.8 * sin(i / (count - 1) * pi))
          .clamp(0.0, 1.0);
      paint.color = color.withOpacity(opacity);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, barW, h), const Radius.circular(3)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.progress != progress;
}
