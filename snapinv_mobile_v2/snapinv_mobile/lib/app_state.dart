import 'package:flutter/foundation.dart';
import 'package:snapinv_mobile/pages/inventory_page.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;
  
  int get selectedIndex => _selectedIndex;
  
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
    
    if (index == 0) {
      // HomePage.pageKey.currentState?.getTransactionLog();
    } else if (index == 2) {
      // InventoryPage.pageKey.currentState?.getInventory();
    }
  }
}