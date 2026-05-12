import 'package:flutter/material.dart';

class CoachDetailScreen extends StatelessWidget {
  const CoachDetailScreen({super.key});

  static const Color kBg       = Color(0xFFFFFFFF);
  static const Color kHeader   = Color(0xFF1C0E4E);
  static const Color kPrimary  = Color(0xFF5B2DD9);
  static const Color kYellow   = Color(0xFFC8F55A);
  static const Color kYellowDk = Color(0xFF1C0E4E);
  static const Color kSubtitle = Color(0xFF9B8EC4);
  static const Color kOrange   = Color(0xFFE8860A);
  static const Color kRed      = Color(0xFFCC3333);
  static const Color kGreen    = Color(0xFF3BAA6A);
  static const Color kBarBg    = Color(0xFFEDE8FF);
  static const Color kDivider  = Color(0xFFF4F0FF);
  static const Color kTagBg    = Color(0xFFFFE8E8);
  static const Color kInsight  = Color(0xFFF4F0FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────
            _buildTopBar(),

            // ── Session meta ─────────────────────────────────────────
            _buildMeta(),

            // ── AI Coach label ───────────────────────────────────────
            _buildSectionHeader(
              color: kPrimary,
              badge: 'AI\nCOACH',
              title: 'AI Coach',
              subtitle: 'Skill analysis',
            ),

            // ── Pronunciation ────────────────────────────────────────
            _buildSkillBlock(
              title: 'Pronunciation',
              score: '80%',
              scoreColor: kPrimary,
              fill: 0.80,
              barColor: kPrimary,
              subLabel: '3 WORDS MISPRONOUNCED',
              child: _buildMispronounced(),
            ),

            // ── Fluency ──────────────────────────────────────────────
            _buildSkillBlock(
              title: 'Fluency',
              score: '68%',
              scoreColor: kOrange,
              fill: 0.68,
              barColor: kOrange,
              subLabel: 'WHAT BROKE YOUR FLUENCY',
              child: _buildFluency(),
            ),

            // ── Pacing ───────────────────────────────────────────────
            _buildSkillBlock(
              title: 'Pacing',
              score: 'Fast',
              scoreColor: kOrange,
              fill: null,
              barColor: kOrange,
              subLabel: 'SPEED ACROSS YOUR SESSION',
              child: _buildPacing(),
            ),

            // ── Filler words ─────────────────────────────────────────
            _buildSkillBlock(
              title: 'Filler words',
              score: '9 words',
              scoreColor: kRed,
              fill: 0.45,
              barColor: kRed,
              subLabel: 'WORDS DETECTED',
              child: _buildFillerWords(),
            ),

            // ── Clarity ──────────────────────────────────────────────
            _buildSkillBlock(
              title: 'Clarity',
              score: '75%',
              scoreColor: kPrimary,
              fill: 0.75,
              barColor: kPrimary,
              subLabel: 'WHAT AFFECTED CLARITY',
              child: _buildClarity(),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Builder(
      builder: (context) => Container(
        color: kHeader,
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Coach Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Score + greeting row
            Row(
              children: [
                // Score ring
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF3D2A7A), width: 5),
                        ),
                      ),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kYellow, width: 3),
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('74',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.0)),
                          Text('/100',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFFB9A8E8))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Great session,',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2)),
                      const Text('Alex!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: kYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('+6 from last time',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: kYellowDk)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Session meta row ───────────────────────────────────────────────────────
  Widget _buildMeta() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: const [
              Text('⏳ 4 min 12 sec',
                  style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
              SizedBox(width: 16),
              Text('△ Free practice',
                  style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
              SizedBox(width: 16),
              Text('🤖 Both AIs active',
                  style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
            ],
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: const Color(0xFFEDE8FF)),
        ],
      ),
    );
  }

  // ── Section header (AI Coach / AI Therapist) ───────────────────────────────
  Widget _buildSectionHeader({
    required Color color,
    required String badge,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: const Color(0xFFF7F4FF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                badge,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kHeader)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: kSubtitle)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Skill block wrapper ────────────────────────────────────────────────────
  Widget _buildSkillBlock({
    required String title,
    required String score,
    required Color scoreColor,
    required double? fill,
    required Color barColor,
    required String subLabel,
    required Widget child,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kHeader)),
                Text(score,
                    style: TextStyle(
                        fontSize: fill != null ? 15 : 13,
                        fontWeight: FontWeight.w700,
                        color: scoreColor)),
              ],
            ),
          ),
          if (fill != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(subLabel,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFAAAAAA),
                    letterSpacing: 0.5)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: child,
          ),
          Container(height: 1, color: kBarBg),
        ],
      ),
    );
  }

  // ── Mispronounced words ────────────────────────────────────────────────────
  Widget _buildMispronounced() {
    final words = [
      ('"Anxiety"', '... ang-ZY-uh-tee', 'x3 times'),
      ('"Colleague"', '... KOL-eeg', 'x1 time'),
      ('"Subtle"', '... SUT-ul', 'x1 time'),
    ];
    return Column(
      children: words.map((w) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(w.$1,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kPrimary)),
                  Text(w.$2,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF999999))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kTagBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(w.$3,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: kRed)),
            ),
          ],
        ),
      )).toList(),
    );
  }

  // ── Fluency breakdown ──────────────────────────────────────────────────────
  Widget _buildFluency() {
    final rows = [
      ('Long pauses', '8 detected', kRed),
      ('Filler words', '9 words', kRed),
      ('Speed rushes', '3 moments', kRed),
      ('Smoothest moment', '2:00 - 3:00 ✓', kGreen),
    ];
    return Column(
      children: rows.map((r) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.$1,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF444444))),
                Text(r.$2,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: r.$3)),
              ],
            ),
          ),
          Container(height: 1, color: kDivider),
        ],
      )).toList(),
    );
  }

  // ── Pacing timeline ────────────────────────────────────────────────────────
  Widget _buildPacing() {
    final rows = [
      ('0:00', 0.78, kRed, 'Fast'),
      ('1:00', 0.78, kRed, 'Fast'),
      ('2:00', 0.50, kGreen, 'Good'),
      ('3:00', 0.50, kGreen, 'Good'),
      ('4:00', 0.78, kRed, 'Fast'),
    ];
    return Column(
      children: rows.map((r) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(r.$1,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF666666))),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: r.$2,
                  minHeight: 10,
                  backgroundColor: kBarBg,
                  valueColor: AlwaysStoppedAnimation<Color>(r.$3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(r.$4,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: r.$3)),
          ],
        ),
      )).toList(),
    );
  }

  // ── Filler word chips ──────────────────────────────────────────────────────
  Widget _buildFillerWords() {
    final chips = [
      ('"um"', '09', kRed),
      ('"uh"', '05', kOrange),
      ('"like"', '05', kOrange),
      ('"you know"', '01', kPrimary),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((c) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: kHeader,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(c.$1,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white)),
              ),
              const SizedBox(width: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: c.$3,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(c.$2,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          )).toList(),
        ),
        const SizedBox(height: 10),
        const Text(
          '💡 Next time - pause silently instead of saying "um"',
          style: TextStyle(fontSize: 11, color: Color(0xFF888888)),
        ),
      ],
    );
  }

  // ── Clarity breakdown ──────────────────────────────────────────────────────
  Widget _buildClarity() {
    final rows = [
      ('Volume drop moments', '4 times', kRed),
      ('Mumbled words', '2 detected', kRed),
      ('Clearest moment', '2:00 - 4:00 ✓', kGreen),
    ];
    return Column(
      children: rows.map((r) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.$1,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF444444))),
                Text(r.$2,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: r.$3)),
              ],
            ),
          ),
          Container(height: 1, color: kDivider),
        ],
      )).toList(),
    );
  }
}
