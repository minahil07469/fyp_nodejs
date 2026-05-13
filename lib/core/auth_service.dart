import 'package:flutter/foundation.dart' show ValueNotifier;
import 'dart:io' show Platform, File, Directory;
import 'dart:convert' show jsonEncode, jsonDecode;
import '../services/api_service.dart';

class AuthService {
  // ── Session state ──────────────────────────────────────────────────────────
  static String? _loggedInEmail;
  static String? get currentEmail => _loggedInEmail;

  static final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier(false);

  // ── Global name notifier ───────────────────────────────────────────────────
  static final ValueNotifier<String> displayNameNotifier =
      ValueNotifier<String>('User');

  // ── Selected avatar notifier ───────────────────────────────────────────────
  static final ValueNotifier<String> avatarNotifier =
      ValueNotifier<String>('assets/avator/avator1.png');

  static Future<void> updateAvatar(String assetPath) async {
    avatarNotifier.value = assetPath;
    try {
      await _fileIn('avatar.txt').writeAsString(assetPath);
    } catch (_) {}
  }

  static Future<void> _loadAvatar() async {
    try {
      final file = _fileIn('avatar.txt');
      if (await file.exists()) {
        final saved = (await file.readAsString()).trim();
        if (saved.isNotEmpty) avatarNotifier.value = saved;
      }
    } catch (_) {}
  }

  static String? _cachedDisplayName;

  // ── App data directory ─────────────────────────────────────────────────────
  static String _appDir() {
    try {
      if (Platform.isWindows) {
        final localApp = Platform.environment['LOCALAPPDATA'];
        if (localApp != null && localApp.isNotEmpty) {
          final dir = '$localApp\\Speakora';
          Directory(dir).createSync(recursive: true);
          return dir;
        }
      } else if (Platform.isLinux || Platform.isMacOS) {
        final home = Platform.environment['HOME'] ?? '.';
        final dir = '$home/.speakora';
        Directory(dir).createSync(recursive: true);
        return dir;
      }
    } catch (_) {}
    return '.';
  }

  static File _fileIn(String name) {
    final dir = _appDir();
    try {
      if (dir != '.') Directory(dir).createSync(recursive: true);
    } catch (_) {}
    return File('$dir${Platform.pathSeparator}$name');
  }

  // ── File shortcuts ─────────────────────────────────────────────────────────
  static File _nameFile()    => _fileIn('display_name.txt');
  static File _sessionFile() => _fileIn('session.json');

  // ── Profile setup flag ────────────────────────────────────────────────────
  static bool _profileSetupDone = false;
  static bool get profileSetupDone => _profileSetupDone;

  static Future<void> markProfileSetupDone() async {
    _profileSetupDone = true;
    await _updateSessionProfileFlag(true);
  }

