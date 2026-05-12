import 'package:flutter/material.dart';
import 'speakquest_screen.dart';
import 'tongue_twister_screen.dart';

class TongueTwisterResultScreen extends StatelessWidget {
  const TongueTwisterResultScreen({super.key});

  static const Color kBg       = Color(0xFF290451);
  static const Color kCardBg   = Color(0xFFFAF6FF);
  static const Color kPrimary  = Color(0xFF290451);
  static const Color kPurple   = Color(0xFF5300AC);
  static const Color kYellow   = Color(0xFFD9E366);
  static const Color kYellowDk = Color(0xFF1A2000);
  static const Color kSubtitle = Color(0xFF9A70B0);
  static const Color kGreen    = Color(0xFF2D7A40);
  static const Color kOrange   = Color(0xFFC07030);
  static const Color kCardBdr  = Color(0xFFEDE0FF);

  // Try results: (label, score, isBest)
  static const _tries = [
    ('Try 1', '91%', false),
    ('Try 2', '94%', true),
    ('Try 3', '88%', false),
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
              width: double.infinity,
              decoration: const BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ── Try cards row ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(_tries.length, (i) {
                        final t = _tries[i];
                        final isBest = t.$3;
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                right: i < 2 ? 10 : 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            decoration: BoxDecoration(
                              color: isBest ? kYellow : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: isBest
                                  ? null
                                  : Border.all(
                                      color: kCardBdr, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  t.$1,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isBest
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isBest
                                        ? const Color(0xFF3A4800)
                                        : kSubtitle,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.$2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: isBest
                                        ? kYellowDk
                                        : kPurple,
                                  ),
                                ),
                                if (isBest) ...[
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Best',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF3A4800),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Words nailed card ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: kCardBdr, width: 1.5),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                          16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Words nailed row
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Words nailed',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimary,
                                ),
                              ),
                              Text(
                                '12 / 14',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Green progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: const LinearProgressIndicator(
                              value: 12 / 14,
                              minHeight: 8,
                              backgroundColor: Color(0xFFF0E8FF),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  kGreen),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Divider(
                              color: const Color(0xFFF0E8FF),
                              thickness: 1),

                          const SizedBox(height: 8),

                          // Mispronounced label
                          const Text(
                            'Mispronounced',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kSubtitle,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Mispronounced chips
                          Row(
                            children: [
                              _MisChip(
                                  word: '"lorry"',
                                  hint: '→ LOR-ee ×2'),
                              const SizedBox(width: 10),
                              _MisChip(
                                  word: '"yellow"',
                                  hint: '→ YEL-oh ×1'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── XP + Unlocked card ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                  '+120 XP',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: kYellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Unlocked',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFC9A0E0),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3A0870),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                      color: kYellow.withOpacity(0.3),
                                      width: 1),
                                ),
                                child: const Text(
                                  'Level 4',
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

                  // ── Buttons ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const TongueTwisterScreen()),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFF0E8FF),
                                foregroundColor: kPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Try level 2',
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
                              onPressed: () =>
                                  Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const SpeakQuestScreen()),
                                (_) => false,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
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
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: kBg,
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 28),
      child: Column(
        children: [
          // Subtitle
          const Text(
            'Tongue Twister · Phrase 3 · Intermediate',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: kSubtitle),
          ),

          const SizedBox(height: 14),

          // Trophy icon
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3A0870),
              border: Border.all(
                  color: kYellow.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: kYellow,
              size: 38,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Level cleared!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Tongue Twister · Level 3 · Intermediate',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: kSubtitle),
          ),

          const SizedBox(height: 14),

          // 3 stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.star_rounded,
                    color: kYellow, size: 28),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Big score
          const Text(
            '94%',
            style: TextStyle(
              fontSize: 62,
              fontWeight: FontWeight.w700,
              color: kYellow,
              height: 1.1,
            ),
          ),

          const Text(
            'Best accuracy · Try 2',
            style: TextStyle(fontSize: 12, color: kSubtitle),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Mispronounced chip ─────────────────────────────────────────────────────────
class _MisChip extends StatelessWidget {
  final String word;
  final String hint;
  const _MisChip({required this.word, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              word,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFC07030),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              hint,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9A70B0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
