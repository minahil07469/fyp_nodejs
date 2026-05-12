import 'package:flutter/material.dart';

class VoiceAnalysisScreen extends StatelessWidget {
  const VoiceAnalysisScreen({super.key});

  static const Color kBg       = Color(0xFFFFFFFF);
  static const Color kHeader   = Color(0xFF1C0E4E);
  static const Color kPrimary  = Color(0xFF5B2DD9);
  static const Color kRed      = Color(0xFFCC3333);
  static const Color kOrange   = Color(0xFFE8860A);
  static const Color kBarBg    = Color(0xFFEDE8FF);
  static const Color kSectionBg= Color(0xFFF7F4FF);
  static const Color kDivider  = Color(0xFFEDE8FF);
  static const Color kGrey     = Color(0xFF888888);

  // (label, fill, color, value, showAlert)
  static const _metrics = [
    ('Pitch',          0.72, Color(0xFF5B2DD9), '72%',  false),
    ('Speed',          0.82, Color(0xFFCC3333), '82%',  true),
    ('Volume',         0.78, Color(0xFF5B2DD9), '78%',  false),
    ('Tone - Jitter',  0.18, Color(0xFFE8860A), 'Low ✓',false),
    ('Tone - Strained',0.14, Color(0xFFE8860A), 'Low ✓',false),
    ('Pauses',         0.55, Color(0xFFCC3333), '55%',  true),
    ('Filler words',   0.10, Color(0xFFCC3333), '3',    true),
    ('Articulation',   0.80, Color(0xFF5B2DD9), '80%',  false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────
            _buildHeader(context),

            // ── Section label ────────────────────────────────────────
            _buildSectionLabel(),

            // ── Metrics list ─────────────────────────────────────────
            Container(
              color: kBg,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                children: _metrics.map((m) => _buildMetricRow(
                  label: m.$1,
                  fill: m.$2,
                  barColor: m.$3,
                  value: m.$4,
                  alert: m.$5,
                )).toList(),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────
            _buildFooter(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: kHeader,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Row(
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
          const SizedBox(width: 10),
          const Text(
            'Voice Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────
  Widget _buildSectionLabel() {
    return Container(
      color: kSectionBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              // Pink badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8348A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'VOICE\nANALYS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 6,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Voice analysis',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kHeader)),
                  Text('Data-analyzing factors',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF9B8EC4))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: kDivider),
        ],
      ),
    );
  }

  // ── Metric row ─────────────────────────────────────────────────────────────
  Widget _buildMetricRow({
    required String label,
    required double fill,
    required Color barColor,
    required String value,
    required bool alert,
  }) {
    final isLow = value.contains('Low');
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          // Label
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
          ),
          // Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fill,
                minHeight: 10,
                backgroundColor: kBarBg,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Value
          SizedBox(
            width: 44,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isLow ? kGrey : const Color(0xFF333333),
              ),
            ),
          ),
          // Alert icon
          SizedBox(
            width: 16,
            child: alert
                ? const Text(
                    '!',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      color: kRed,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: kHeader,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Column(
        children: [
          Text('SPEAKORA',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          SizedBox(height: 4),
          Text('Generated: May 1, 2026 · Session #24',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Color(0xFFB9A8E8))),
        ],
      ),
    );
  }
}
