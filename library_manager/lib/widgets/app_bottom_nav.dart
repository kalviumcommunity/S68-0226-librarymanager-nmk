import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        border: Border(
          top: BorderSide(color: colorScheme.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(items.length, (i) {
              final isSelected = i == currentIndex;
              final item = items[i];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 20,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.mutedForeground,
                          letterSpacing: 0,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
