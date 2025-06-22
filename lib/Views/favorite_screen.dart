import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../Provider/favorite_provider.dart';
import '../constants.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Favorite",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          return StreamBuilder<List<DocumentSnapshot>>(
            stream: favoriteProvider.getFavoriteItemsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.heart,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "No favorites yet",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Add some recipes to your favorites!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              var favoriteItems = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    var recipe = favoriteItems[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                                image: recipe.data() != null &&
                                        (recipe.data() as Map<String, dynamic>).containsKey('image') &&
                                        recipe['image'] != null &&
                                        recipe['image'].toString().isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(recipe['image']),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: recipe.data() == null ||
                                      !(recipe.data() as Map<String, dynamic>).containsKey('image') ||
                                      recipe['image'] == null ||
                                      recipe['image'].toString().isEmpty
                                  ? Center(
                                      child: Icon(
                                        Icons.restaurant,
                                        size: 30,
                                        color: Colors.grey[400],
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 15),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.data() != null &&
                                            (recipe.data() as Map<String, dynamic>).containsKey('name')
                                        ? recipe['name'] ?? 'Sans nom'
                                        : 'Sans nom',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    recipe.data() != null &&
                                            (recipe.data() as Map<String, dynamic>).containsKey('time')
                                        ? "${recipe['time']} min • ${recipe.data() != null && (recipe.data() as Map<String, dynamic>).containsKey('cal') ? recipe['cal'] : '0'} cal"
                                        : 'Temps non spécifié',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        recipe.data() != null &&
                                                (recipe.data() as Map<String, dynamic>).containsKey('rating')
                                            ? "${recipe['rating']} (${recipe.data() != null && (recipe.data() as Map<String, dynamic>).containsKey('reviews') ? recipe['reviews'] : '0'})"
                                            : '0.0 (0)',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Remove button
                            IconButton(
                              onPressed: () {
                                favoriteProvider.toggleFavorite(recipe);
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 