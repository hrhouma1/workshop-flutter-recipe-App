import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> get favorites => _favoriteIds;

  FavoriteProvider() {
    _loadFavorites();
  }

  // Load favorites from Firestore
  void _loadFavorites() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('userFavorites').doc('user1').get();
      if (userDoc.exists) {
        _favoriteIds = List<String>.from(userDoc['favorites'] ?? []);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // Toggle favorite status
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  // Add favorite to Firestore
  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorites').doc('user1').set({
        'favorites': _favoriteIds,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Remove favorite from Firestore
  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorites').doc('user1').update({
        'favorites': _favoriteIds,
      });
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  // Check if a product is favorited
  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  // Get favorite items as stream
  Stream<List<DocumentSnapshot>> getFavoriteItemsStream() {
    if (_favoriteIds.isEmpty) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('Complete-Flutter-App')
        .where(FieldPath.documentId, whereIn: _favoriteIds)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
} 