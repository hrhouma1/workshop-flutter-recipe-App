import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import '../constants.dart';

class ViewAllItems extends StatefulWidget {
  final String title;
  final String? category;

  const ViewAllItems({
    Key? key,
    required this.title,
    this.category,
  }) : super(key: key);

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Iconsax.arrow_left,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.category == null
              ? _firestore.collection('Complete-Flutter-App').snapshots()
              : _firestore
                  .collection('Complete-Flutter-App')
                  .where('category', isEqualTo: widget.category)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var recipe = snapshot.data!.docs[index];
                  return Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image container
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                            child: Stack(
                              children: [
                                // Default icon if no image
                                if (recipe.data() == null ||
                                    !(recipe.data() as Map<String, dynamic>).containsKey('image') ||
                                    recipe['image'] == null ||
                                    recipe['image'].toString().isEmpty)
                                  Center(
                                    child: Icon(
                                      Icons.restaurant,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                // Favorite button
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
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
                                      Iconsax.heart,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Recipe name
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
                                SizedBox(height: 8),
                                // Time and calories
                                Text(
                                  recipe.data() != null &&
                                          (recipe.data() as Map<String, dynamic>).containsKey('time')
                                      ? "${recipe['time']} min • ${recipe.data() != null && (recipe.data() as Map<String, dynamic>).containsKey('cal') ? recipe['cal'] : '0'} cal"
                                      : 'Temps non spécifié',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                // Rating
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
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
} 