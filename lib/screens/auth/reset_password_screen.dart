import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/auth_service.dart';
import '../../core/app_flushbar.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _codeCtrl        = TextEditingController();
  final _newPassCtrl     = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureNew     = true;
  bool _obscureConfirm = true;
  bool _isLoading      = false;

  static const Color kBg      = Color(0xFF290451);
  static const Color kCard    = Color(0xFFFFFEF6);
  static const Color kPrimary = Color(0xFF5B2DD9);
  static const Color kSubtitle= Color(0xFFB9A8E8);
  static const Color kHint    = Color(0xFFC2B0E0);
  static const Color kFieldBg = Color(0xFFFBF4F5);
  static const Color kBtnBg   = Color(0xFFC5AAED);
  static const Color kBackBg  = Color(0xFFF0EAFF);
  static const Color kGrey    = Color(0xFFAAAAAA);
  static const Color kError   = Color(0xFFD32F2F);

  @override
  void dispose() {
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    setState(() => _isLoading = true);

    final error = await AuthService.resetPassword(
      email:           widget.email,
      code:            _codeCtrl.text,
      newPassword:     _newPassCtrl.text,
      confirmPassword: _confirmPassCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      showFlushbar(context, error);
    } else {
      showFlushbar(
        context,
        '✅ Password reset! Please log in with your new password.',
        isError: false,
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w  = mq.size.width;
    final h  = mq.size.height;

    return Scaffold(
      backgroundColor: kBg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Decorative stars
          Positioned(
            top: h * 0.085, right: w * 0.10,
            child: const _Star(size: 22, opacity: 0.9),
          ),
          Positioned(
            top: h * 0.22, right: w * 0.08,
            child: const _Star(size: 10, opacity: 0.35),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(w * 0.07, h * 0.04, w * 0.07, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.22,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Enter the code sent to ${widget.email}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: kSubtitle,
                          height: 1.23,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.035),

                // White card
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.08, vertical: h * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Code icon
                          Center(
                            child: Container(
                              width: 72, height: 72,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEDE8FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.mark_email_read_rounded,
                                color: kPrimary, size: 36,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Reset Code field
                          const Text(
                            'Reset Code',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildField(
                            controller: _codeCtrl,
                            hint: 'Enter code from email',
                            icon: Icons.vpn_key_outlined,
                            textCapitalization: TextCapitalization.characters,
                          ),

                          const SizedBox(height: 16),

                          // New Password field
                          const Text(
                            'New Password',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildField(
                            controller: _newPassCtrl,
                            hint: 'Min 8 chars, A-Z, a-z, 0-9',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscureNew,
                            suffix: _eyeBtn(
                              visible: _obscureNew,
                              onTap: () => setState(() => _obscureNew = !_obscureNew),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password field
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildField(
                            controller: _confirmPassCtrl,
                            hint: 'Re-enter new password',
                            icon: Icons.lock_person_outlined,
                            obscure: _obscureConfirm,
                            suffix: _eyeBtn(
                              visible: _obscureConfirm,
                              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Reset button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleReset,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBtnBg,
                                foregroundColor: kPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22, height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Back to login
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_rounded, size: 18),
                              label: const Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBackBg,
                                foregroundColor: kPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(height: 48, color: kBg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9B8EC4), width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(icon, color: const Color(0xFF9B8EC4), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              textCapitalization: textCapitalization,
              style: const TextStyle(fontSize: 14, color: Color(0xFF2D1B69)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 14, color: kHint),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffix != null) ...[suffix, const SizedBox(width: 10)],
        ],
      ),
    );
  }

  Widget _eyeBtn({required bool visible, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: const Color(0xFF9B8EC4),
        size: 18,
      ),
    );
  }
}

// ── 4-point star ──────────────────────────────────────────────────────────────
class _Star extends StatelessWidget {
  final double size;
  final double opacity;
  const _Star({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(size, size),
        painter: _StarPainter(),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFC8F55A);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2;
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle  = (i * 45 - 90) * pi / 180;
      final radius = i.isEven ? r : r * 0.4;
      final x = cx + radius * cos(angle);
      final y = cy + radius * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter old) => false;
}
