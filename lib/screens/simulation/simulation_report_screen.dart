import 'dart:math';
import 'package:flutter/material.dart';
import 'simulation_screen.dart';
import '../home/home_screen.dart';
import 'simulation_screen.dart';
import '../details/coach_detail_screen.dart';
import '../details/therapist_detail_screen.dart';

class SimulationReportScreen extends StatefulWidget {
  final String roleName;
  final int selectedAI; // 0=Coach,1=Therapist,2=Both
  const SimulationReportScreen({
    super.key,
    this.roleName   = 'Senior Web Developer',
    this.selectedAI = 2,
  });

  @override
  State<SimulationReportScreen> createState() =>
      _SimulationReportScreenState();
}

class _SimulationReportScreenState
    extends State<SimulationReportScreen> {
  bool _coachExpanded     = true;
  bool _therapistExpanded = true;

  static const Color kBg       = Color(0xFFFFFEF6);
  static const Color kHeader   = Color(0xFF2F0A56);
  static const Color kPrimary  = Color(0xFF5300AC);
  static const Color kYellow   = Color(0xFFD9E366);
  static const Color kSubtitle = Color(0xFFC097D8);
  static const Color kCardBg   = Color(0x33E6BEF0);
  static const Color kCardBdr  = Color(0x66F0D4FF);
  static const Color kOrange   = Color(0xFFFFA060);
  static const Color kBarBg    = Color(0xFFEFDAFF);
  static const Color kBarPurple= Color(0xFF5300AC);
  static const Color kNavBg    = Color(0xFFE6C6F7);
  static const Color kGreen    = Color(0xFF2D7A40);
  static const Color kBtnYellow= Color(0xFFD9E366);
  static const Color kBtnYellowDk = Color(0xFF2A3D00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            _buildHeader(),

            const SizedBox(height: 16),

            // ── Coach card ───────────────────────────────────────────
            if (widget.selectedAI == 0 || widget.selectedAI == 2)
              _buildExpandableCard(
                title: 'Coach',
                expanded: _coachExpanded,
                onToggle: () =>
                    setState(() => _coachExpanded = !_coachExpanded),
                onDetailTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const CoachDetailScreen())),
                child: _buildCoachContent(),
              ),

            if (widget.selectedAI == 0 || widget.selectedAI == 2)
              const SizedBox(height: 12),

            // ── Therapist card ───────────────────────────────────────
            if (widget.selectedAI == 1 || widget.selectedAI == 2)
              _buildExpandableCard(
                title: 'Therapist',
                expanded: _therapistExpanded,
                onToggle: () => setState(
                    () => _therapistExpanded = !_therapistExpanded),
                onDetailTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const TherapistDetailScreen())),
                child: _buildTherapistContent(),
              ),

            if (widget.selectedAI == 1 || widget.selectedAI == 2)
              const SizedBox(height: 16),

            // ── Key Moments ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KEY MOMENTS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Best moment
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('⭐',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Best moment · 2:14',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Explained WebSocket vs polling clearly — structured, confident and concise.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFD4B8FF),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Struggled moment
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('⚠️',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Struggled at · 3:40',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Speed spiked when asked about database indexing — 9 filler words in 20 seconds.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFD4B8FF),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── AI says ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI says',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: kHeader,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6BEF0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BulletPoint(
                            'Practice answering under 45 seconds per question'),
                        SizedBox(height: 6),
                        _BulletPoint(
                            'Drill database and system design scenarios next'),
                        SizedBox(height: 6),
                        _BulletPoint(
                            'Run the Hard Mode CTO simulation when ready'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Retry / Save buttons ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Keep HomeScreen as base, push SimulationScreen on top
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                            (_) => false,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SimulationScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBtnYellow,
                          foregroundColor: kBtnYellowDk,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Retry Simulation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          // Keep HomeScreen as base, push SimulationScreen on top
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                            (_) => false,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SimulationScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kHeader,
                          side: const BorderSide(
                              color: kHeader, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Save Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: kHeader,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Session complete',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: kSubtitle)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Score ring
              SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(
                  painter: _ScoreRingPainter(score: 74),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('74',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.0)),
                        Text('/100',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: kSubtitle)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your report',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.4)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: kYellow,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Text('+6 vs last session',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4C5414))),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Duration: 4m 52s · 8 questions\nRole: ${widget.roleName}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Expandable card ────────────────────────────────────────────────────────
  Widget _buildExpandableCard({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
    VoidCallback? onDetailTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kCardBdr, width: 1),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onToggle,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6C6F7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: kPrimary)),
                    ),
                    const Spacer(),
                    if (onDetailTap != null)
                      GestureDetector(
                        onTap: onDetailTap,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: kNavBg, shape: BoxShape.circle),
                          child: const Icon(
                              Icons.chevron_right_rounded,
                              color: kHeader,
                              size: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: child,
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachContent() {
    return Column(children: [
      _BarMetric(label: 'Pronounciation', value: '80%', fill: 0.81, color: kBarPurple),
      const SizedBox(height: 10),
      _BarMetric(label: 'Fluency',        value: '68%', fill: 0.66, color: kBarPurple),
      const SizedBox(height: 10),
      _BarMetric(label: 'Pacing',         value: '80%', fill: 0.80, color: kBarPurple),
      const SizedBox(height: 10),
      _BarMetric(label: 'Filler words',   value: '68%', fill: 0.66, color: kBarPurple),
    ]);
  }

  Widget _buildTherapistContent() {
    return Column(children: [
      _DotMetric(label: 'Anxiety',             value: 'Mild',  dotColor: kOrange),
      const SizedBox(height: 8),
      _DotMetric(label: 'Stress',              value: 'Mild',  dotColor: kOrange),
      const SizedBox(height: 8),
      _DotMetric(label: 'Fear',                value: 'No',    dotColor: const Color(0xFF61EF8E)),
      const SizedBox(height: 8),
      _DotMetric(label: 'Confidence',          value: 'High',  dotColor: const Color(0xFFCC3333)),
      const SizedBox(height: 8),
      _DotMetric(label: 'Sadness',             value: 'Fast',  dotColor: kOrange),
      const SizedBox(height: 8),
      _DotMetric(label: 'Emotional Stability', value: 'Low',   dotColor: kOrange),
    ]);
  }
}

// ── Score ring ─────────────────────────────────────────────────────────────────
class _ScoreRingPainter extends CustomPainter {
  final int score;
  const _ScoreRingPainter({required this.score});
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2, r = size.width / 2 - 6;
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()..color = const Color(0xFF543C6E)..style = PaintingStyle.stroke..strokeWidth = 10);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -pi / 2, 2 * pi * score / 100, false,
        Paint()..color = const Color(0xFFD9E366)..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(_ScoreRingPainter old) => old.score != score;
}

// ── Bar metric ─────────────────────────────────────────────────────────────────
class _BarMetric extends StatelessWidget {
  final String label, value;
  final double fill;
  final Color color;
  const _BarMetric({required this.label, required this.value, required this.fill, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFC097D8))),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2F0A56))),
      ]),
      const SizedBox(height: 4),
      ClipRRect(borderRadius: BorderRadius.circular(60),
        child: LinearProgressIndicator(value: fill, minHeight: 9,
          backgroundColor: const Color(0xFFEFDAFF),
          valueColor: AlwaysStoppedAnimation<Color>(color))),
    ]);
  }
}

// ── Dot metric ─────────────────────────────────────────────────────────────────
class _DotMetric extends StatelessWidget {
  final String label, value;
  final Color dotColor;
  const _DotMetric({required this.label, required this.value, required this.dotColor});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFC097D8))),
      Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
            color: dotColor == const Color(0xFFFFA060) ? dotColor : const Color(0xFF2F0A56))),
      ]),
    ]);
  }
}

// ── Bullet point ───────────────────────────────────────────────────────────────
class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('• ', style: TextStyle(fontSize: 13, color: Color(0xFF2F0A56), fontWeight: FontWeight.w700)),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF2F0A56), height: 1.4))),
    ]);
  }
}
