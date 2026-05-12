import 'package:flutter/material.dart';
import 'simulation_active_screen.dart';

class SimulationCustomRoleScreen extends StatefulWidget {
  final String roleName;
  final String scenarioName;
  final String difficulty;

  const SimulationCustomRoleScreen({
    super.key,
    this.roleName     = 'Other',
    this.scenarioName = 'Custom Scenario',
    this.difficulty   = 'Medium',
  });

  @override
  State<SimulationCustomRoleScreen> createState() =>
      _SimulationCustomRoleScreenState();
}

class _SimulationCustomRoleScreenState
    extends State<SimulationCustomRoleScreen> {
  final _roleCtrl    = TextEditingController();
  final _contextCtrl = TextEditingController();

  static const Color kBg      = Color(0xFF1C0E4E);
  static const Color kCard    = Color(0xFF3D2490);
  static const Color kIconBg  = Color(0xFF2D1B69);
  static const Color kYellow  = Color(0xFFD9E366);
  static const Color kYellowDk= Color(0xFF1C0E4E);
  static const Color kSubtitle= Color(0xFFB9A8E8);
  static const Color kMuted   = Color(0xFF7B6AB5);
  static const Color kFieldBg = Color(0xFF2D1B69);
  static const Color kBtnBg   = Color(0xFFD9E366);

  @override
  void dispose() {
    _roleCtrl.dispose();
    _contextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // ── Card ──────────────────────────────────────────
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                      decoration: BoxDecoration(
                        color: kCard.withOpacity(0.62),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: kYellow, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon + Role label
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: kIconBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('✏️',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Role.......',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Write the role here........',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: kSubtitle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Divider
                          Container(
                            height: 1,
                            color: kIconBg,
                          ),

                          const SizedBox(height: 14),

                          // "What scenario are you interviewing for?"
                          const Text(
                            'What scenario are you interviewing for?',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC8F55A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Tap one — ARIA will ask questions for that exact scenario',
                            style: TextStyle(
                                fontSize: 10, color: kMuted),
                          ),

                          const SizedBox(height: 10),

                          // Role text field
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: kFieldBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _roleCtrl,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText:
                                    '✎ e.g. Creative Strategist, AI Engineer, Game Dev...',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4A5A6A)),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Start Session button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SimulationActiveScreen(
                                    roleName: _roleCtrl.text.isNotEmpty
                                        ? _roleCtrl.text
                                        : widget.roleName,
                                    scenarioName: widget.scenarioName,
                                    difficulty: widget.difficulty,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBtnBg,
                                foregroundColor: kYellowDk,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Start Session',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.chevron_right_rounded,
                                      size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Yellow checkmark badge top-right
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC8F55A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            color: kYellowDk, size: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Back link
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '← Back',
                    style: TextStyle(fontSize: 12, color: kMuted),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
