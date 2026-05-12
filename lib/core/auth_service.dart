import 'package:flutter/foundation.dart' show kIsWeb, ValueNotifier;
import 'dart:io' show Platform, File, Directory;
import 'dart:convert' show json;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // ── Platform check ─────────────────────────────────────────────────────────
  static bool get isSupported =>
      kIsWeb || Platform.isAndroid || Platform.isIOS;

  // Firebase Web API key — used for REST calls on Windows desktop
  static const String _firebaseApiKey = 'AIzaSyCUouygu_B1KTQGUZRZYKwkUK3oGjx40Xs';

  static FirebaseAuth get _auth => FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Windows-only: local registry ───────────────────────────────────────────
  static final Map<String, String> _registeredUsers = {};
  static String? _windowsLoggedInEmail;

  static String? get windowsEmail => _windowsLoggedInEmail;

  // ── Global name notifier — Profile & Home listen to this ──────────────────
  static final ValueNotifier<String> displayNameNotifier =
      ValueNotifier<String>('User');

  // ── Current user ───────────────────────────────────────────────────────────
  static User? get currentUser => isSupported ? _auth.currentUser : null;
  static Stream<User?> get authStateChanges =>
      isSupported ? _auth.authStateChanges() : Stream.value(null);

  // ── Email verified check ───────────────────────────────────────────────────
  static bool get isEmailVerified {
    if (!isSupported) return true; // Windows local — skip verification
    return _auth.currentUser?.emailVerified ?? false;
  }

  // ── Display name persistence (dart:io — no extra package needed) ───────────
  static String? _cachedDisplayName;

  static File _nameFile() {
    String dir;
    try {
      if (Platform.isWindows) {
        final appData = Platform.environment['APPDATA'] ?? '.';
        dir = '$appData\\fyp_app';
      } else if (Platform.isLinux || Platform.isMacOS) {
        final home = Platform.environment['HOME'] ?? '.';
        dir = '$home/.fyp_app';
      } else {
        dir = '.';
      }
      Directory(dir).createSync(recursive: true);
    } catch (_) {
      dir = '.';
    }
    return File('$dir${Platform.pathSeparator}display_name.txt');
  }

  static String get displayName {
    if (_cachedDisplayName != null && _cachedDisplayName!.trim().isNotEmpty) {
      return _cachedDisplayName!;
    }
    if (!isSupported) {
      if (_windowsLoggedInEmail != null) {
        return _extractFirstName(_windowsLoggedInEmail!);
      }
      return 'User';
    }
    final user = _auth.currentUser;
    if (user == null) return 'User';
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    return _extractFirstName(user.email ?? 'User');
  }

  static Future<void> loadSavedDisplayName() async {
    try {
      final file = _nameFile();
      if (await file.exists()) {
        final saved = (await file.readAsString()).trim();
        if (saved.isNotEmpty) {
          _cachedDisplayName = saved;
          displayNameNotifier.value = saved;
          return;
        }
      }
    } catch (_) {}
    syncDisplayName();
  }

  static String _extractFirstName(String email) {
    final local = email.split('@').first;
    final match = RegExp(r'^[a-zA-Z]+').firstMatch(local);
    if (match == null) return local;
    final name = match.group(0)!;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  static Future<void> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _cachedDisplayName = trimmed;
    displayNameNotifier.value = trimmed;
    try {
      await _nameFile().writeAsString(trimmed);
    } catch (_) {}
    if (isSupported && _auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(trimmed);
      await _auth.currentUser!.reload();
    }
  }

  static void syncDisplayName() {
    displayNameNotifier.value = displayName;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // VALIDATION
  // ══════════════════════════════════════════════════════════════════════════

  static String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return 'Email is required.';
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) return 'Enter a valid email address.';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required.';
    if (password.length < 8) return 'Password must be at least 8 characters.';
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter.';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least 1 lowercase letter.';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 number.';
    }
    return null;
  }

  static String? validateConfirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Please confirm your password.';
    if (password != confirm) return 'Passwords do not match.';
    return null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SIGN UP — creates account + sends verification email
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    String name = '',
  }) async {
    final emailErr = validateEmail(email);
    if (emailErr != null) return emailErr;
    final passErr = validatePassword(password);
    if (passErr != null) return passErr;
    final confirmErr = validateConfirmPassword(password, confirmPassword);
    if (confirmErr != null) return confirmErr;

    final normalised = email.trim().toLowerCase();
    final trimmedName = name.trim();

    if (!isSupported) {
      // Windows local path — no email verification
      if (_registeredUsers.containsKey(normalised)) {
        return 'An account already exists with this email. Please log in.';
      }
      _registeredUsers[normalised] = password.trim();
      if (trimmedName.isNotEmpty) await updateDisplayName(trimmedName);
      return null;
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalised,
        password: password.trim(),
      );

      // Save display name
      if (trimmedName.isNotEmpty) {
        await credential.user?.updateDisplayName(trimmedName);
        await credential.user?.reload();
        await updateDisplayName(trimmedName);
      }

      // Send verification email
      await credential.user?.sendEmailVerification();

      // Sign out immediately — user must verify before logging in
      await _auth.signOut();

      return null;
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (_) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEND VERIFICATION EMAIL  (resend from verification screen)
  // ══════════════════════════════════════════════════════════════════════════
  /// Signs in temporarily, sends verification email, then signs out.
  static Future<String?> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    if (!isSupported) return null;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      if (credential.user?.emailVerified ?? false) {
        return 'already-verified';
      }
      await credential.user?.sendEmailVerification();
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (_) {
      return 'Failed to resend. Please try again.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOGIN — blocks unverified emails
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) return 'Email is required.';
    if (password.isEmpty) return 'Password is required.';

    final emailErr = validateEmail(email);
    if (emailErr != null) return emailErr;

    final normalised = email.trim().toLowerCase();

    if (!isSupported) {
      if (!_registeredUsers.containsKey(normalised)) {
        return 'No account found with this email. Please sign up first.';
      }
      if (_registeredUsers[normalised] != password.trim()) {
        return 'Incorrect password. Please try again.';
      }
      _windowsLoggedInEmail = normalised;
      return null;
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalised,
        password: password.trim(),
      );

      // Block login if email not verified
      if (!(credential.user?.emailVerified ?? false)) {
        await _auth.signOut();
        return 'email-not-verified';
      }

      syncDisplayName();
      return null;
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (_) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GOOGLE SIGN-IN
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> signInWithGoogle() async {
    if (!isSupported) {
      return 'Google Sign-In is only available on Android and iOS.';
    }
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Google sign-in was cancelled.';
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (_) {
      return 'Google sign-in failed. Please try again.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CHANGE PASSWORD
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty) return 'Current password is required.';
    if (newPassword.isEmpty) return 'New password is required.';
    if (confirmPassword.isEmpty) return 'Please confirm your new password.';

    final passErr = validatePassword(newPassword);
    if (passErr != null) return passErr;

    if (newPassword != confirmPassword) return 'Passwords do not match.';

    if (currentPassword == newPassword) {
      return 'New password must be different from current password.';
    }

    if (!isSupported) {
      final email = _windowsLoggedInEmail;
      if (email == null) return 'You must be logged in to change password.';
      if (_registeredUsers[email] != currentPassword.trim()) {
        return 'Current password is incorrect.';
      }
      _registeredUsers[email] = newPassword.trim();
      return null;
    }

    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return 'You must be logged in to change password.';
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword.trim(),
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Current password is incorrect.';
      }
      return _errorMessage(e.code);
    } catch (_) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> sendPasswordReset({required String email}) async {
    final emailErr = validateEmail(email);
    if (emailErr != null) return emailErr;

    final normalised = email.trim().toLowerCase();

    // On Android/iOS Firebase SDK is initialized — use it directly.
    if (isSupported) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: normalised);
        return null;
      } on FirebaseAuthException catch (e) {
        return _errorMessage(e.code);
      } catch (_) {
        return 'An unexpected error occurred. Please try again.';
      }
    }

    // On Windows/desktop Firebase is not initialized, so call the REST API
    // directly. This is the same endpoint the SDK uses internally.
    try {
      final uri = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode'
        '?key=$_firebaseApiKey',
      );
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'requestType': 'PASSWORD_RESET',
          'email': normalised,
        }),
      );

      // DEBUG — remove after confirming it works
      print('[PasswordReset] status=${response.statusCode} body=${response.body}');

      if (response.statusCode == 200) return null;

      // Parse Firebase error from response body
      final body = json.decode(response.body) as Map<String, dynamic>;
      final code = (body['error']?['message'] as String? ?? '').toLowerCase();
      if (code.contains('email_not_found') || code.contains('user_not_found')) {
        return 'No account found with this email.';
      }
      if (code.contains('invalid_email')) {
        return 'Please enter a valid email address.';
      }
      if (code.contains('too_many_attempts')) {
        return 'Too many attempts. Please try again later.';
      }
      return 'Failed to send reset email. Please try again ($code)';
    } catch (e) {
      print('[PasswordReset] exception: $e');
      return 'Network error. Please check your connection.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOGOUT
  // ══════════════════════════════════════════════════════════════════════════
  static Future<void> logout() async {
    _windowsLoggedInEmail = null;
    _cachedDisplayName = null;
    try {
      final file = _nameFile();
      if (await file.exists()) await file.delete();
    } catch (_) {}
    if (!isSupported) return;
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ERROR MESSAGES
  // ══════════════════════════════════════════════════════════════════════════
  static String _errorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Please log in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 8 characters with uppercase, lowercase and number.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'requires-recent-login':
        return 'Please log in again to continue.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
