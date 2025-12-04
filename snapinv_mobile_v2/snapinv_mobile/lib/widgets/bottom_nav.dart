import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapinv_mobile/app_state.dart';
import 'package:snapinv_mobile/constants/config.dart';
import 'package:snapinv_mobile/pages/dashboard_page.dart';
import 'package:snapinv_mobile/pages/inventory_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final PageController controller = PageController(initialPage: 0);

  void _onTap(int index) {
    controller.jumpToPage(index);
    context.read<AppState>().setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        body: PageView(
          controller: controller,
          children: [DashboardPage(), InventoryPage()],
          onPageChanged: (index) {
            context.read<AppState>().setSelectedIndex(index);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: appState.selectedIndex,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: false,
          onTap: _onTap,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dash',
              backgroundColor: AppColors.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shelves),
              label: 'Inventory',
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      );
    });
  }
}
