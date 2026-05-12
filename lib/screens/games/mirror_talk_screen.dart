import 'dart:math';
import 'package:flutter/material.dart';
import 'mirror_talk_result_screen.dart';
import 'mirror_talk_fail_screen.dart';
import '../../core/app_nav.dart';

class MirrorTalkScreen extends StatefulWidget {
  const MirrorTalkScreen({super.key});

  @override
  State<MirrorTalkScreen> createState() => _MirrorTalkScreenState();
}

class _MirrorTalkScreenState extends State<MirrorTalkScreen>
    with TickerProviderStateMixin {
  int _round = 1;
  final int _totalRounds = 5;
  int _navIndex = 1;
  int _totalScore = 0; // accumulates per round (0–100 each)

  late AnimationController _waveCtrl;
  late AnimationController _pulseCtrl;

  // ── Colours ────────────────────────────────────────────────────────────────
  static const Color kBg        = Color(0xFF350065);
  static const Color kHeaderBg  = Color(0xFF1E0040);
  static const Color kCardBg    = Color(0xFF5300AC);
  static const Color kDarkCard  = Color(0xFF220046);
  static const Color kYellow    = Color(0xFFD9E366);
  static const Color kYellowDark= Color(0xFF1A2000);
  static const Color kSubtitle  = Color(0xFF7A50A0);
  static const Color kNavActive = Color(0xFFD9E366);
  static const Color kNavInact  = Color(0xFF5A3A70);
  static const Color kAvatarBg  = Color(0xFF5300AC);

  static const List<String> _prompts = [
    '"Tell me about your best\nday ever."',
    '"Describe your favourite\nplace in the world."',
    '"What makes you feel\nmost confident?"',
    '"Talk about a challenge\nyou overcame."',
    '"Share something that\nmakes you laugh."',
  ];

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _nextRound() {
    // Simulate a score per round (replace with real speech analysis score)
    // Score 45/round → avg 45 → triggers fail screen (< 50)
    _totalScore += 45;
    if (_round < _totalRounds) {
      setState(() => _round++);
    } else {
      final avgScore = _totalScore ~/ _totalRounds;
      // Fail: avg score < 50 → MirrorTalkFailScreen
      // Pass: avg score >= 50 → MirrorTalkResultScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => avgScore >= 50
              ? const MirrorTalkResultScreen()
              : const MirrorTalkFailScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _round / _totalRounds;

    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: kHeaderBg,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: label + round badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Game 1 · Mirror Talk',
                          style: TextStyle(
                            fontSize: 12,
                            color: kSubtitle,
                          ),
                        ),
                        // Round badge
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: kYellow.withOpacity(0.25),
                                width: 1.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_round',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: kYellow,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                'of 5',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: kSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Title
                    const Text(
                      'Speak it.',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.48,
                      ),
                    ),
                    const Text(
                      'Feel it.',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.48,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(kYellow),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Prompt card ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFE6BEF0).withOpacity(0.4),
                        width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YOUR PROMPT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: kSubtitle,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _prompts[_round - 1],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Emotion detection card ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kDarkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFE6BEF0).withOpacity(0.1),
                        width: 1),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (_, __) {
                          final scale =
                              1.0 + 0.04 * sin(_pulseCtrl.value * pi);
                          return Transform.scale(
                            scale: scale,
                            child: _buildAvatar(),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      // Emotion row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Detected emotion',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kSubtitle,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Excited',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                '88%',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: kYellow,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                'expression',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: kSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Expression progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: LinearProgressIndicator(
                          value: 0.80,
                          minHeight: 7,
                          backgroundColor: Colors.white.withOpacity(0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            kYellow.withOpacity(0.85),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Waveform
                      AnimatedBuilder(
                        animation: _waveCtrl,
                        builder: (_, __) => CustomPaint(
                          size: Size(
                              MediaQuery.of(context).size.width - 80, 48),
                          painter: _WaveformPainter(
                            progress: _waveCtrl.value,
                            color: kYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Stars + XP row ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Stars (3 filled, 2 empty)
                    ...List.generate(5, (i) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            i < 3 ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: i < 3
                                ? kYellow
                                : kYellow.withOpacity(0.25),
                            size: 26,
                          ),
                        )),
                    const Spacer(),
                    // XP badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: kYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: kYellow.withOpacity(0.25), width: 1.5),
                      ),
                      child: const Text(
                        '+30 XP',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kYellow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Next round button ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _nextRound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kYellow,
                      foregroundColor: kYellowDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _round < _totalRounds
                          ? 'Next round →'
                          : 'Finish  ✓',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── AI avatar ──────────────────────────────────────────────────────────────
  Widget _buildAvatar() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: kYellow.withOpacity(0.12), width: 1.5),
            ),
          ),
          // Inner ring
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: kYellow.withOpacity(0.06), width: 1),
            ),
          ),
          // Avatar circle
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: kAvatarBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.face_rounded,
              color: Color(0xFFE6BEF0),
              size: 36,
            ),
          ),
          // Yellow dot (active indicator)
          Positioned(
            bottom: 14,
            right: 14,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF5A9040),
                shape: BoxShape.circle,
                border: Border.all(color: kDarkCard, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      (Icons.home_outlined,         'Home'),
      (Icons.show_chart_rounded,    'Progress'),
      (Icons.headset_mic_outlined,  'Support'),
      (Icons.person_outline_rounded,'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
              color: const Color(0xFFE6BEF0).withOpacity(0.08), width: 1),
        ),
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
                Text(
                  items[i].$2,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        active ? FontWeight.w700 : FontWeight.w400,
                    color: color,
                  ),
                ),
                if (active) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: kNavActive,
                      shape: BoxShape.circle,
                    ),
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

// ── Waveform painter ───────────────────────────────────────────────────────────
class _WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;

  static const List<double> _h = [
    0.28, 0.45, 0.65, 0.80, 0.55, 0.90, 0.70, 0.45,
    0.85, 0.60, 0.38, 0.75, 0.50, 0.35, 0.62, 0.42,
    0.72, 0.30, 0.55, 0.80, 0.40, 0.68, 0.28,
  ];

  const _WaveformPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final count = _h.length;
    final barW  = (size.width * 0.032).clamp(3.0, 8.0);
    final gap   = (size.width - count * barW) / (count - 1);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final phase = (progress + i / count) % 1.0;
      final anim  = 0.65 + 0.35 * sin(phase * 2 * pi);
      final h     = _h[i] * size.height * anim;
      final x     = i * (barW + gap);
      final y     = (size.height - h) / 2;
      // Fade opacity toward edges
      final opacity = 0.28 + 0.72 * sin(i / (count - 1) * pi);
      paint.color = color.withOpacity(opacity.clamp(0.0, 1.0));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, barW, h), const Radius.circular(3)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => old.progress != progress;
}
