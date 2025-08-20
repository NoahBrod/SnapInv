import 'package:flutter/foundation.dart';
import 'package:snapinv_mobile/pages/dashboard.dart';
import 'package:snapinv_mobile/pages/inventory.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;
  
  int get selectedIndex => _selectedIndex;
  
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
    
    if (index == 0) {
      DashboardPage.pageKey.currentState?.getTransactionLog();
    } else if (index == 2) {
      InventoryPage.pageKey.currentState?.getInventory();
    }
  }
}