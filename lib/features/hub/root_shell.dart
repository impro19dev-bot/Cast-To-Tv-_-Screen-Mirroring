import 'package:flutter/material.dart';

import '../../l10n/strings.dart';
import '../../services/haptics.dart';
import 'cast_tab.dart';
import 'home_tab.dart';
import '../mirror/mirror_page.dart';
import '../settings/settings_page.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pages = [
      const HomeTab(),
      const CastTab(),
      const MirrorPage(embedded: true),
      const SettingsPage(embedded: true),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) async {
          await Haptics.selection();
          setState(() => _index = i);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: s.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.cast_outlined),
            selectedIcon: const Icon(Icons.cast_rounded),
            label: s.tabCast,
          ),
          NavigationDestination(
            icon: const Icon(Icons.screen_share_outlined),
            selectedIcon: const Icon(Icons.screen_share_rounded),
            label: s.tabMirror,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz_rounded),
            selectedIcon: const Icon(Icons.more_horiz_rounded),
            label: s.tabMore,
          ),
        ],
      ),
    );
  }
}
