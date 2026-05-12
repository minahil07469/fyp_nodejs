import 'package:flutter/material.dart';
import 'simulation_ai_role_screen.dart';
import 'simulation_custom_role_screen.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  int _selectedIndex = 0; // selected scenario index

  static const Color kBg       = Color(0xFF1C0E4E);
  static const Color kCard     = Color(0xFF3D2490);
  static const Color kIconBg   = Color(0xFF2D1B69);
  static const Color kYellow   = Color(0xFFC8F55A);
  static const Color kYellowDk = Color(0xFF1C0E4E);
  static const Color kSubtitle = Color(0xFFB9A8E8);
  static const Color kBtnBg    = Color(0xFFD9E366);
  static const Color kAddBg    = Color(0xFFE6BEF0);
  static const Color kRed      = Color(0xFFFF6B6B);

  static const _freelancerScenarios = [
    (
      '📞',
      'Client Discovery Call',
      'Pitch yourself, handle objections\nand close the deal confidently',
      'Most Popular',
      Color(0xFFD9E366),
      Color(0xFF1C0E4E),
    ),
    (
      '💰',
      'Rate Negotiation',
      'Ask for more without sounding\nawkward or losing the client',
      '',
      Colors.transparent,
      Colors.transparent,
    ),
    (
      '📝',
      'Project Scope Pushback',
      'Say no to scope creep firmly\nwhile keeping the relationship',
      '',
      Colors.transparent,
      Colors.transparent,
    ),
  ];

  static const _studentScenarios = [
    (
      '🏫',
      'Professor Office Hours',
      'Ask for grade review or extension\nwithout anxiety or over-explaining',
      '',
      Colors.transparent,
      Colors.transparent,
    ),
    (
      '👔',
      'Internship Interview',
      'Practice STAR answers, handle\ntough questions from a recruiter',
      'High Stakes',
      Color(0xFFFF6B6B),
      Colors.white,
    ),
    (
      '🏆',
      'Class Presentation',
      'Practice in front of a tough audience,\nget real-time feedback on delivery',
      '',
      Colors.transparent,
      Colors.transparent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ─────────────────────────────────────
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
                            child: const Icon(Icons.chevron_left_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Run Simulation',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Pick a real-world scenario to practice in',
                                style: TextStyle(
                                    fontSize: 13, color: kSubtitle),
                              ),
                            ],
                          ),
                        ),
                        // Green star decoration
                        const Text('✦',
                            style: TextStyle(
                                fontSize: 20,
                                color: kYellow,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Step indicator ─────────────────────────────
                    _buildStepIndicator(),

                    const SizedBox(height: 20),

                    // ── FOR FREELANCERS ────────────────────────────
                    const Text(
                      'FOR FREELANCERS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: kYellow,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ..._freelancerScenarios.asMap().entries.map((e) {
                      final i = e.key;
                      final s = e.value;
                      return _ScenarioCard(
                        emoji: s.$1,
                        title: s.$2,
                        subtitle: s.$3,
                        badge: s.$4,
                        badgeBg: s.$5,
                        badgeFg: s.$6,
                        selected: _selectedIndex == i,
                        onTap: () => setState(() => _selectedIndex = i),
                      );
                    }),

                    // ── +Add for freelancers ───────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SimulationCustomRoleScreen(
                              roleName: 'Custom',
                              scenarioName: 'Freelancer Scenario',
                              difficulty: 'Medium',
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: kAddBg,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Text(
                            '+Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kYellowDk,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── FOR STUDENTS ───────────────────────────────
                    const Text(
                      'FOR STUDENTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: kYellow,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ..._studentScenarios.asMap().entries.map((e) {
                      final i = e.key + _freelancerScenarios.length;
                      final s = e.value;
                      return _ScenarioCard(
                        emoji: s.$1,
                        title: s.$2,
                        subtitle: s.$3,
                        badge: s.$4,
                        badgeBg: s.$5,
                        badgeFg: s.$6,
                        selected: _selectedIndex == i,
                        onTap: () => setState(() => _selectedIndex = i),
                      );
                    }),

                    // ── +Add for students ──────────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SimulationCustomRoleScreen(
                              roleName: 'Custom',
                              scenarioName: 'Student Scenario',
                              difficulty: 'Medium',
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: kAddBg,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Text(
                            '+Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kYellowDk,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Next button ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Get selected scenario name
                    final allScenarios = [
                      ..._freelancerScenarios,
                      ..._studentScenarios,
                    ];
                    final s = allScenarios[_selectedIndex];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SimulationAIRoleScreen(
                          scenarioName: s.$2,
                          scenarioEmoji: s.$1,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBtnBg,
                    foregroundColor: kYellowDk,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next — Assign AI Role',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.chevron_right_rounded, size: 22),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step indicator ─────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ['Scenario', 'AI Role', 'Simulate'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (i) {
        final active = i == 0;
        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: active ? kYellow : const Color(0xFF3D2A7A),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: active
                            ? kYellowDk
                            : const Color(0xFF7B6AB5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 9,
                    color: active ? kYellow : const Color(0xFF7B6AB5),
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1)
              Container(
                width: 28,
                height: 2,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D2A7A),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        );
      }),
    );
  }
}

// ── Scenario card ──────────────────────────────────────────────────────────────
class _ScenarioCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeBg;
  final Color badgeFg;
  final bool selected;
  final VoidCallback onTap;

  static const Color kCard   = Color(0xFF3D2490);
  static const Color kIconBg = Color(0xFF2D1B69);
  static const Color kYellow = Color(0xFFC8F55A);

  const _ScenarioCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeBg,
    required this.badgeFg,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(color: kYellow, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Emoji icon box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kIconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (badge.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeFg,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB9A8E8),
                      height: 1.4,
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
}
