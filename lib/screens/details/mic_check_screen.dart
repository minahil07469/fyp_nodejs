import 'dart:math';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class MicCheckScreen extends StatefulWidget {
  const MicCheckScreen({super.key});

  @override
  State<MicCheckScreen> createState() => _MicCheckScreenState();
}

class _MicCheckScreenState extends State<MicCheckScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _waveCtrl;

  static const Color kBg        = Color(0xFF1A0535);
  static const Color kPrimary   = Color(0xFF5300AC);
  static const Color kCardBg    = Color(0xFF2D0A52);
  static const Color kCardBorder = Color(0xFFF0D4FF);
  static const Color kSubtitle  = Color(0xFFC097D8);
  static const Color kYellow    = Color(0xFFCDCC58);
  static const Color kMicInner  = Color(0xFF3D1080);
  static const Color kMicOuter  = Color(0xFF4A1A90);
  static const Color kQualityBg = Color(0xFF3A1260);

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final w      = size.width;
    final h      = size.height;

    // Responsive scale factor based on 390px reference width
    final scale  = (w / 390).clamp(0.6, 1.4);

    // Headline font scales with width
    final titleFs  = (39 * scale).clamp(24.0, 48.0);
    final subFs    = (16 * scale).clamp(12.0, 20.0);

    // Mic circle sizes scale with available card height
    // Card takes ~55% of screen height
    final cardH    = h * 0.55;
    final outerD   = (cardH * 0.42).clamp(120.0, 220.0);
    final middleD  = (outerD * 0.80).clamp(96.0, 176.0);
    final innerD   = (outerD * 0.55).clamp(66.0, 121.0);
    final micIcon  = (innerD * 0.42).clamp(28.0, 50.0);
    final dotSize  = (outerD * 0.11).clamp(16.0, 26.0);

    // Waveform width fills card minus padding
    final waveW    = (w - 80).clamp(160.0, 320.0);
    final waveH    = (cardH * 0.13).clamp(36.0, 70.0);

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Headline ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.06, h * 0.04, w * 0.06, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's check",
                    style: TextStyle(
                      fontSize: titleFs,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.08,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8 * scale, vertical: 3 * scale),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'your mic',
                      style: TextStyle(
                        fontSize: titleFs,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.08,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Text(
                    'Say anything, we will make sure we hear\nyou perfectly',
                    style: TextStyle(
                      fontSize: subFs,
                      fontWeight: FontWeight.w600,
                      color: kSubtitle,
                      height: 1.5,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.025),

            // ── Card ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                        color: kCardBorder.withOpacity(0.5), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Mic circles ───────────────────────────────
                      SizedBox(
                        width: outerD,
                        height: outerD,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsing outer ring
                            AnimatedBuilder(
                              animation: _pulseCtrl,
                              builder: (_, __) {
                                final s = 1.0 + 0.08 * sin(_pulseCtrl.value * pi);
                                return Transform.scale(
                                  scale: s,
                                  child: Container(
                                    width: outerD,
                                    height: outerD,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kMicOuter.withOpacity(0.25),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Middle ring
                            Container(
                              width: middleD,
                              height: middleD,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kMicOuter.withOpacity(0.55),
                              ),
                            ),
                            // Inner mic circle
                            Container(
                              width: innerD,
                              height: innerD,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kMicInner,
                              ),
                              child: Icon(
                                Icons.mic_rounded,
                                color: kSubtitle,
                                size: micIcon,
                              ),
                            ),
                            // Yellow dot
                            Positioned(
                              top: outerD * 0.08,
                              right: outerD * 0.08,
                              child: Container(
                                width: dotSize,
                                height: dotSize,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kYellow,
                                ),
                                child: Center(
                                  child: Container(
                                    width: dotSize * 0.35,
                                    height: dotSize * 0.35,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF3A3A00),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: cardH * 0.06),

                      // ── Waveform ──────────────────────────────────
                      AnimatedBuilder(
                        animation: _waveCtrl,
                        builder: (_, __) => CustomPaint(
                          size: Size(waveW, waveH),
                          painter: _WaveformPainter(
                            progress: _waveCtrl.value,
                            color: kYellow,
                          ),
                        ),
                      ),

                      SizedBox(height: cardH * 0.06),

                      // ── Mic quality pill ──────────────────────────
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24 * scale, vertical: 12 * scale),
                        decoration: BoxDecoration(
                          color: kQualityBg,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kYellow,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Mic quality: Excellent',
                              style: TextStyle(
                                fontSize: (15 * scale).clamp(11.0, 18.0),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.02),

            // ── Bottom button ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.03),
              child: SizedBox(
                width: double.infinity,
                height: (56 * scale).clamp(44.0, 64.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    "Sounds good, let's go!  →",
                    style: TextStyle(
                      fontSize: (16 * scale).clamp(13.0, 20.0),
                      fontWeight: FontWeight.w700,
                    ),
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

// ── Waveform CustomPainter ────────────────────────────────────────────────────
class _WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;

  static const List<double> _barHeights = [
    0.35, 0.55, 0.75, 0.90, 0.65, 1.0, 0.80, 0.55,
    0.95, 0.70, 0.45, 0.85, 0.60, 0.40, 0.70, 0.50,
  ];

  _WaveformPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final count  = _barHeights.length;
    // Bar width = ~5% of total width, gap fills the rest
    final barW   = (size.width * 0.038).clamp(4.0, 10.0);
    final gap    = (size.width - count * barW) / (count - 1);
    final paint  = Paint()..color = color..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final phase     = (progress + i / count) % 1.0;
      final animFactor = 0.72 + 0.28 * sin(phase * 2 * pi);
      final barH      = _barHeights[i] * size.height * animFactor;
      final x         = i * (barW + gap);
      final y         = (size.height - barH) / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, barW, barH), const Radius.circular(4)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => old.progress != progress;
}
