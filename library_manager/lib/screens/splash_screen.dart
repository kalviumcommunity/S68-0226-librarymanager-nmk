import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                LucideIcons.bookOpen,
                size: 34,
                color: colorScheme.primaryForeground,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'LibraryOS',
              style: theme.textTheme.h2.copyWith(
                color: colorScheme.foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your digital library, always open.',
              style: theme.textTheme.muted.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
