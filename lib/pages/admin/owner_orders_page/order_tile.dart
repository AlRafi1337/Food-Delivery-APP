// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:breeze_mobile/pages/admin/owner_menu/food_details.dart';
import 'package:flutter/material.dart';

import '../../../models/food.dart';

class OrderFoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;
  const OrderFoodTile({
    super.key,
    required this.food,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(179, 219, 219, 219),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        splashColor: Color.fromARGB(255, 254, 223, 188),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailsPage(
                  food: food), // Navigate to FoodPage with the food item
            ),
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 125,
          child: Row(
            children: <Widget>[
              // Image Container
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: food.imagePath.isNotEmpty
                        ? NetworkImage(food.imagePath)
                        : AssetImage("assets/images/default_food.png")
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Food Details Container
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ' ${food.name}',
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'User name',
                        style: TextStyle(height: 1.5),
                      ),
                      Text(
                        'Category: I want more meat in my burger',
                        style: TextStyle(height: 1.5),
                      ),
                      // Add more fields as necessary
                    ],
                  ),
                ),
              ),
              // Action Button Container
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: [
                          Flexible(
                            child: IconButton(
                              onPressed: () {
                                // Handle edit action
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Delete Product"),
                                      content: Text(
                                          "Are you sure you want to delete this product?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              // Call deleteProduct method
                                              // _adminService.deleteProduct(food.name);
                                              // Update the UI after deletion if necessary
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            } catch (e) {
                                              // Handle error if necessary
                                              print(
                                                  'Error deleting product: $e');
                                            }
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
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
        ),
      ),
    );
  }
}
