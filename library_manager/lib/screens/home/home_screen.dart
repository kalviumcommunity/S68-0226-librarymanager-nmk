import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Science',
    'Technology',
    'History',
    'Arts',
    'Philosophy',
  ];

  final List<_BookItem> _featuredBooks = [
    _BookItem(
      title: 'Atomic Habits',
      author: 'James Clear',
      genre: 'Self-Help',
      available: true,
      rating: '4.8',
    ),
    _BookItem(
      title: 'Dune',
      author: 'Frank Herbert',
      genre: 'Fiction',
      available: false,
      rating: '4.9',
    ),
    _BookItem(
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      genre: 'History',
      available: true,
      rating: '4.7',
    ),
    _BookItem(
      title: 'Clean Code',
      author: 'Robert C. Martin',
      genre: 'Technology',
      available: true,
      rating: '4.6',
    ),
    _BookItem(
      title: 'The Alchemist',
      author: 'Paulo Coelho',
      genre: 'Fiction',
      available: false,
      rating: '4.5',
    ),
    _BookItem(
      title: 'Deep Work',
      author: 'Cal Newport',
      genre: 'Non-Fiction',
      available: true,
      rating: '4.7',
    ),
  ];

  final List<_ActivityItem> _recentActivity = [
    _ActivityItem(
      title: 'The Pragmatic Programmer',
      action: 'Returned',
      time: '2 hrs ago',
      icon: LucideIcons.bookCheck,
    ),
    _ActivityItem(
      title: 'Thinking, Fast and Slow',
      action: 'Borrowed',
      time: '5 hrs ago',
      icon: LucideIcons.bookOpen,
    ),
    _ActivityItem(
      title: 'Design Patterns',
      action: 'Reserved',
      time: '1 day ago',
      icon: LucideIcons.bookMarked,
    ),
    _ActivityItem(
      title: '1984',
      action: 'Returned',
      time: '2 days ago',
      icon: LucideIcons.bookCheck,
    ),
  ];

  void _toggleTheme() {
    final current = themeModeNotifier.value;
    themeModeNotifier.value =
        current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
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
                  child: Icon(
                    LucideIcons.bookOpen,
                    size: 16,
                    color: colorScheme.primaryForeground,
                  ),
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
              ShadButton.ghost(
                size: ShadButtonSize.sm,
                onPressed: () {},
                child: Icon(
                  LucideIcons.bell,
                  size: 18,
                  color: colorScheme.mutedForeground,
                ),
              ),
              ShadButton.ghost(
                size: ShadButtonSize.sm,
                onPressed: _toggleTheme,
                child: Icon(
                  isDark ? LucideIcons.sun : LucideIcons.moon,
                  size: 18,
                  color: colorScheme.mutedForeground,
                ),
              ),
              const SizedBox(width: 4),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.border,
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Greeting ──────────────────────────────────
                  Text(
                    'Good morning 👋',
                    style: theme.textTheme.muted.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find your next read.',
                    style: theme.textTheme.h2.copyWith(
                      color: colorScheme.foreground,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Search ────────────────────────────────────
                  ShadInput(
                    placeholder: const Text('Search books, authors, ISBN…'),
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        LucideIcons.search,
                        size: 16,
                        color: colorScheme.mutedForeground,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Stats ─────────────────────────────────────
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Total Books',
                            value: '12,480',
                            icon: LucideIcons.library,
                            colorScheme: colorScheme,
                            theme: theme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Available',
                            value: '8,312',
                            icon: LucideIcons.circleCheckBig,
                            colorScheme: colorScheme,
                            theme: theme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Members',
                            value: '3,201',
                            icon: LucideIcons.users,
                            colorScheme: colorScheme,
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Categories ────────────────────────────────
                  Text(
                    'Categories',
                    style: theme.textTheme.h4.copyWith(
                      color: colorScheme.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Category chips horizontal scroll
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = _selectedCategory == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.border,
                        ),
                      ),
                      child: Text(
                        _categories[index],
                        style: theme.textTheme.small.copyWith(
                          color: selected
                              ? colorScheme.primaryForeground
                              : colorScheme.secondaryForeground,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),

                  // ── Featured Books header ─────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Books',
                        style: theme.textTheme.h4.copyWith(
                          color: colorScheme.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ShadButton.ghost(
                        size: ShadButtonSize.sm,
                        onPressed: () {},
                        child: Text(
                          'See all',
                          style: theme.textTheme.small.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // ── Book Grid ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: _featuredBooks.length,
              itemBuilder: (context, index) {
                final book = _featuredBooks[index];
                return _BookCard(
                  book: book,
                  colorScheme: colorScheme,
                  theme: theme,
                );
              },
            ),
          ),

          // ── Recent Activity ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Row(
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
                    child: Text(
                      'View all',
                      style: theme.textTheme.small.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            sliver: SliverList.separated(
              itemCount: _recentActivity.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: colorScheme.border,
              ),
              itemBuilder: (context, index) {
                final item = _recentActivity[index];
                return _ActivityTile(
                  item: item,
                  colorScheme: colorScheme,
                  theme: theme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  // ignore: unused_element
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.colorScheme,
    required this.theme,
  });

  final String label;
  final String value;
  final IconData icon;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.mutedForeground),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.h4.copyWith(
              color: colorScheme.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.muted.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.book,
    required this.colorScheme,
    required this.theme,
  });

  final _BookItem book;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book cover placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.bookOpen,
                  size: 36,
                  color: colorScheme.mutedForeground,
                ),
              ),
            ),
          ),
          // Book info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadBadge.outline(
                  child: Text(
                    book.genre,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(height: 6),
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
                Text(
                  book.author,
                  style: theme.textTheme.muted.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.star,
                          size: 12,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 3),
                        Text(
                          book.rating,
                          style: theme.textTheme.muted.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: book.available
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.available ? 'Available' : 'Borrowed',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: book.available
                              ? Colors.green[700]
                              : Colors.red[700],
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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.item,
    required this.colorScheme,
    required this.theme,
  });

  final _ActivityItem item;
  final ShadColorScheme colorScheme;
  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(item.icon, size: 17, color: colorScheme.mutedForeground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.small.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.action,
                  style: theme.textTheme.muted.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            item.time,
            style: theme.textTheme.muted.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class _BookItem {
  const _BookItem({
    required this.title,
    required this.author,
    required this.genre,
    required this.available,
    required this.rating,
  });

  final String title;
  final String author;
  final String genre;
  final bool available;
  final String rating;
}

class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.action,
    required this.time,
    required this.icon,
  });

  final String title;
  final String action;
  final String time;
  final IconData icon;
}
