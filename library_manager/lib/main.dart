import 'package:flutter/material.dart';
import 'app.dart';

// Global theme notifier — imported by all screens that need theme toggling.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void main() {
  runApp(const LibraryApp());
}
