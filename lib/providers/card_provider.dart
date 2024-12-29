import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CardProvider extends ChangeNotifier {
  late List _cardGroups = [];

  List get cardGroups => _cardGroups;

  void removeItem(String idIdx) {
    final parts = idIdx.split('-');
    final int id = int.parse(parts[0]);
    final int idx = int.parse(parts[1]);

    _cardGroups.removeWhere((cardGroup) {
      return cardGroup['id'] == id &&
          (cardGroup['cards'] as List).any((card) => card['id'] == idx);
    });

    notifyListeners();
  }

  Future<void> fetchCardData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> items = prefs.getStringList('items') ?? [];

      _cardGroups = await ApiService.fetchGroups();
      if (items.isNotEmpty) {
        for (var i in items) {
          removeItem(i);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching data: $error');
    }
  }
}
