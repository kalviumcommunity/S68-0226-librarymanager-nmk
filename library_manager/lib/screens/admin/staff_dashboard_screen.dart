import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bottom_nav.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  int _currentIndex = 0;

  static const _navItems = [
    NavItem(label: 'Dashboard', icon: LucideIcons.layoutDashboard, activeIcon: LucideIcons.layoutDashboard),
    NavItem(label: 'Catalog', icon: LucideIcons.library, activeIcon: LucideIcons.library),
    NavItem(label: 'Members', icon: LucideIcons.users, activeIcon: LucideIcons.users),
    NavItem(label: 'Profile', icon: LucideIcons.user, activeIcon: LucideIcons.userCheck),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _StaffDashboardTab(),
          _CatalogTab(),
          _MembersTab(),
          _StaffProfileTab(),
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

// ── Dashboard Tab ─────────────────────────────────────────────────────────────

class _StaffDashboardTab extends StatelessWidget {
  const _StaffDashboardTab();

  static const _activity = [
    _ActivityEntry(name: 'Aria Johnson', action: 'Borrowed', title: 'Atomic Habits', time: '10 min ago', icon: LucideIcons.bookOpen),
    _ActivityEntry(name: 'Ben Martinez', action: 'Returned', title: 'Dune', time: '1 hr ago', icon: LucideIcons.bookCheck),
    _ActivityEntry(name: 'Clara Patel', action: 'Reserved', title: 'Clean Code', time: '2 hrs ago', icon: LucideIcons.bookMarked),
    _ActivityEntry(name: 'Devon Wu', action: 'Borrowed', title: 'Sapiens', time: '3 hrs ago', icon: LucideIcons.bookOpen),
    _ActivityEntry(name: 'Elise Morgan', action: 'Returned', title: 'Deep Work', time: '5 hrs ago', icon: LucideIcons.bookCheck),
  ];

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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withOpacity(0.25)),
                ),
                child: Text(
                  'Staff',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blue[700]),
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
                // ── Greeting ──────────────────────────────
                Text('Good morning 👋', style: theme.textTheme.muted.copyWith(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  "Staff Dashboard",
                  style: theme.textTheme.h2.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Stats Grid ────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.55,
                  children: [
                    _StatsCard(label: 'Checked Out', value: '24', icon: LucideIcons.bookOpen, color: Colors.blue, theme: theme, colorScheme: colorScheme),
                    _StatsCard(label: 'Due Today', value: '8', icon: LucideIcons.calendarClock, color: Colors.orange, theme: theme, colorScheme: colorScheme),
                    _StatsCard(label: 'Overdue', value: '12', icon: LucideIcons.circleAlert, color: Colors.red, theme: theme, colorScheme: colorScheme),
                    _StatsCard(label: 'New Returns', value: '6', icon: LucideIcons.bookCheck, color: Colors.green, theme: theme, colorScheme: colorScheme),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Quick Actions ─────────────────────────
                Text(
                  'Quick Actions',
                  style: theme.textTheme.h4.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: LucideIcons.scanLine,
                        label: 'Check Out',
                        color: Colors.blue,
                        colorScheme: colorScheme,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: LucideIcons.undo2,
                        label: 'Return Book',
                        color: Colors.green,
                        colorScheme: colorScheme,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: LucideIcons.userPlus,
                        label: 'Add Member',
                        color: Colors.purple,
                        colorScheme: colorScheme,
                        theme: theme,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Recent Activity ───────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: theme.textTheme.h4.copyWith(
                        color: colorScheme.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ShadButton.ghost(
                      size: ShadButtonSize.sm,
                      onPressed: () {},
                      child: Text('See all', style: theme.textTheme.small.copyWith(color: colorScheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList.separated(
              itemCount: _activity.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: colorScheme.border),
              itemBuilder: (_, i) => _ActivityTile(entry: _activity[i], theme: theme, colorScheme: colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Catalog Tab ───────────────────────────────────────────────────────────────

class _CatalogTab extends StatefulWidget {
  const _CatalogTab();

  @override
  State<_CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<_CatalogTab> {
  final _searchController = TextEditingController();

  static const _books = [
    _BookEntry(title: 'Atomic Habits', author: 'James Clear', genre: 'Self-Help', total: 5, available: 3),
    _BookEntry(title: 'Dune', author: 'Frank Herbert', genre: 'Fiction', total: 4, available: 0),
    _BookEntry(title: 'Sapiens', author: 'Yuval Noah Harari', genre: 'History', total: 6, available: 4),
    _BookEntry(title: 'Clean Code', author: 'Robert C. Martin', genre: 'Technology', total: 3, available: 2),
    _BookEntry(title: 'Deep Work', author: 'Cal Newport', genre: 'Non-Fiction', total: 4, available: 3),
    _BookEntry(title: 'The Alchemist', author: 'Paulo Coelho', genre: 'Fiction', total: 7, available: 2),
    _BookEntry(title: 'Design Patterns', author: 'Gang of Four', genre: 'Technology', total: 2, available: 1),
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
          'Book Catalog',
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
            child: Icon(LucideIcons.plus, size: 20, color: colorScheme.foreground),
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
              placeholder: const Text('Search catalog…'),
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
              itemCount: _books.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _BookEntryCard(book: _books[i], theme: theme, colorScheme: colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Members Tab ───────────────────────────────────────────────────────────────

class _MembersTab extends StatefulWidget {
  const _MembersTab();

  @override
  State<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<_MembersTab> {
  final _searchController = TextEditingController();

  static const _members = [
    _MemberEntry(name: 'Aria Johnson', email: 'aria@example.com', borrowed: 2, status: 'Active'),
    _MemberEntry(name: 'Ben Martinez', email: 'ben@example.com', borrowed: 0, status: 'Active'),
    _MemberEntry(name: 'Clara Patel', email: 'clara@example.com', borrowed: 3, status: 'Active'),
    _MemberEntry(name: 'Devon Wu', email: 'devon@example.com', borrowed: 1, status: 'Suspended'),
    _MemberEntry(name: 'Elise Morgan', email: 'elise@example.com', borrowed: 2, status: 'Active'),
    _MemberEntry(name: 'Finn Torres', email: 'finn@example.com', borrowed: 4, status: 'Active'),
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
          'Members',
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
              placeholder: const Text('Search members…'),
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
              itemCount: _members.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _MemberCard(member: _members[i], theme: theme, colorScheme: colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Staff Profile Tab ─────────────────────────────────────────────────────────

class _StaffProfileTab extends StatelessWidget {
  const _StaffProfileTab();

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
          'Profile',
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
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue,
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
                Text('Preferences', style: theme.textTheme.small.copyWith(color: colorScheme.mutedForeground, fontWeight: FontWeight.w500)),
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({
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
              Text(
                value,
                style: theme.textTheme.h4.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w700),
              ),
              Text(label, style: theme.textTheme.muted.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
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
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: color.withOpacity(0.8)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.muted.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry, required this.theme, required this.colorScheme});

  final _ActivityEntry entry;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(9)),
            child: Icon(entry.icon, size: 16, color: colorScheme.mutedForeground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.small.copyWith(color: colorScheme.foreground),
                    children: [
                      TextSpan(text: entry.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ' ${entry.action.toLowerCase()} '),
                      TextSpan(text: entry.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(entry.time, style: theme.textTheme.muted.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _BookEntryCard extends StatelessWidget {
  const _BookEntryCard({required this.book, required this.theme, required this.colorScheme});

  final _BookEntry book;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 56,
            decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(8)),
            child: Icon(LucideIcons.bookOpen, size: 20, color: colorScheme.mutedForeground),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: theme.textTheme.small.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(book.author, style: theme.textTheme.muted.copyWith(fontSize: 12)),
                const SizedBox(height: 4),
                ShadBadge.outline(child: Text(book.genre, style: const TextStyle(fontSize: 10))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${book.available}/${book.total}',
                style: theme.textTheme.small.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w600),
              ),
              Text('available', style: theme.textTheme.muted.copyWith(fontSize: 10)),
              const SizedBox(height: 6),
              ShadButton.ghost(
                size: ShadButtonSize.sm,
                onPressed: () {},
                child: Icon(LucideIcons.pencil, size: 14, color: colorScheme.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member, required this.theme, required this.colorScheme});

  final _MemberEntry member;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final isActive = member.status == 'Active';
    return ShadCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: theme.textTheme.small.copyWith(color: colorScheme.foreground, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(member.email, style: theme.textTheme.muted.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  member.status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isActive ? Colors.green[700] : Colors.red[700]),
                ),
              ),
              const SizedBox(height: 4),
              Text('${member.borrowed} books', style: theme.textTheme.muted.copyWith(fontSize: 11)),
            ],
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
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: null,
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

class _ActivityEntry {
  final String name;
  final String action;
  final String title;
  final String time;
  final IconData icon;

  const _ActivityEntry({
    required this.name,
    required this.action,
    required this.title,
    required this.time,
    required this.icon,
  });
}

class _BookEntry {
  final String title;
  final String author;
  final String genre;
  final int total;
  final int available;

  const _BookEntry({
    required this.title,
    required this.author,
    required this.genre,
    required this.total,
    required this.available,
  });
}

class _MemberEntry {
  final String name;
  final String email;
  final int borrowed;
  final String status;

  const _MemberEntry({
    required this.name,
    required this.email,
    required this.borrowed,
    required this.status,
  });
}
