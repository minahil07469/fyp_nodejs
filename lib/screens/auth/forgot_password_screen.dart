import 'dart:math';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../../core/auth_service.dart';
import '../../core/app_flushbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  static const Color kBg      = Color(0xFF290451);
  static const Color kCard    = Color(0xFFFFFEF6);
  static const Color kPrimary = Color(0xFF5B2DD9);
  static const Color kSubtitle= Color(0xFFB9A8E8);
  static const Color kHint    = Color(0xFFC2B0E0);
  static const Color kFieldBg = Color(0xFFFBF4F5);
  static const Color kBtnBg   = Color(0xFFC5AAED);
  static const Color kBackBg  = Color(0xFFF0EAFF);
  static const Color kDivider = Color(0xFFDDD6F0);
  static const Color kGrey    = Color(0xFFAAAAAA);
  static const Color kLockBg  = Color(0xFFEDE8FF);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
          // ── Decorative green 4-point stars ──────────────────────────
          Positioned(
            top: h * 0.085,
            right: w * 0.10,
            child: const _Star(size: 22, opacity: 0.9),
          ),
          Positioned(
            top: h * 0.22,
            right: w * 0.08,
            child: const _Star(size: 10, opacity: 0.35),
          ),
          Positioned(
            top: h * 0.245,
            left: w * 0.08,
            child: const _Star(size: 9, opacity: 0.3),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header text ────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      w * 0.07, h * 0.04, w * 0.07, 0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.22,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "No worries, we'll get you back in.",
                        style: TextStyle(
                          fontSize: 13,
                          color: kSubtitle,
                          height: 1.23,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.035),

                // ── White card ─────────────────────────────────────────
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
                        children: [
                          // Lock icon
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: kLockBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: kPrimary,
                              size: 36,
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Reset your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D1B69),
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Enter your registered email and we'll\nsend you a reset link right away.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: kGrey,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Email label
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: kPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Email field
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: kFieldBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF9B8EC4),
                                  width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                const Icon(Icons.email_outlined,
                                    color: Color(0xFF9B8EC4), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _emailController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF2D1B69)),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your email address',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: kHint),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Send Reset Link
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_emailController.text.trim().isEmpty) {
                                  showFlushbar(context, 'Please enter your email.');
                                  return;
                                }
                                final error =
                                    await AuthService.sendPasswordReset(
                                  email: _emailController.text,
                                );
                                if (!mounted) return;
                                if (error != null) {
                                  showFlushbar(context, error);
                                } else {
                                  showFlushbar(context, '\u2705 Reset link sent! Check your email (including spam).', isError: false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBtnBg,
                                foregroundColor: kPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Send Reset Link',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Divider "or"
                          Row(
                            children: [
                              const Expanded(
                                  child: Divider(
                                      color: kDivider, thickness: 1)),
                              const Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                child: Text('or',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFC0B0D8))),
                              ),
                              const Expanded(
                                  child: Divider(
                                      color: kDivider, thickness: 1)),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Back to Login
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18),
                              label: const Text(
                                'Back to Login',
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

                          const SizedBox(height: 22),

                          // Didn't receive / Resend
                          const Text(
                            "Didn't receive the email?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFBBAACC)),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              if (_emailController.text.trim().isEmpty) {
                                showFlushbar(context, 'Enter your email above first.');
                                return;
                              }
                              final error = await AuthService.sendPasswordReset(
                                email: _emailController.text,
                              );
                              if (!mounted) return;
                              showFlushbar(context, error ?? '\u2705 Reset link resent! Check your email.', isError: error != null);
                            },
                            child: const Text(
                              'Resend link',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: kPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Don't have an account
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreen()),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 13, color: kGrey),
                                children: [
                                  TextSpan(
                                      text: "Don't have an account? "),
                                  TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                      color: kPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Bottom dark bar ──────────────────────────────────
                Container(height: 48, color: kBg),
              ],
            ),
          ),
        ],
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
