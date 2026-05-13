import 'package:flutter/material.dart';
import '../../core/auth_service.dart';

class AvatarPickerScreen extends StatefulWidget {
  const AvatarPickerScreen({super.key});

  @override
  State<AvatarPickerScreen> createState() => _AvatarPickerScreenState();
}

class _AvatarPickerScreenState extends State<AvatarPickerScreen> {
  int _selected = 0;

  static const Color kBg      = Color(0xFFF5F0FA);
  static const Color kPrimary = Color(0xFF5300AC);
  static const Color kBtn     = Color(0xFF2F0A56);
  // Card: rgba(230,190,240,0.2) on white bg ≈ #F5EAF9 blended
  static const Color kCardBg  = Color(0x33E6BEF0); // rgba(230,190,240,0.2)
  static const Color kCardBorder = Color(0xFFF0D4FF); // #F0D4FF
  static const Color kBadge   = Color(0xFF2F0A56);  // #2F0A56
  // Top big circle: rgba(230,190,240,0.3)
  static const Color kCircle  = Color(0x4DE6BEF0);

  static const List<String> _avatars = [
    'assets/avator/avator1.png',
    'assets/avator/avator2.png',
    'assets/avator/avator3.png',
    'assets/avator/avator4.png',
    'assets/avator/avator6.png',
    'assets/avator/avator7.png',
    'assets/avator/avator8.png',
    'assets/avator/avator9.png',
    'assets/avator/avator10.png',
    'assets/avator/avator11.png',
    'assets/avator/avator12.png',
    'assets/avator/avator13.png',
  ];

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    final rows = <List<int>>[];
    for (int i = 0; i < _avatars.length; i += 3) {
      rows.add([i, i + 1, i + 2]);
    }

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ── Big decorative circle (587×462, rgba(230,190,240,0.3)) ──
          Positioned(
            top: -100,
            left: (screenW - 587) / 2,
            child: Container(
              width: 587,
              height: 462,
              decoration: const BoxDecoration(
                color: kCircle,
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Header ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.chevron_left_rounded,
                            color: kPrimary, size: 28),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Avatar rows ──────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    child: Column(
                      children: rows.map((row) {
                        return _AvatarRow(
                          indices: row,
                          avatars: _avatars,
                          selected: _selected,
                          onSelect: (i) =>
                              setState(() => _selected = i),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ── Confirm button ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 28),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        await AuthService.updateAvatar(_avatars[_selected]);
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBtn,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
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
    );
  }
}

// ── Row card: 275×113, rgba(230,190,240,0.2), border 6px #F0D4FF, radius 20
class _AvatarRow extends StatelessWidget {
  final List<int> indices;
  final List<String> avatars;
  final int selected;
  final ValueChanged<int> onSelect;

  const _AvatarRow({
    required this.indices,
    required this.avatars,
    required this.selected,
    required this.onSelect,
  });

  static const Color kCardBg     = Color(0x33E6BEF0);
  static const Color kCardBorder = Color(0xFFF0D4FF);
  static const Color kBadge      = Color(0xFF2F0A56);
  static const Color kSelected   = Color(0xFF5300AC);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kCardBorder, width: 6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: indices.map((i) {
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // ── Image block: 62×50 ──────────────────────────────
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: kSelected, width: 3)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: kSelected.withOpacity(0.25),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      avatars[i],
                      width: 62,
                      height: 62,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ── Badge: 19×20, #2F0A56 ───────────────────────────
                Positioned(
                  top: -10,
                  child: Container(
                    width: 19,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: kBadge,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
