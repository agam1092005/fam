import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CardProvider extends ChangeNotifier {
  late List _cardGroups = [];

  List get cardGroups => _cardGroups;

  // For remind later HC3 Cards
  var tempRemoved = [];

  void removeOnRefresh() {
    if (tempRemoved.isNotEmpty) {
      for (var i in tempRemoved) {
        removeItem(i);
      }
    }
    notifyListeners();
  }

  // Stored each HC3 card according to id of HC3 & idx being id of each card
  // format: id-idx
  void removeItem(String idIdx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('items') ?? [];
    if (!items.contains(idIdx)) {
      tempRemoved.add(idIdx);
    }
    final parts = idIdx.split('-');
    final int id = int.parse(parts[0]);
    final int idx = int.parse(parts[1]);

    _cardGroups.removeWhere((cardGroup) {
      return cardGroup['id'] == id &&
          (cardGroup['cards'] as List).any((card) => card['id'] == idx);
    });

    notifyListeners();
  }

  // Fetching cards removing ones dismissed (stored in cache)
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
