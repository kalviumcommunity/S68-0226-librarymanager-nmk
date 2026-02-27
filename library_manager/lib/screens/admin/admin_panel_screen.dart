import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bottom_nav.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentIndex = 0;

  static const _navItems = [
    NavItem(label: 'Overview', icon: LucideIcons.chartBar, activeIcon: LucideIcons.chartBar),
    NavItem(label: 'Users', icon: LucideIcons.users, activeIcon: LucideIcons.users),
    NavItem(label: 'Reports', icon: LucideIcons.fileText, activeIcon: LucideIcons.fileText),
    NavItem(label: 'Settings', icon: LucideIcons.settings, activeIcon: LucideIcons.settings2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _OverviewTab(),
          _UsersTab(),
          _ReportsTab(),
          _AdminSettingsTab(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ── Overview Tab ──────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.background,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(LucideIcons.bookOpen, size: 16, color: colorScheme.primaryForeground),
                ),
                const SizedBox(width: 10),
                Text(
                  'LibraryOS',
                  style: theme.textTheme.h4.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple.withOpacity(0.25)),
                ),
                child: Text(
                  'Admin',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.purple[700]),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(height: 1, thickness: 1, color: colorScheme.border),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('System Overview', style: theme.textTheme.muted.copyWith(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  'Admin Panel',
                  style: theme.textTheme.h2.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 24),

                // ── System Stats ──────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.55,
                  children: [
                    _AdminStatCard(label: 'Total Books', value: '12,480', icon: LucideIcons.library, color: Colors.blue, theme: theme, colorScheme: colorScheme),
                    _AdminStatCard(label: 'Total Users', value: '3,201', icon: LucideIcons.users, color: Colors.purple, theme: theme, colorScheme: colorScheme),
                    _AdminStatCard(label: 'Active Loans', value: '847', icon: LucideIcons.bookOpen, color: Colors.orange, theme: theme, colorScheme: colorScheme),
                    _AdminStatCard(label: 'Staff Members', value: '18', icon: LucideIcons.userCheck, color: Colors.green, theme: theme, colorScheme: colorScheme),
                  ],
                ),

                const SizedBox(height: 28),

                // ── System Alerts ─────────────────────────
                Text(
                  'System Alerts',
                  style: theme.textTheme.h4.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                _AlertCard(
                  icon: LucideIcons.triangleAlert,
                  title: '48 books are overdue',
                  subtitle: 'Members have been notified by email',
                  color: Colors.orange,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 8),
                _AlertCard(
                  icon: LucideIcons.circleCheck,
                  title: 'System backup completed',
                  subtitle: 'Last backup: Today at 2:00 AM',
                  color: Colors.green,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 8),
                _AlertCard(
                  icon: LucideIcons.info,
                  title: '12 new registrations pending',
                  subtitle: 'New patron accounts awaiting review',
                  color: Colors.blue,
                  theme: theme,
                  colorScheme: colorScheme,
                ),

                const SizedBox(height: 28),

                // ── Quick Actions ─────────────────────────
                Text(
                  'Quick Actions',
                  style: theme.textTheme.h4.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _AdminActionCard(icon: LucideIcons.download, label: 'Export Data', color: Colors.blue, colorScheme: colorScheme, theme: theme),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AdminActionCard(icon: LucideIcons.refreshCw, label: 'Sync Now', color: Colors.green, colorScheme: colorScheme, theme: theme),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AdminActionCard(icon: LucideIcons.send, label: 'Notify All', color: Colors.purple, colorScheme: colorScheme, theme: theme),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Users Tab ─────────────────────────────────────────────────────────────────

class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  final _searchController = TextEditingController();

  static const _users = [
    _UserEntry(name: 'Aria Johnson', email: 'aria@example.com', role: 'patron'),
    _UserEntry(name: 'Ben Martinez', email: 'ben@example.com', role: 'staff'),
    _UserEntry(name: 'Clara Patel', email: 'clara@example.com', role: 'patron'),
    _UserEntry(name: 'Devon Wu', email: 'devon@example.com', role: 'admin'),
    _UserEntry(name: 'Elise Morgan', email: 'elise@example.com', role: 'patron'),
    _UserEntry(name: 'Finn Torres', email: 'finn@example.com', role: 'staff'),
    _UserEntry(name: 'Grace Kim', email: 'grace@example.com', role: 'patron'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'User Management',
          style: theme.textTheme.h4.copyWith(
            color: colorScheme.foreground,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          ShadButton.ghost(
            size: ShadButtonSize.sm,
            onPressed: () {},
            child: Icon(LucideIcons.userPlus, size: 18, color: colorScheme.foreground),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: colorScheme.border),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: ShadInput(
              controller: _searchController,
              placeholder: const Text('Search users…'),
              leading: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(LucideIcons.search, size: 16, color: colorScheme.mutedForeground),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: _users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _UserCard(user: _users[i], theme: theme, colorScheme: colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reports Tab ───────────────────────────────────────────────────────────────

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  static const _logs = [
    _LogEntry(action: 'User Ben Martinez upgraded to Staff', time: '5 min ago', icon: LucideIcons.userCog, type: 'info'),
    _LogEntry(action: '3 overdue reminders sent automatically', time: '1 hr ago', icon: LucideIcons.bell, type: 'warn'),
    _LogEntry(action: 'Book catalog synced — 12 records updated', time: '3 hrs ago', icon: LucideIcons.refreshCw, type: 'success'),
    _LogEntry(action: 'Failed login attempt from unknown device', time: '4 hrs ago', icon: LucideIcons.shieldAlert, type: 'error'),
    _LogEntry(action: 'New patron Aria Johnson registered', time: '6 hrs ago', icon: LucideIcons.userPlus, type: 'info'),
    _LogEntry(action: 'System backup completed successfully', time: '8 hrs ago', icon: LucideIcons.hardDrive, type: 'success'),
    _LogEntry(action: '2 books marked as damaged by Staff', time: '1 day ago', icon: LucideIcons.circleAlert, type: 'warn'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Activity Reports',
          style: theme.textTheme.h4.copyWith(
            color: colorScheme.foreground,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          ShadButton.ghost(
            size: ShadButtonSize.sm,
            onPressed: () {},
            child: Icon(LucideIcons.download, size: 18, color: colorScheme.foreground),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: colorScheme.border),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _logs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => _LogCard(entry: _logs[i], theme: theme, colorScheme: colorScheme),
      ),
    );
  }
}

// ── Admin Settings Tab ────────────────────────────────────────────────────────

class _AdminSettingsTab extends StatelessWidget {
  const _AdminSettingsTab();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: theme.textTheme.h4.copyWith(
            color: colorScheme.foreground,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: colorScheme.border),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          final user = auth.user;
          if (user == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Admin Profile Card ──────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(user.name, style: theme.textTheme.h3.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(user.email, style: theme.textTheme.muted.copyWith(fontSize: 13)),
                      const SizedBox(height: 10),
                      _RoleBadge(role: user.role),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Appearance ──────────────────────────
                Text('Appearance', style: theme.textTheme.small.copyWith(color: colorScheme.mutedForeground, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                ShadCard(
                  padding: EdgeInsets.zero,
                  child: _SettingsTile(
                    icon: isDark ? LucideIcons.sun : LucideIcons.moon,
                    label: isDark ? 'Light Mode' : 'Dark Mode',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) {
                        final current = themeModeNotifier.value;
                        themeModeNotifier.value = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                      },
                      activeColor: colorScheme.primary,
                    ),
                    colorScheme: colorScheme,
                    theme: theme,
                    showDivider: false,
                  ),
                ),

                const SizedBox(height: 16),

                // ── System ──────────────────────────────
                Text('System', style: theme.textTheme.small.copyWith(color: colorScheme.mutedForeground, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                ShadCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: LucideIcons.database,
                        label: 'Database Settings',
                        trailing: Icon(LucideIcons.chevronRight, size: 16, color: colorScheme.mutedForeground),
                        colorScheme: colorScheme,
                        theme: theme,
                        showDivider: true,
                        onTap: () {},
                      ),
                      _SettingsTile(
                        icon: LucideIcons.bell,
                        label: 'Notification Rules',
                        trailing: Icon(LucideIcons.chevronRight, size: 16, color: colorScheme.mutedForeground),
                        colorScheme: colorScheme,
                        theme: theme,
                        showDivider: true,
                        onTap: () {},
                      ),
                      _SettingsTile(
                        icon: LucideIcons.shield,
                        label: 'Security Settings',
                        trailing: Icon(LucideIcons.chevronRight, size: 16, color: colorScheme.mutedForeground),
                        colorScheme: colorScheme,
                        theme: theme,
                        showDivider: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ShadButton.destructive(
                    onPressed: () => context.read<AuthProvider>().logout(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.logOut, size: 16),
                        SizedBox(width: 8),
                        Text('Sign out'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Center(child: Text('LibraryOS v1.0.0', style: theme.textTheme.muted.copyWith(fontSize: 11))),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color.withOpacity(0.8)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: theme.textTheme.h4.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w700)),
              Text(label, style: theme.textTheme.muted.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.theme,
    required this.colorScheme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color.withOpacity(0.8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.small.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.muted.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  const _AdminActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.colorScheme,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final Color color;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ShadCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: color.withOpacity(0.8)),
            ),
            const SizedBox(height: 8),
            Text(label, style: theme.textTheme.muted.copyWith(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.theme, required this.colorScheme});

  final _UserEntry user;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  Color get _roleColor {
    switch (user.role) {
      case 'admin': return Colors.purple;
      case 'staff': return Colors.blue;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _roleColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _roleColor.withOpacity(0.8)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: theme.textTheme.small.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(user.email, style: theme.textTheme.muted.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _roleColor.withOpacity(0.2)),
                ),
                child: Text(
                  user.role,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _roleColor.withOpacity(0.85)),
                ),
              ),
              const SizedBox(width: 4),
              ShadButton.ghost(
                size: ShadButtonSize.sm,
                onPressed: () {},
                child: Icon(LucideIcons.ellipsis, size: 16, color: colorScheme.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({required this.entry, required this.theme, required this.colorScheme});

  final _LogEntry entry;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  Color get _typeColor {
    switch (entry.type) {
      case 'error': return Colors.red;
      case 'warn': return Colors.orange;
      case 'success': return Colors.green;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(entry.icon, size: 16, color: _typeColor.withOpacity(0.8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.action, style: theme.textTheme.small.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w400), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(entry.time, style: theme.textTheme.muted.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final UserRole role;

  Color get _color {
    switch (role) {
      case UserRole.admin: return Colors.purple;
      case UserRole.staff: return Colors.blue;
      case UserRole.patron: return Colors.green;
    }
  }

  String get _label {
    switch (role) {
      case UserRole.admin: return 'Admin';
      case UserRole.staff: return 'Staff';
      case UserRole.patron: return 'Patron';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        _label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _color.withOpacity(0.85)),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.colorScheme,
    required this.theme,
    required this.showDivider,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.foreground),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: theme.textTheme.small.copyWith(color: colorScheme.foreground))),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, indent: 46, color: colorScheme.border),
      ],
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class _UserEntry {
  final String name;
  final String email;
  final String role;
  const _UserEntry({required this.name, required this.email, required this.role});
}

class _LogEntry {
  final String action;
  final String time;
  final IconData icon;
  final String type;
  const _LogEntry({required this.action, required this.time, required this.icon, required this.type});
}
