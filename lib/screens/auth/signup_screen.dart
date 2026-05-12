import 'package:flutter/material.dart';
import '../../core/auth_service.dart';
import 'login_screen.dart';
import '../../core/app_flushbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController       = TextEditingController();
  final _emailController      = TextEditingController();
  final _passwordController   = TextEditingController();
  final _confirmPwdController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _isLoading       = false;

  // Inline validation errors
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  static const Color kBg       = Color(0xFF1A0535);
  static const Color kCard     = Color(0xFF2D0A52);
  static const Color kFieldBg  = Color(0xFF3A1260);
  static const Color kBtnBg    = Color(0xFFD4A8F0);
  static const Color kPrimary  = Color(0xFF5300AC);
  static const Color kHintText = Color(0xFF9B7EC8);
  static const Color kTitle    = Color(0xFFFFFEF6);
  static const Color kError    = Color(0xFFFF6B6B);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  // â”€â”€ Client-side validation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _validateFields() {
    String? nameErr, emailErr, passErr, confirmErr;

    if (_nameController.text.trim().isEmpty) nameErr = 'Name is required.';

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      emailErr = 'Email is required.';
    } else if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
      emailErr = 'Enter a valid email address.';
    }

    final pass = _passwordController.text;
    if (pass.isEmpty) {
      passErr = 'Password is required.';
    } else if (pass.length < 8) {
      passErr = 'At least 8 characters.';
    } else if (!pass.contains(RegExp(r'[A-Z]'))) {
      passErr = 'Must contain an uppercase letter.';
    } else if (!pass.contains(RegExp(r'[a-z]'))) {
      passErr = 'Must contain a lowercase letter.';
    } else if (!pass.contains(RegExp(r'[0-9]'))) {
      passErr = 'Must contain a number.';
    }

    final confirm = _confirmPwdController.text;
    if (confirm.isEmpty) {
      confirmErr = 'Please confirm your password.';
    } else if (confirm != pass) {
      confirmErr = 'Passwords do not match.';
    }

    setState(() {
      _nameError    = nameErr;
      _emailError   = emailErr;
      _passwordError = passErr;
      _confirmError = confirmErr;
    });

    return nameErr == null && emailErr == null &&
        passErr == null && confirmErr == null;
  }

  Future<void> _handleSignup() async {
    if (!_validateFields()) return;

    setState(() => _isLoading = true);
    final error = await AuthService.signUp(
      name:            _nameController.text,
      email:           _emailController.text,
      password:        _passwordController.text,
      confirmPassword: _confirmPwdController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      // Server / auth error â†’ flushbar
      showFlushbar(context, error);
    } else {
      showFlushbar(context, 'Check your email to verify your account before logging in.', isError: false);
      await Future.delayed(const Duration(seconds: 1));
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
    return Scaffold(
      backgroundColor: kBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: BoxDecoration(
                    color: kCard, borderRadius: BorderRadius.circular(36)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: kTitle,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 28),

                      _buildField(
                        controller: _nameController,
                        hint: 'Name',
                        icon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        errorText: _nameError,
                        onChanged: (_) {
                          if (_nameError != null) setState(() => _nameError = null);
                        },
                      ),

                      const SizedBox(height: 14),

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

                      _buildField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        errorText: _passwordError,
                        onChanged: (_) {
                          if (_passwordError != null) setState(() => _passwordError = null);
                        },
                        suffix: _eyeIcon(
                          visible: _obscurePassword,
                          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),

                      const SizedBox(height: 14),

                      _buildField(
                        controller: _confirmPwdController,
                        hint: 'Confirm Password',
                        icon: Icons.lock_person_outlined,
                        obscure: _obscureConfirm,
                        errorText: _confirmError,
                        onChanged: (_) {
                          if (_confirmError != null) setState(() => _confirmError = null);
                        },
                        suffix: _eyeIcon(
                          visible: _obscureConfirm,
                          onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBtnBg,
                            foregroundColor: kPrimary,
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
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.45)),
                              children: const [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                      color: kBtnBg, fontWeight: FontWeight.w600),
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
          height: 54,
          decoration: BoxDecoration(
            color: kFieldBg,
            border: Border.all(
              color: hasError ? kError : Colors.transparent,
              width: 1.6,
            ),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(icon,
                  color: hasError ? kError.withValues(alpha: 0.8) : kHintText,
                  size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 15, color: kTitle),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 15, color: kHintText),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (suffix != null) ...[suffix, const SizedBox(width: 14)],
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              errorText,
              style: const TextStyle(fontSize: 11, color: kError),
            ),
          ),
        ],
      ],
    );
  }

  Widget _eyeIcon({required bool visible, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: kHintText,
        size: 18,
      ),
    );
  }
}