  static Future<void> _updateSessionProfileFlag(bool done) async {
    try {
      final file = _sessionFile();
      if (!await file.exists()) return;
      final raw  = await file.readAsString();
      final data = jsonDecode(raw) as Map<String, dynamic>;
      data['profileSetupDone'] = done;
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REMEMBER ME — session save / load / clear
  // ══════════════════════════════════════════════════════════════════════════

  static Future<void> _saveSession({
    required String email,
    required String token,
    required String name,
  }) async {
    try {
      final file = _sessionFile();
      final content = jsonEncode({
        'email':            email,
        'token':            token,
        'name':             name,
        'profileSetupDone': _profileSetupDone,
      });
      await file.writeAsString(content);
    } catch (e) {
      // ignore silently
    }
  }

  /// Checks session file on app start — auto-login if session exists.
  static Future<void> loadSavedSession() async {
    await _loadAvatar();
    try {
      final file = _sessionFile();
      if (!await file.exists()) return;
      final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final email = data['email'] as String? ?? '';
      final token = data['token'] as String? ?? '';
      final name  = data['name']  as String? ?? '';
      _profileSetupDone = data['profileSetupDone'] as bool? ?? false;
      if (email.isEmpty || token.isEmpty) return;

      _loggedInEmail = email;
      ApiService.restoreToken(token);
      if (name.isNotEmpty) {
        _cachedDisplayName = name;
        displayNameNotifier.value = name;
      } else {
        syncDisplayName();
      }
      isLoggedInNotifier.value = true;
    } catch (_) {}
  }

  static Future<void> _clearSession() async {
    try {
      final file = _sessionFile();
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DISPLAY NAME
  // ══════════════════════════════════════════════════════════════════════════

  static String get displayName {
    if (_cachedDisplayName != null && _cachedDisplayName!.trim().isNotEmpty) {
      return _cachedDisplayName!;
    }
    if (_loggedInEmail != null) return _extractFirstName(_loggedInEmail!);
    return 'User';
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
    try { await _nameFile().writeAsString(trimmed); } catch (_) {}
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
  // SIGN UP
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

    final error = await ApiService.signup(
      email.trim().toLowerCase(),
      password.trim(),
      name: name.trim(),
    );

    if (error == null && name.trim().isNotEmpty) {
      await updateDisplayName(name.trim());
    }
    return error;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOGIN
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (email.trim().isEmpty) return 'Email is required.';
    if (password.isEmpty) return 'Password is required.';
    final emailErr = validateEmail(email);
    if (emailErr != null) return emailErr;

    // Temp variables to capture from callback
    String _savedToken = '';
    String _savedName  = '';
    String _savedEmail = '';

    final error = await ApiService.login(
      email.trim().toLowerCase(),
      password.trim(),
      onSuccess: (token, name, userEmail) async {
        _savedToken = token;
        _savedName  = name;
        _savedEmail = userEmail;
        _loggedInEmail = userEmail;
        if (name.isNotEmpty) {
          await updateDisplayName(name);
        } else {
          syncDisplayName();
        }
        isLoggedInNotifier.value = true;
      },
    );

    if (error == null && rememberMe && _savedEmail.isNotEmpty) {
      await _saveSession(
        email: _savedEmail,
        token: _savedToken,
        name:  _savedName,
      );
    }

    return error;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GOOGLE SIGN-IN
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> signInWithGoogle() async {
    return 'Google Sign-In is not available in this version.';
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
    if (_loggedInEmail == null) return 'You must be logged in to change password.';

    return await ApiService.changePassword(
      email:           _loggedInEmail!,
      currentPassword: currentPassword.trim(),
      newPassword:     newPassword.trim(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RESET PASSWORD
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (code.trim().isEmpty) return 'Reset code is required.';
    final passErr = validatePassword(newPassword);
    if (passErr != null) return passErr;
    final confirmErr = validateConfirmPassword(newPassword, confirmPassword);
    if (confirmErr != null) return confirmErr;

    return await ApiService.resetPassword(
      email:       email.trim().toLowerCase(),
      code:        code.trim(),
      newPassword: newPassword.trim(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ══════════════════════════════════════════════════════════════════════════
  static Future<String?> sendPasswordReset({required String email}) async {
    final emailErr = validateEmail(email);
    if (emailErr != null) return emailErr;
    return await ApiService.sendPasswordReset(email: email.trim().toLowerCase());
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOGOUT
  // ══════════════════════════════════════════════════════════════════════════
  static Future<void> logout() async {
    _loggedInEmail = null;
    _cachedDisplayName = null;
    _profileSetupDone = false;
    displayNameNotifier.value = 'User';
    ApiService.clearToken();
    isLoggedInNotifier.value = false;
    await _clearSession();
    try {
      final file = _nameFile();
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  // ── Compatibility getters ──────────────────────────────────────────────────
  static bool get isSupported => true;
  static dynamic get currentUser => null;
  static String? get windowsEmail => _loggedInEmail;
  static bool get isEmailVerified => true;
}
