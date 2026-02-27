import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../home/home_screen.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bottom_nav.dart';

class PatronHomeScreen extends StatefulWidget {
  const PatronHomeScreen({super.key});

  @override
  State<PatronHomeScreen> createState() => _PatronHomeScreenState();
}

class _PatronHomeScreenState extends State<PatronHomeScreen> {
  int _currentIndex = 0;

  static const _navItems = [
    NavItem(
      label: 'Home',
      icon: LucideIcons.house,
      activeIcon: LucideIcons.house,
    ),
    NavItem(
      label: 'Search',
      icon: LucideIcons.search,
      activeIcon: LucideIcons.search,
    ),
    NavItem(
      label: 'My Books',
      icon: LucideIcons.bookMarked,
      activeIcon: LucideIcons.bookMarked,
    ),
    NavItem(
      label: 'Profile',
      icon: LucideIcons.user,
      activeIcon: LucideIcons.userCheck,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          _SearchTab(),
          _BorrowedTab(),
          _PatronProfileTab(),
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

// ── Search Tab ────────────────────────────────────────────────────────────────

class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _searchController = TextEditingController();
  int _selectedGenre = 0;

  final _genres = [
    'All', 'Fiction', 'Non-Fiction', 'Science',
    'Technology', 'History', 'Arts', 'Philosophy',
  ];

  final _results = const [
    _SearchResult(title: 'Atomic Habits', author: 'James Clear', genre: 'Self-Help', available: true, rating: '4.8'),
    _SearchResult(title: 'Dune', author: 'Frank Herbert', genre: 'Fiction', available: false, rating: '4.9'),
    _SearchResult(title: 'Sapiens', author: 'Yuval Noah Harari', genre: 'History', available: true, rating: '4.7'),
    _SearchResult(title: 'Clean Code', author: 'Robert C. Martin', genre: 'Technology', available: true, rating: '4.6'),
    _SearchResult(title: 'The Alchemist', author: 'Paulo Coelho', genre: 'Fiction', available: false, rating: '4.5'),
    _SearchResult(title: 'Deep Work', author: 'Cal Newport', genre: 'Non-Fiction', available: true, rating: '4.7'),
    _SearchResult(title: 'Design Patterns', author: 'Gang of Four', genre: 'Technology', available: true, rating: '4.5'),
    _SearchResult(title: '1984', author: 'George Orwell', genre: 'Fiction', available: true, rating: '4.8'),
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
          'Search',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: ShadInput(
              controller: _searchController,
              placeholder: const Text('Search books, authors, ISBN…'),
              leading: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(LucideIcons.search, size: 16, color: colorScheme.mutedForeground),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _genres.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _selectedGenre == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGenre = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? colorScheme.primary : colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? colorScheme.primary : colorScheme.border,
                      ),
                    ),
                    child: Text(
                      _genres[i],
                      style: theme.textTheme.small.copyWith(
                        color: selected
                            ? colorScheme.primaryForeground
                            : colorScheme.secondaryForeground,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.74,
              ),
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final book = _results[i];
                return _BookResultCard(book: book, theme: theme, colorScheme: colorScheme);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Borrowed Tab ──────────────────────────────────────────────────────────────

class _BorrowedTab extends StatelessWidget {
  const _BorrowedTab();

  static const _borrowed = [
    _BorrowedItem(title: 'Atomic Habits', author: 'James Clear', dueDate: 'Mar 5, 2026', status: 'On Loan'),
    _BorrowedItem(title: 'Deep Work', author: 'Cal Newport', dueDate: 'Mar 10, 2026', status: 'Due Soon'),
    _BorrowedItem(title: 'The Phoenix Project', author: 'Gene Kim', dueDate: 'Feb 28, 2026', status: 'Overdue'),
  ];

  static const _history = [
    _BorrowedItem(title: 'Sapiens', author: 'Yuval Noah Harari', dueDate: 'Returned Feb 12', status: 'Returned'),
    _BorrowedItem(title: 'Clean Code', author: 'Robert C. Martin', dueDate: 'Returned Jan 30', status: 'Returned'),
    _BorrowedItem(title: 'Design Patterns', author: 'Gang of Four', dueDate: 'Returned Jan 15', status: 'Returned'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: colorScheme.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'My Books',
            style: theme.textTheme.h4.copyWith(
              color: colorScheme.foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            indicatorWeight: 2,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.mutedForeground,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            dividerColor: colorScheme.border,
            tabs: const [
              Tab(text: 'Current'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BorrowedList(items: _borrowed, theme: theme, colorScheme: colorScheme),
            _BorrowedList(items: _history, theme: theme, colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }
}

class _BorrowedList extends StatelessWidget {
  const _BorrowedList({required this.items, required this.theme, required this.colorScheme});

  final List<_BorrowedItem> items;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.bookOpen, size: 40, color: colorScheme.mutedForeground),
            const SizedBox(height: 12),
            Text('No books here', style: theme.textTheme.muted),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _BorrowedCard(
        item: items[i],
        theme: theme,
        colorScheme: colorScheme,
      ),
    );
  }
}

class _BorrowedCard extends StatelessWidget {
  const _BorrowedCard({required this.item, required this.theme, required this.colorScheme});

  final _BorrowedItem item;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  Color get _statusColor {
    switch (item.status) {
      case 'Overdue':
        return Colors.red;
      case 'Due Soon':
        return Colors.orange;
      case 'Returned':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(LucideIcons.bookOpen, size: 20, color: colorScheme.mutedForeground),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.small.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.author,
                  style: theme.textTheme.muted.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.calendarDays, size: 12, color: colorScheme.mutedForeground),
                    const SizedBox(width: 4),
                    Text(item.dueDate, style: theme.textTheme.muted.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _statusColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Patron Profile Tab ────────────────────────────────────────────────────────

class _PatronProfileTab extends StatelessWidget {
  const _PatronProfileTab();

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
                // ── User Card ────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primaryForeground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.name,
                        style: theme.textTheme.h3.copyWith(
                          color: colorScheme.foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: theme.textTheme.muted.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      _RoleBadge(role: user.role),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Settings Section ─────────────────────────
                Text(
                  'Preferences',
                  style: theme.textTheme.small.copyWith(
                    color: colorScheme.mutedForeground,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                ShadCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: isDark ? LucideIcons.sun : LucideIcons.moon,
                        label: isDark ? 'Light Mode' : 'Dark Mode',
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) {
                            final current = themeModeNotifier.value;
                            themeModeNotifier.value = current == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                          },
                          activeColor: colorScheme.primary,
                        ),
                        colorScheme: colorScheme,
                        theme: theme,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Account Section ──────────────────────────
                Text(
                  'Account',
                  style: theme.textTheme.small.copyWith(
                    color: colorScheme.mutedForeground,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                ShadCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: LucideIcons.user,
                        label: 'Edit Profile',
                        trailing: Icon(LucideIcons.chevronRight, size: 16, color: colorScheme.mutedForeground),
                        colorScheme: colorScheme,
                        theme: theme,
                        showDivider: true,
                        onTap: () {},
                      ),
                      _SettingsTile(
                        icon: LucideIcons.shield,
                        label: 'Privacy & Security',
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

                // ── Sign Out ─────────────────────────────────
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

                Center(
                  child: Text(
                    'LibraryOS v1.0.0',
                    style: theme.textTheme.muted.copyWith(fontSize: 11),
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

// ── Shared profile sub-widgets ────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final UserRole role;

  Color get _color {
    switch (role) {
      case UserRole.admin:
        return Colors.purple;
      case UserRole.staff:
        return Colors.blue;
      case UserRole.patron:
        return Colors.green;
    }
  }

  String get _label {
    switch (role) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color.withOpacity(0.85),
        ),
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
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.small.copyWith(
                      color: colorScheme.foreground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 46,
            color: colorScheme.border,
          ),
      ],
    );
  }
}

// ── Data models for tabs ──────────────────────────────────────────────────────

class _SearchResult {
  final String title;
  final String author;
  final String genre;
  final bool available;
  final String rating;

  const _SearchResult({
    required this.title,
    required this.author,
    required this.genre,
    required this.available,
    required this.rating,
  });
}

class _BorrowedItem {
  final String title;
  final String author;
  final String dueDate;
  final String status;

  const _BorrowedItem({
    required this.title,
    required this.author,
    required this.dueDate,
    required this.status,
  });
}

class _BookResultCard extends StatelessWidget {
  const _BookResultCard({
    required this.book,
    required this.theme,
    required this.colorScheme,
  });

  final _SearchResult book;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Center(
                child: Icon(LucideIcons.bookOpen, size: 34, color: colorScheme.mutedForeground),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadBadge.outline(child: Text(book.genre, style: const TextStyle(fontSize: 10))),
                const SizedBox(height: 5),
                Text(
                  book.title,
                  style: theme.textTheme.small.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(book.author, style: theme.textTheme.muted.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.star, size: 11, color: Colors.amber[600]),
                        const SizedBox(width: 3),
                        Text(book.rating, style: theme.textTheme.muted.copyWith(fontSize: 11)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: book.available ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.available ? 'Free' : 'Taken',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: book.available ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
