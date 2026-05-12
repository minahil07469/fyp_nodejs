import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/support/support_screen.dart';
import '../screens/profile/profile_screen.dart';

/// Bottom nav index mapping:
/// Home=0, Progress=1, Support=2, Profile=3
void navigateTo(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
      break;
    case 1:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProgressScreen()),
        (_) => false,
      );
      break;
    case 2:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SupportScreen()),
        (_) => false,
      );
      break;
    case 3:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
        (_) => false,
      );
      break;
  }
}
