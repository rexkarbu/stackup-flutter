import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../backlog/screens/backlog_screen.dart';
import '../form/screens/game_form_screen.dart';
import '../stats/screens/stats_screen.dart';
import '../up_next/screens/up_next_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    BacklogScreen(),
    UpNextScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
            label: 'Backlog',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_list_numbered_rounded),
            selectedIcon: Icon(Icons.format_list_numbered_rounded,
                color: AppColors.primary),
            label: 'Up Next',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded),
            selectedIcon:
                Icon(Icons.insights_rounded, color: AppColors.primary),
            label: 'Stats',
          ),
        ],
      ),
      // Tampilkan FloatingActionButton (+) saat berada di tab Backlog
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              tooltip: 'Tambah Game',
              child: const Icon(Icons.add_rounded, size: 28),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const GameFormScreen(),
                  ),
                );
              },
            )
          : null,
    );
  }
}
