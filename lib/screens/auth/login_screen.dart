import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../../core/auth_service.dart';
import '../home/home_screen.dart';
import '../../core/app_flushbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;
  bool _rememberMe      = false;

  // Inline validation errors
  String? _emailError;
  String? _passwordError;

  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  static const Color kBg          = Color(0xFF2F0A56);
  static const Color kCard        = Color(0xFFFFFEF6);
  static const Color kPrimary     = Color(0xFF5300AC);
  static const Color kFieldBg     = Color(0xFFF3E8FF);
  static const Color kFieldBorder = Color(0xFFE6C6F7);
  static const Color kBtnBg       = Color(0xFFD4A8F0);
  static const Color kStar        = Color(0xFFCDCC58);
  static const Color kHintText    = Color(0xFF8B60C8);
  static const Color kDivider     = Color(0xFFD5C3E8);
  static const Color kError       = Color(0xFFD32F2F);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim  = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // â”€â”€ Client-side validation â€” returns true if all fields are valid â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _validateFields() {
    String? emailErr;
    String? passErr;

    final email = _emailController.text.trim();
    final pass  = _passwordController.text;

    if (email.isEmpty) {
      emailErr = 'Email is required.';
    } else if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
      emailErr = 'Enter a valid email address.';
    }

    if (pass.isEmpty) passErr = 'Password is required.';

    setState(() {
      _emailError    = emailErr;
      _passwordError = passErr;
    });

    return emailErr == null && passErr == null;
  }

  Future<void> _handleLogin() async {
    if (!_validateFields()) return;

    setState(() => _isLoading = true);
    final error = await AuthService.login(
      email:    _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else if (error == 'email-not-verified') {
      _showVerificationDialog();
    } else {
      showFlushbar(context, error);
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool sending = false;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: kCard,
            title: const Text(
              'Verify your email',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: kPrimary,
                fontSize: 18,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We sent a verification link to\n${_emailController.text.trim()}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF444444),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your inbox (and spam folder) and click the link before logging in.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: kPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: sending
                    ? null
                    : () async {
                        setDialogState(() => sending = true);
                        final err = await AuthService.resendVerificationEmail(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (!ctx.mounted) return;
                        setDialogState(() => sending = false);
                        Navigator.pop(ctx);
                        if (err == 'already-verified') {
                          showFlushbar(
                            context,
                            'Your email is already verified. Please log in.',
                            isError: false,
                          );
                        } else if (err != null) {
                          showFlushbar(context, err);
                        } else {
                          showFlushbar(
                            context,
                            'Verification email resent! Check your inbox.',
                            isError: false,
                          );
                        }
                      },
                child: sending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: kPrimary),
                      )
                    : const Text(
                        'Resend email',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: kPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 36, bottom: 20),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hey! ',
                      style: TextStyle(
                        fontFamily: 'BerlinSansFBDemi',
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFEF9F5),
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(text: '👋', style: TextStyle(fontSize: 34)),
                  ],
                ),
              ),
            ),

            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 14, right: 14),
                    decoration: const BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.all(Radius.circular(55)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + star
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'BerlinSansFBDemi',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimary,
                                  letterSpacing: -0.3,
                                  height: 1.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Transform.rotate(
                                  angle: 0.35,
                                  child: Icon(Icons.star_rounded,
                                      color: kStar.withValues(alpha: 0.65), size: 28),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Email field
                          _buildField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                            onChanged: (_) {
                              if (_emailError != null) setState(() => _emailError = null);
                            },
                          ),

                          const SizedBox(height: 14),

                          // Password field
                          _buildField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscurePassword,
                            errorText: _passwordError,
                            onChanged: (_) {
                              if (_passwordError != null) setState(() => _passwordError = null);
                            },
                            suffix: GestureDetector(
                              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: kPrimary.withValues(alpha: 0.45),
                                size: 18,
                              ),
                            ),
                          ),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(top: 6, bottom: 2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ),

                          // Remember me
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                  activeColor: kPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  side: BorderSide(
                                      color: kPrimary.withValues(alpha: 0.4), width: 1.5),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => setState(() => _rememberMe = !_rememberMe),
                                child: Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: kPrimary.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBtnBg,
                                foregroundColor: kBg,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'BerlinSansFBDemi',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: kDivider, thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'or login with',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.35),
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: kDivider, thickness: 1)),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Social buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialBtn('assets/facebook.png'),
                              const SizedBox(width: 12),
                              _socialBtn(
                                'assets/google.png',
                                onTap: () async {
                                  setState(() => _isLoading = true);
                                  final error = await AuthService.signInWithGoogle();
                                  if (!mounted) return;
                                  setState(() => _isLoading = false);
                                  if (error != null) {
                                    showFlushbar(context, error);
                                  } else {
                                    AuthService.syncDisplayName();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      (_) => false,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              _socialBtn('assets/apple.png'),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Sign-up link
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const SignupScreen())),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.38),
                                  ),
                                  children: const [
                                    TextSpan(text: "Don't have an account? "),
                                    TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                          color: kPrimary, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  // â”€â”€ Field with inline error â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: kFieldBg.withValues(alpha: 0.45),
            border: Border.all(
              color: hasError ? kError : kFieldBorder,
              width: hasError ? 1.6 : 1.2,
            ),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(icon,
                  color: hasError
                      ? kError.withValues(alpha: 0.7)
                      : kPrimary.withValues(alpha: 0.45),
                  size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 15, color: kBg),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                        fontFamily: 'Poppins', fontSize: 15, color: kHintText),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              if (suffix != null) ...[suffix, const SizedBox(width: 16)],
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              errorText,
              style: const TextStyle(
                  fontSize: 11, color: kError, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _socialBtn(String asset, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kFieldBorder, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Image.asset(asset,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.public, size: 18, color: kPrimary)),
        ),
      ),
    );
  }
}
