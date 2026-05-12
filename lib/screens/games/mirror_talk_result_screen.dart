import 'package:flutter/material.dart';
import 'mirror_talk_screen.dart';

class MirrorTalkResultScreen extends StatelessWidget {
  const MirrorTalkResultScreen({super.key});

  static const Color kBg       = Color(0xFFFAF6FF);
  static const Color kHeader   = Color(0xFF290451);
  static const Color kPrimary  = Color(0xFF5300AC);
  static const Color kYellow   = Color(0xFFD9E366);
  static const Color kYellowDk = Color(0xFF1A2000);
  static const Color kSubtitle = Color(0xFF9A70B0);
  static const Color kCardBg   = Color(0xFFFFFFFF);
  static const Color kGreen    = Color(0xFF2D7A40);
  static const Color kOrange   = Color(0xFFC07030);
  static const Color kBarBg    = Color(0xFFF0E8FF);
  static const Color kXPCard   = Color(0xFF290451);

  // Round data
  static const _rounds = [
    ('Excited',   0.88, '88%', Color(0xFF5300AC), 3),
    ('Calm',      0.72, '72%', Color(0xFF5300AC), 2),
    ('Confident', 0.91, '91%', Color(0xFF2D7A40), 3),
    ('Nervous',   0.60, '60%', Color(0xFFC07030), 2),
    ('Happy',     0.82, '82%', Color(0xFF5300AC), 3),
  ];

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

            // ── Round breakdown card ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEDE0FF), width: 1.5),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ROUND BREAKDOWN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kSubtitle,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(_rounds.length, (i) {
                      final r = _rounds[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RoundRow(
                          number: i + 1,
                          emotion: r.$1,
                          fill: r.$2,
                          percent: r.$3,
                          barColor: r.$4,
                          stars: r.$5,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Best / Needs work row ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FFF4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Best emotion',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kSubtitle,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Confident',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Needs work',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kSubtitle,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Nervous',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── XP + Badge card ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: kXPCard,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // XP
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'XP earned',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFC9A0E0),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '+150 XP',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: kYellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Badge unlocked',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFC9A0E0),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A0870),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: kYellow.withOpacity(0.3), width: 1),
                          ),
                          child: const Text(
                            'Emotion Master',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kYellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Play again / Next game buttons ───────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MirrorTalkScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0E8FF),
                          foregroundColor: kHeader,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Play again',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kHeader,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Next game →',
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
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: Column(
        children: [
          // Trophy icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3A0870),
              border: Border.all(
                  color: kYellow.withOpacity(0.35), width: 1.5),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: kYellow,
              size: 40,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'You nailed it!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Mirror Talk · All 5 rounds complete',
            style: TextStyle(
              fontSize: 12,
              color: kSubtitle,
            ),
          ),

          const SizedBox(height: 16),

          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF3A0870),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: kYellow.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              children: const [
                Text(
                  '76%',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: kYellow,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Overall expression score',
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
    );
  }
}

// ── Round row ──────────────────────────────────────────────────────────────────
class _RoundRow extends StatelessWidget {
  final int number;
  final String emotion;
  final double fill;
  final String percent;
  final Color barColor;
  final int stars;

  const _RoundRow({
    required this.number,
    required this.emotion,
    required this.fill,
    required this.percent,
    required this.barColor,
    required this.stars,
  });

  static const Color kPrimary = Color(0xFF5300AC);
  static const Color kBarBg   = Color(0xFFF0E8FF);
  static const Color kYellow  = Color(0xFFD9E366);
  static const Color kStarOff = Color(0xFFEDE0F8);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Number badge
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: kBarBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: kPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Emotion label
        SizedBox(
          width: 68,
          child: Text(
            emotion,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF290451),
            ),
          ),
        ),
        // Progress bar
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 7,
              backgroundColor: kBarBg,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Percent
        SizedBox(
          width: 34,
          child: Text(
            percent,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: barColor,
            ),
          ),
        ),
        // Stars
        Row(
          children: List.generate(3, (i) => Icon(
            Icons.star_rounded,
            size: 12,
            color: i < stars ? kYellow : kStarOff,
          )),
        ),
      ],
    );
  }
}
