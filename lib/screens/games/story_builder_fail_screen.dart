import 'package:flutter/material.dart';
import 'speakquest_screen.dart';
import 'story_builder_screen.dart';

class StoryBuilderFailScreen extends StatelessWidget {
  const StoryBuilderFailScreen({super.key});

  static const Color kBg       = Color(0xFFFAF6FF);
  static const Color kHeader   = Color(0xFF290451);
  static const Color kPrimary  = Color(0xFF290451);
  static const Color kYellow   = Color(0xFFD9E366);
  static const Color kYellowDk = Color(0xFF1A2000);
  static const Color kSubtitle = Color(0xFF9A70B0);
  static const Color kOrange   = Color(0xFFC07030);
  static const Color kRed      = Color(0xFFD05050);
  static const Color kCardBdr  = Color(0xFFEDE0FF);
  static const Color kAICard   = Color(0xFF290451);
  static const Color kLavender = Color(0xFFC9A0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Dark header ──────────────────────────────────────────
            _buildHeader(),

            const SizedBox(height: 16),

            // ── Story so far card ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kCardBdr, width: 1.5),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STORY SO FAR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kSubtitle,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: kPrimary,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '"It was a stormy night when the lighthouse flickered. A sailor...um...rowed...uh... ',
                          ),
                          TextSpan(
                            text: 'toward the shore."',
                            style: TextStyle(color: kOrange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '12 filler words broke the flow',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: kOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Where fluency dropped card ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kCardBdr, width: 1.5),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Where fluency dropped',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FluencyRow(
                        label: 'Sentence 4',
                        fill: 0.48,
                        percent: '48%',
                        color: kOrange),
                    const SizedBox(height: 8),
                    _FluencyRow(
                        label: 'Sentence 5',
                        fill: 0.42,
                        percent: '42%',
                        color: kRed),
                    const SizedBox(height: 8),
                    _FluencyRow(
                        label: 'Sentence 6',
                        fill: 0.30,
                        percent: '30%',
                        color: kRed),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── AI Says card ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                decoration: BoxDecoration(
                  color: kAICard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AI SAYS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC9A0E0),
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '"You lost rhythm at sentence 4. Keep sentences short — one clear idea per turn."',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Try again button ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StoryBuilderScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kYellow,
                    foregroundColor: kYellowDk,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Try again →',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Back to SpeakQuest ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SpeakQuestScreen()),
                    (_) => false,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kSubtitle,
                    side: const BorderSide(
                        color: Color(0xFFE0D0F0), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to SpeakQuest',
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
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kHeader,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 28),
      child: Column(
        children: [
          // Bookmark / story icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                  color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFFE6BEF0),
              size: 36,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Story unfinished',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            '6 of 10 sentences · Fluency broke',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF9A70B0)),
          ),

          const SizedBox(height: 16),

          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '52%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC9A0E0),
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall',
                      style: TextStyle(
                          fontSize: 10, color: Color(0xFF7A50A0)),
                    ),
                    Text(
                      'Needs work',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC07030),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fluency row ────────────────────────────────────────────────────────────────
class _FluencyRow extends StatelessWidget {
  final String label;
  final double fill;
  final String percent;
  final Color color;

  const _FluencyRow({
    required this.label,
    required this.fill,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9A70B0),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 7,
              backgroundColor: const Color(0xFFF0E8FF),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          percent,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
