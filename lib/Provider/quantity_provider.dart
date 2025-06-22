import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  // Calculate ingredient amounts based on quantity
  String calculateIngredientAmount(String baseAmount) {
    // Extract number from string like "100g", "2 cups", etc.
    RegExp regExp = RegExp(r'(\d+)');
    Match? match = regExp.firstMatch(baseAmount);
    
    if (match != null) {
      int baseValue = int.parse(match.group(1)!);
      int newValue = baseValue * _quantity;
      String unit = baseAmount.replaceAll(regExp, '').trim();
      return '$newValue$unit';
    }
    
    return baseAmount;
  }
} 