import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'story_builder_fail_screen.dart';
import '../../core/app_nav.dart';
import 'story_builder_result_screen.dart';

class StoryBuilderScreen extends StatefulWidget {
  const StoryBuilderScreen({super.key});

  @override
  State<StoryBuilderScreen> createState() => _StoryBuilderScreenState();
}

class _StoryBuilderScreenState extends State<StoryBuilderScreen>
    with TickerProviderStateMixin {
  int _turn       = 3;
  final int _total = 10;
  int _timerSecs  = 15;
  bool _recording = false;
  int _navIndex   = 1;
  Timer? _countdown;

  late AnimationController _waveCtrl;
  late AnimationController _pulseCtrl;

  // ── Colours ────────────────────────────────────────────────────────────────
  static const Color kBg        = Color(0xFF150028);
  static const Color kHeaderBg  = Color(0xFF1E0040);
  static const Color kPrimary   = Color(0xFF5300AC);
  static const Color kYellow    = Color(0xFFD9E366);
  static const Color kYellowDk  = Color(0xFF290451);
  static const Color kSubtitle  = Color(0xFF7A50A0);
  static const Color kAIBubble  = Color(0xFF1E0040);
  static const Color kYouBubble = Color(0xFF5300AC);
  static const Color kPromptBg  = Color(0x1AD9E366); // rgba(217,227,102,0.1)
  static const Color kStatCard  = Color(0xFF150028);
  static const Color kNavActive = Color(0xFFD9E366);
  static const Color kNavInact  = Color(0xFF5A3A70);
  static const Color kGreen     = Color(0xFF90D070);

  // Story messages: (isAI, text)
  final List<(bool, String)> _messages = [
    (true,  '"It was a stormy night when the lighthouse flickered..."'),
    (false, '"A sailor spotted it and rowed toward the shore."'),
    (true,  '"Inside stood a mysterious woman with a lantern..."'),
  ];

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _pulseCtrl.dispose();
    _countdown?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() => _recording = !_recording);
    if (_recording) {
      _waveCtrl.repeat(reverse: true);
      _timerSecs = 15;
      _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_timerSecs > 0) {
          setState(() => _timerSecs--);
        } else {
          t.cancel();
          _stopRecording();
        }
      });
    } else {
      _stopRecording();
    }
  }

  void _stopRecording() {
    _countdown?.cancel();
    _waveCtrl.stop();
    setState(() {
      _recording = false;
      _timerSecs = 15;
    });
  }

  void _increaseTurn() {
    if (_turn < _total) {
      setState(() => _turn++);
    }
    if (_turn >= _total) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const StoryBuilderResultScreen()),
      );
    }
  }

  void _giveUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => const StoryBuilderFailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _turn / _total;

    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────
            _buildHeader(progress),

            // ── Chat + controls ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    // Chat bubbles
                    ..._messages.map((m) => _ChatBubble(
                          isAI: m.$1,
                          text: m.$2,
                        )),

                    const SizedBox(height: 12),

                    // "Your turn" prompt bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: kPromptBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: kYellow.withOpacity(0.25), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: kYellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Your turn — continue the story...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kYellow,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Mic button
                    GestureDetector(
                      onTap: _toggleRecording,
                      child: AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (_, __) {
                          final scale = _recording
                              ? 1.0 + 0.06 * sin(_pulseCtrl.value * pi)
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer ring
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimary.withOpacity(0.15),
                                    border: Border.all(
                                      color: kYellow.withOpacity(0.15),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                // Inner button
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: const BoxDecoration(
                                    color: kPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _recording
                                        ? Icons.pause_rounded
                                        : Icons.mic_rounded,
                                    color: const Color(0xFFE6BEF0),
                                    size: 28,
                                  ),
                                ),
                                // Red dot
                                if (_recording)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD05050),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Last sentence stats
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFE6BEF0).withOpacity(0.08),
                            width: 1),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LAST SENTENCE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kSubtitle,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _StatBox(
                                value: '82%',
                                label: 'Fluency',
                                valueColor: const Color(0xFFE6BEF0),
                                bgColor: kPrimary.withOpacity(0.25),
                              ),
                              const SizedBox(width: 10),
                              _StatBox(
                                value: 'Good',
                                label: 'Pacing',
                                valueColor: kGreen,
                                bgColor: const Color(0xFF5A9040).withOpacity(0.2),
                              ),
                              const SizedBox(width: 10),
                              _StatBox(
                                value: '0',
                                label: 'Fillers',
                                valueColor: kGreen,
                                bgColor: const Color(0xFF5A9040).withOpacity(0.2),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Buttons row
                    Row(
                      children: [
                        // Give up button
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: _giveUp,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF9A70B0),
                                side: const BorderSide(
                                    color: Color(0xFF3A1260), width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Give up',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Increase turn button
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _increaseTurn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kYellow,
                                foregroundColor: kYellowDk,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Increase turn',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(double progress) {
    return Container(
      color: kHeaderBg,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Game 3 · Story Builder',
                      style: TextStyle(fontSize: 12, color: kSubtitle),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Your turn',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Timer badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: kYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: kYellow.withOpacity(0.25), width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      _recording
                          ? _timerSecs.toString().padLeft(2, '0')
                          : '15',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kYellow,
                        height: 1.0,
                      ),
                    ),
                    const Text(
                      'sec',
                      style: TextStyle(fontSize: 10, color: kSubtitle),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Turn $_turn',
                style: const TextStyle(fontSize: 10, color: kSubtitle),
              ),
              Text(
                'of $_total',
                style: const TextStyle(fontSize: 10, color: kSubtitle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(kYellow),
            ),
          ),
          const SizedBox(height: 14),
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
        color: kBg,
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

// ── Chat bubble ────────────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final bool isAI;
  final String text;

  static const Color kAIBubble  = Color(0xFF1E0040);
  static const Color kYouBubble = Color(0xFF5300AC);
  static const Color kSubtitle  = Color(0xFF9A70B0);
  static const Color kYellow    = Color(0xFFD9E366);

  const _ChatBubble({required this.isAI, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAI) ...[
            // AI avatar
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF5300AC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Color(0xFFE6BEF0), size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  isAI ? 'AI' : 'You',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isAI ? kSubtitle : kYellow,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isAI ? kAIBubble : kYouBubble,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isAI ? 4 : 14),
                      topRight: Radius.circular(isAI ? 14 : 4),
                      bottomLeft: const Radius.circular(14),
                      bottomRight: const Radius.circular(14),
                    ),
                    border: Border.all(
                      color: const Color(0xFFE6BEF0).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
                      color: isAI
                          ? const Color(0xFFE6BEF0)
                          : Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isAI) ...[
            const SizedBox(width: 8),
            // User avatar
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFE6BEF0).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  color: Color(0xFFE6BEF0), size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Stat box ───────────────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bgColor;

  const _StatBox({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bgColor,
  });

  static const Color kSubtitle = Color(0xFF7A50A0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: kSubtitle),
            ),
          ],
        ),
      ),
    );
  }
}
