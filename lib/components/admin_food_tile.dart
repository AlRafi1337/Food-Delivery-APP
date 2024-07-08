// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:breeze_mobile/pages/admin/owner_menu/food_details.dart';
import 'package:flutter/material.dart';

import '../models/food.dart';

class AdminFoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;
  const AdminFoodTile({
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
                        'Name: ${food.name}',
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Price: MYR ${food.price}',
                        style: TextStyle(height: 1.5),
                      ),
                      Text(
                        'Category: ${FoodCategory.toStr(food.category)}',
                        style: TextStyle(height: 1.5),
                      ),
                      // Add more fields as necessary
                    ],
                  ),
                ),
              ),
              // Action Button Container
            ],
          ),
        ),
      ),
    );
  }
}
