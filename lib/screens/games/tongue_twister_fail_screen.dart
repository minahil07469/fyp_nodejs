import 'package:flutter/material.dart';
import 'speakquest_screen.dart';
import 'tongue_twister_screen.dart';

class TongueTwisterFailScreen extends StatelessWidget {
  const TongueTwisterFailScreen({super.key});

  static const Color kBg       = Color(0xFF290451);
  static const Color kHeaderBg = Color(0xFF2F0A56);
  static const Color kCardBg   = Color(0xFFFAF6FF);
  static const Color kPrimary  = Color(0xFF290451);
  static const Color kYellow   = Color(0xFFD9E366);
  static const Color kYellowDk = Color(0xFF1A2000);
  static const Color kSubtitle = Color(0xFF9A70B0);
  static const Color kOrange   = Color(0xFFC07030);
  static const Color kPurple   = Color(0xFF5300AC);
  static const Color kCardBdr  = Color(0xFFEDE0FF);
  static const Color kAICard   = Color(0xFF290451);

  static const _tries = [
    ('Try 1', '58%'),
    ('Try 2', '61%'),
    ('Try 3', '55%'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Dark header ──────────────────────────────────────────
            _buildHeader(),

            // ── Light card section ───────────────────────────────────
            Container(
              color: kCardBg,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ── Try cards row ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(_tries.length, (i) {
                        final t = _tries[i];
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: kCardBdr, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  t.$1,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: kSubtitle,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.$2,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: kOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Words to practise card ─────────────────────────
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
                            'Words to practise',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _WordRow(
                            word: '"lorry"',
                            correct: 'Correct: LOR-ee',
                            count: '×5 wrong',
                          ),
                          const SizedBox(height: 8),
                          _WordRow(
                            word: '"yellow"',
                            correct: 'Correct: YEL-oh',
                            count: '×3 wrong',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── AI Tip card ────────────────────────────────────
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
                            'AI TIP',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC9A0E0),
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '"Slow down by 50%. Say each word separately first, then blend."',
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

                  // ── Try again button ───────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TongueTwisterScreen()),
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

                  // ── Back to SpeakQuest ─────────────────────────────
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
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: kHeaderBg,
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 28),
      child: Column(
        children: [
          const Text(
            'Tongue Twister · Phrase 3 · Try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: kSubtitle),
          ),

          const SizedBox(height: 14),

          // Sad face icon
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                  color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
            child: const Icon(
              Icons.sentiment_dissatisfied_rounded,
              color: Color(0xFFE6BEF0),
              size: 40,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'So close!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Need 70% to pass · Level 3',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: kSubtitle),
          ),

          const SizedBox(height: 14),

          // Stars: 1 filled, 2 faded
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: kYellow, size: 28),
              Icon(Icons.star_rounded,
                  color: Colors.white.withOpacity(0.15), size: 28),
              Icon(Icons.star_rounded,
                  color: Colors.white.withOpacity(0.15), size: 28),
            ],
          ),

          const SizedBox(height: 4),

          // Big score
          const Text(
            '61%',
            style: TextStyle(
              fontSize: 62,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC9A0E0),
              height: 1.1,
            ),
          ),

          const Text(
            'Best try · Need 70% to pass',
            style: TextStyle(fontSize: 12, color: Color(0xFF7A50A0)),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Word practice row ──────────────────────────────────────────────────────────
class _WordRow extends StatelessWidget {
  final String word;
  final String correct;
  final String count;

  const _WordRow({
    required this.word,
    required this.correct,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC07030),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  correct,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9A70B0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5300AC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
