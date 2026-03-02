import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

// ── Public entry point ────────────────────────────────────────────────────────

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.background,
      width: 290,
      child: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            final user = auth.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Scrollable body ────────────────────────────
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _DrawerHeader(theme: theme, colorScheme: colorScheme),

                      // ── User card ──────────────────────────
                      if (user != null) ...[
                        _UserCard(
                          user: user,
                          theme: theme,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ── Appearance ─────────────────────────
                      _SectionTitle(
                        label: 'Appearance',
                        theme: theme,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeModeNotifier,
                        builder: (_, mode, __) => _ThemePicker(
                          currentMode: mode,
                          theme: theme,
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Quick Links ────────────────────────
                      _SectionTitle(
                        label: 'Quick Links',
                        theme: theme,
                        colorScheme: colorScheme,
                      ),
                      if (user?.role == UserRole.admin) ...[
                        _DrawerItem(
                          icon: LucideIcons.layoutDashboard,
                          label: 'Admin Dashboard',
                          colorScheme: colorScheme,
                          theme: theme,
                          onTap: () => Navigator.pop(context),
                        ),
                        _DrawerItem(
                          icon: LucideIcons.users,
                          label: 'Manage Users',
                          colorScheme: colorScheme,
                          theme: theme,
                          badge: '12',
                          onTap: () => Navigator.pop(context),
                        ),
                        _DrawerItem(
                          icon: LucideIcons.fileText,
                          label: 'Reports & Logs',
                          colorScheme: colorScheme,
                          theme: theme,
                          onTap: () => Navigator.pop(context),
                        ),
                      ] else ...[
                        _DrawerItem(
                          icon: LucideIcons.bookOpen,
                          label: 'Browse Catalog',
                          colorScheme: colorScheme,
                          theme: theme,
                          onTap: () => Navigator.pop(context),
                        ),
                        _DrawerItem(
                          icon: LucideIcons.bookMarked,
                          label: 'Borrowed Books',
                          colorScheme: colorScheme,
                          theme: theme,
                          onTap: () => Navigator.pop(context),
                        ),
                        _DrawerItem(
                          icon: LucideIcons.heart,
                          label: 'Wishlist',
                          colorScheme: colorScheme,
                          theme: theme,
                          badge: '3',
                          onTap: () => Navigator.pop(context),
                        ),
                        _DrawerItem(
                          icon: LucideIcons.history,
                          label: 'Reading History',
                          colorScheme: colorScheme,
                          theme: theme,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // ── Notifications ──────────────────────
                      _SectionTitle(
                        label: 'Notifications',
                        theme: theme,
                        colorScheme: colorScheme,
                      ),
                      _NotificationToggles(
                        theme: theme,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 20),

                      // ── Support ────────────────────────────
                      _SectionTitle(
                        label: 'Support',
                        theme: theme,
                        colorScheme: colorScheme,
                      ),
                      _DrawerItem(
                        icon: LucideIcons.info,
                        label: 'About LibraryOS',
                        colorScheme: colorScheme,
                        theme: theme,
                        onTap: () {
                          Navigator.pop(context);
                          _showAboutDialog(context);
                        },
                      ),
                      _DrawerItem(
                        icon: LucideIcons.messageCircle,
                        label: 'Help & FAQ',
                        colorScheme: colorScheme,
                        theme: theme,
                        onTap: () => Navigator.pop(context),
                      ),
                      _DrawerItem(
                        icon: LucideIcons.star,
                        label: 'Rate this App',
                        colorScheme: colorScheme,
                        theme: theme,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                // ── Footer: Sign out ───────────────────────────
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colorScheme.border),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ShadButton.destructive(
                          onPressed: () {
                            Navigator.pop(context);
                            auth.logout();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.logOut, size: 15),
                              SizedBox(width: 8),
                              Text('Sign out'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'LibraryOS v1.0.0',
                        style: theme.textTheme.muted.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final theme = ShadTheme.of(ctx);
        final colorScheme = theme.colorScheme;
        return AlertDialog(
          backgroundColor: colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  LucideIcons.bookOpen,
                  size: 18,
                  color: colorScheme.primaryForeground,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LibraryOS',
                    style: theme.textTheme.h4.copyWith(
                      color: colorScheme.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: theme.textTheme.muted.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'A modern, full-featured library management system built with Flutter and Firebase.',
                style: theme.textTheme.small.copyWith(
                  color: colorScheme.foreground,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 14),
              Divider(color: colorScheme.border),
              const SizedBox(height: 10),
              Text(
                '© 2026 LibraryOS. All rights reserved.',
                style: theme.textTheme.muted.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            ShadButton(
              size: ShadButtonSize.sm,
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// ── Drawer Header ─────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.theme, required this.colorScheme});

  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.bookOpen,
              size: 18,
              color: colorScheme.primaryForeground,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LibraryOS',
                style: theme.textTheme.h4.copyWith(
                  color: colorScheme.foreground,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Library Management',
                style: theme.textTheme.muted.copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── User Card ─────────────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.theme,
    required this.colorScheme,
  });

  final UserModel user;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  Color get _roleColor {
    switch (user.role) {
      case UserRole.admin:
        return Colors.purple;
      case UserRole.staff:
        return Colors.blue;
      case UserRole.patron:
        return Colors.green;
    }
  }

  String get _roleLabel {
    switch (user.role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.staff:
        return 'Staff';
      case UserRole.patron:
        return 'Patron';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primaryForeground,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: theme.textTheme.small.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: theme.textTheme.muted.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _roleColor.withOpacity(0.3)),
            ),
            child: Text(
              _roleLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _roleColor.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme Picker ──────────────────────────────────────────────────────────────

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({
    required this.currentMode,
    required this.theme,
    required this.colorScheme,
  });

  final ThemeMode currentMode;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.border),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            _ThemeOption(
              label: 'Light',
              icon: LucideIcons.sun,
              isSelected: currentMode == ThemeMode.light,
              onTap: () => themeModeNotifier.value = ThemeMode.light,
              theme: theme,
              colorScheme: colorScheme,
            ),
            _ThemeOption(
              label: 'System',
              icon: LucideIcons.monitor,
              isSelected: currentMode == ThemeMode.system,
              onTap: () => themeModeNotifier.value = ThemeMode.system,
              theme: theme,
              colorScheme: colorScheme,
            ),
            _ThemeOption(
              label: 'Dark',
              icon: LucideIcons.moon,
              isSelected: currentMode == ThemeMode.dark,
              onTap: () => themeModeNotifier.value = ThemeMode.dark,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.colorScheme,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? colorScheme.primaryForeground
                    : colorScheme.mutedForeground,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primaryForeground
                      : colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.label,
    required this.theme,
    required this.colorScheme,
  });

  final String label;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.muted.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Drawer Item ───────────────────────────────────────────────────────────────

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.theme,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: colorScheme.border),
              ),
              child: Icon(icon, size: 16, color: colorScheme.foreground),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.small.copyWith(
                  color: colorScheme.foreground,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ] else ...[
              Icon(
                LucideIcons.chevronRight,
                size: 14,
                color: colorScheme.mutedForeground,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Notification Toggles ──────────────────────────────────────────────────────

class _NotificationToggles extends StatefulWidget {
  const _NotificationToggles({
    required this.theme,
    required this.colorScheme,
  });

  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  State<_NotificationToggles> createState() => _NotificationTogglesState();
}

class _NotificationTogglesState extends State<_NotificationToggles> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _dueDateEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ToggleTile(
          icon: LucideIcons.bell,
          label: 'Push Notifications',
          value: _pushEnabled,
          onChanged: (v) => setState(() => _pushEnabled = v),
          theme: widget.theme,
          colorScheme: widget.colorScheme,
        ),
        _ToggleTile(
          icon: LucideIcons.mail,
          label: 'Email Reminders',
          value: _emailEnabled,
          onChanged: (v) => setState(() => _emailEnabled = v),
          theme: widget.theme,
          colorScheme: widget.colorScheme,
        ),
        _ToggleTile(
          icon: LucideIcons.calendarDays,
          label: 'Due Date Alerts',
          value: _dueDateEnabled,
          onChanged: (v) => setState(() => _dueDateEnabled = v),
          theme: widget.theme,
          colorScheme: widget.colorScheme,
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.theme,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: colorScheme.border),
            ),
            child: Icon(icon, size: 16, color: colorScheme.foreground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.small.copyWith(
                color: colorScheme.foreground,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
