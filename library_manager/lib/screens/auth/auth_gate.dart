import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../splash_screen.dart';
import '../auth/login_screen.dart';
import '../member/patron_home_screen.dart';
import '../admin/staff_dashboard_screen.dart';
import '../admin/admin_panel_screen.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        switch (auth.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const SplashScreen();

          case AuthStatus.authenticated:
            return _routeByRole(auth.user!.role);

          case AuthStatus.unauthenticated:
          case AuthStatus.error:
            return const LoginScreen();
        }
      },
    );
  }

  Widget _routeByRole(UserRole role) {
    switch (role) {
      case UserRole.patron:
        return const PatronHomeScreen();
      case UserRole.staff:
        return const StaffDashboardScreen();
      case UserRole.admin:
        return const AdminPanelScreen();
    }
  }
}
