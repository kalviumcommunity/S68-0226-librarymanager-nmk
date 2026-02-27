import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'main.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/auth_gate.dart';
import 'services/auth_service.dart';

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (ctx) => AuthProvider(ctx.read<AuthService>()),
          update: (ctx, service, previous) =>
              previous ?? AuthProvider(service),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, _) {
          return ShadApp(
            title: 'LibraryOS',
            themeMode: themeMode,
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: const ShadZincColorScheme.light(),
            ),
            darkTheme: ShadThemeData(
              brightness: Brightness.dark,
              colorScheme: const ShadZincColorScheme.dark(),
            ),
            home: const AuthGate(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
