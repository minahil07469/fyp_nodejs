import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:share_plus/share_plus.dart';
import 'story_builder_screen.dart';

class StoryBuilderResultScreen extends StatelessWidget {
  const StoryBuilderResultScreen({super.key});

  static const Color kBg       = Color(0xFFFAF6FF);
  static const Color kHeader   = Color(0xFF290451);
  static const Color kPrimary  = Color(0xFF290451);
  static const Color kPurple   = Color(0xFF5300AC);
  static const Color kYellow   = Color(0xFFD9E366);
  static const Color kYellowDk = Color(0xFF290451);
  static const Color kSubtitle = Color(0xFF9A70B0);
  static const Color kGreen    = Color(0xFF2D7A40);
  static const Color kOrange   = Color(0xFFC07030);
  static const Color kCardBdr  = Color(0xFFEDE0FF);
  static const Color kAICard   = Color(0xFF290451);
  static const Color kXPCard   = Color(0xFF290451);

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

            // ── Your story card ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kCardBdr, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'YOUR STORY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kSubtitle,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '"It was a stormy night when the lighthouse flickered. '
                      'A sailor rowed to shore. Inside stood a woman who smiled '
                      'and whispered — the sea always remembers."',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: kPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Stats row ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatCard(
                    label: 'Best sentence',
                    value: '96%',
                    sub: 'Sentence 6',
                    valueColor: kGreen,
                    subColor: kGreen,
                    bgColor: const Color(0xFFF0FFF4),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Weakest',
                    value: '68%',
                    sub: 'Sentence 2',
                    valueColor: kOrange,
                    subColor: kOrange,
                    bgColor: const Color(0xFFFFF8F0),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Filler words',
                    value: '3',
                    sub: 'Total',
                    valueColor: kPurple,
                    subColor: kPurple,
                    bgColor: const Color(0xFFF0E8FF),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── AI Insight card ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: kAICard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AI INSIGHT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC9A0E0),
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '"Great rhythm from sentence 3 onwards. Keep it up!"',
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

            const SizedBox(height: 12),

            // ── XP + Badge card ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: kXPCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            '+200 XP',
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
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: kPurple,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: kYellow.withOpacity(0.3), width: 1),
                          ),
                          child: const Text(
                            'Storyteller',
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

            // ── Buttons ──────────────────────────────────────────────
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
                              builder: (_) =>
                                  const StoryBuilderScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0E8FF),
                          foregroundColor: kPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'New story',
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
                        onPressed: () async {
                          const storyText =
                              '"It was a stormy night when the lighthouse flickered. '
                              'A sailor rowed to shore. Inside stood a woman who smiled '
                              'and whispered — the sea always remembers."';
                          const shareText =
                              'My story from Speakora 🎙️\n\n$storyText';

                          // Windows desktop — share_plus not supported, copy to clipboard
                          final isDesktop = !kIsWeb &&
                              (defaultTargetPlatform == TargetPlatform.windows ||
                               defaultTargetPlatform == TargetPlatform.linux ||
                               defaultTargetPlatform == TargetPlatform.macOS);

                          if (isDesktop) {
                            await Clipboard.setData(
                                const ClipboardData(text: shareText));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Story copied to clipboard!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            Share.share(shareText,
                                subject: 'My Speakora Story');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kYellow,
                          foregroundColor: kYellowDk,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Share story',
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
      decoration: const BoxDecoration(
        color: kHeader,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
      child: Column(
        children: [
          // Book icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3A0870),
              border: Border.all(
                  color: kYellow.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: kYellow,
              size: 36,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Story complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            '10 sentences · 3 min 24 sec',
            style: TextStyle(fontSize: 12, color: kSubtitle),
          ),

          const SizedBox(height: 16),

          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: kYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: kYellow.withOpacity(0.25), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '84%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: kYellow,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Overall',
                      style: TextStyle(
                        fontSize: 10,
                        color: kSubtitle,
                      ),
                    ),
                    Text(
                      'Excellent',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kYellow,
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

// ── Stat card ──────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color valueColor;
  final Color subColor;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.valueColor,
    required this.subColor,
    required this.bgColor,
  });

  static const Color kSubtitle = Color(0xFF9A70B0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: kSubtitle,
              ),
            ),
            const SizedBox(height: 4),
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
              sub,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: subColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
