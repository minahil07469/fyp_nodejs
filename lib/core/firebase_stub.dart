// Stub for platforms that don't support Firebase (Windows, Linux, macOS desktop)
// This file is used when Firebase packages are not available

class FirebaseStub {
  static bool get isSupported => false;
}
