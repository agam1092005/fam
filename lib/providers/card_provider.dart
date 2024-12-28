import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CardProvider extends ChangeNotifier {
  late List _cardGroups = [];

  List get cardGroups => _cardGroups;

  Future<void> fetchCardData() async {
    try {
      // Directly get the list of CardGroupModel from the API service
      _cardGroups = await ApiService.fetchGroups();
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching data: $error');
    }
  }
}
