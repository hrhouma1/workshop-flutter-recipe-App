import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../constants.dart';
import '../Provider/favorite_provider.dart';
import '../Provider/quantity_provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot recipe;

  const RecipeDetailScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Reset quantity when entering the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuantityProvider>(context, listen: false).resetQuantity();
    });
  }

  @override
  Widget build(BuildContext context) {
    var recipeData = widget.recipe.data() as Map<String, dynamic>;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  Iconsax.arrow_left,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            actions: [
              Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
                  return IconButton(
                    onPressed: () {
                      favoriteProvider.toggleFavorite(widget.recipe);
                    },
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        favoriteProvider.isExist(widget.recipe) 
                            ? Iconsax.heart5 
                            : Iconsax.heart,
                        color: favoriteProvider.isExist(widget.recipe) 
                            ? Colors.red 
                            : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: recipeData.containsKey('image') &&
                          recipeData['image'] != null &&
                          recipeData['image'].toString().isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(recipeData['image']),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !recipeData.containsKey('image') ||
                        recipeData['image'] == null ||
                        recipeData['image'].toString().isEmpty
                    ? Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                      )
                    : null,
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe name
                  Text(
                    recipeData['name'] ?? 'Sans nom',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  // Time, calories, rating
                  Row(
                    children: [
                      Icon(Iconsax.clock, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(
                        "${recipeData['time'] ?? '0'} Min",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.local_fire_department, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(
                        "${recipeData['cal'] ?? '0'} Cal",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      SizedBox(width: 5),
                      Text(
                        "${recipeData['rating'] ?? '0.0'}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " (${recipeData['reviews'] ?? '0'} Reviews)",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  
                  // Ingredients section
                  Consumer<QuantityProvider>(
                    builder: (context, quantityProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  quantityProvider.decreaseQuantity();
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: quantityProvider.quantity > 1 
                                        ? Colors.grey[600] 
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                child: Text(
                                  "${quantityProvider.quantity}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  quantityProvider.increaseQuantity();
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  
                  // Ingredients list
                  Consumer<QuantityProvider>(
                    builder: (context, quantityProvider, child) {
                      return Column(
                        children: [
                          _buildIngredientItem("Beef", "100g", quantityProvider),
                          _buildIngredientItem("Dice tomato", "2 pieces", quantityProvider),
                          _buildIngredientItem("Pizza base", "1 piece", quantityProvider),
                        ],
                      );
                    },
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Start Cooking button
                  Container(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Start cooking action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Starting to cook ${recipeData['name'] ?? 'this recipe'}!"),
                            backgroundColor: kprimaryColor,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Start Cooking",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIngredientItem(String name, String amount, QuantityProvider quantityProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Ingredient image placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.grey[400],
              size: 25,
            ),
          ),
          SizedBox(width: 15),
          // Ingredient name
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          // Amount with calculation
          Text(
            quantityProvider.calculateIngredientAmount(amount),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 