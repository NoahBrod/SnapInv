import 'package:flutter/material.dart';
import 'package:snapinv_mobile/constants/api_config.dart';

import '../../app_state.dart';
import 'package:provider/provider.dart';

import '../../pages/camera.dart';
import '../../pages/dashboard.dart';
import '../../pages/inventory.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final PageController controller = PageController(initialPage: 2);

  void _onTap(int index) {
    controller.jumpToPage(index);
    context.read<AppState>().setSelectedIndex(index); // Use Provider instead
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: PageView(
            controller: controller,
            children: [DashboardPage(), CameraPage(), InventoryPage()],
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
                icon: Icon(Icons.camera_outlined),
                activeIcon: Icon(Icons.camera),
                label: 'Camera',
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
      },
    );
  }
}
