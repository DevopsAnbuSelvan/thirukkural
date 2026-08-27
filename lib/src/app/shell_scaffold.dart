import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/responsive.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const _destinations = [
    _NavItem(label: 'முகப்பு', icon: Icons.home_outlined, selectedIcon: Icons.home, path: '/home'),
    _NavItem(label: 'அதிகாரங்கள்', icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, path: '/chapters'),
    _NavItem(label: 'தேடல்', icon: Icons.search, selectedIcon: Icons.search, path: '/search'),
    _NavItem(label: 'பிடித்தவை', icon: Icons.favorite_border, selectedIcon: Icons.favorite, path: '/favorites'),
    _NavItem(label: 'அமைப்புகள்', icon: Icons.settings_outlined, selectedIcon: Icons.settings, path: '/settings'),
  ];

  int get _selectedIndex {
    final index = _destinations.indexWhere((item) => location.startsWith(item.path));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context) || Responsive.isTablet(context);

    if (isDesktop) {
      return Scaffold(
        body: Column(
          children: [
            _DesktopTopBar(
              selectedIndex: _selectedIndex,
              onSelect: (index) => context.go(_destinations[index].path),
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => context.go(_destinations[index].path),
        destinations: [
          for (final item in _destinations)
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 0.5,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth + 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Text(
                    AppConstants.appNameTamil,
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  for (var i = 0; i < ShellScaffold._destinations.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: TextButton(
                        onPressed: () => onSelect(i),
                        style: TextButton.styleFrom(
                          foregroundColor: i == selectedIndex
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                          textStyle: theme.textTheme.labelLarge?.copyWith(
                            fontWeight:
                                i == selectedIndex ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        child: Text(ShellScaffold._destinations[i].label),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
}
