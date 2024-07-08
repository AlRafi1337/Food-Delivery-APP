// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';

import '../../../models/food.dart';
import '../../admin/admin_viewmodel.dart';
import 'edit_item.dart';

class FoodDetailsPage extends StatefulWidget {
  Food food;

  FoodDetailsPage({Key? key, required this.food}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  Food? updatedFood;

  // void deleteFood(Food food) {
  //   // Add your delete logic here
  //   Navigator.pop(context, true); // Return true to indicate changes
  // }
  void deleteFood(AdminViewModel viewModel, Food food) async {
    await viewModel.deleteProduct(food.name);

    // Check if the product has been deleted
    bool productStillExists =
        viewModel.products.any((prod) => prod.name == food.name);
    if (!productStillExists) {
      print('Product deleted successfully.');
    } else {
      print('Product still exists after deletion attempt.');
    }

    // Uncomment the following line to update the UI with the changes
    setState(() {});
    Navigator.pop(context, true);
  }

  Future<Food?> _openEditPage(Food food) async {
    Food? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMenuItemPage(food: food),
      ),
    );
    if (result == null) return null;
    return result;
  }

  void editFood(AdminViewModel viewModel, Food food) async {
    Food? result = await _openEditPage(food);
    if (result == null) return;

    final updatedData = {
      'name': result.name,
      'description': result.description,
      'price': result.price,
      'imagePath': result.imagePath,
      'category': result.category.index,
    };

    // Store the original name to find the correct product in the list
    String originalName = food.name;

    await viewModel.updateProduct(originalName, updatedData);

    // Retrieve the updated product
    Food? updatedProduct;
    try {
      updatedProduct =
          viewModel.products.firstWhere((prod) => prod.name == result.name);
      print("The updated product is:");
      print("Name: ${updatedProduct.name}");
      print("Description: ${updatedProduct.description}");
      print("Price: ${updatedProduct.price}");
      print("Image Path: ${updatedProduct.imagePath}");
      print("Category: ${updatedProduct.category}");
      print("Available Addons: ${updatedProduct.availableAddons}");
    } catch (e) {
      print("Product not found after update.");
    }

    // Uncomment the following line to update the UI with the new product data
    setState(() {
      widget.food = updatedProduct!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: ViewWrapper<AdminViewModel>(
            builder: (_, viewModel) => SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(widget.food.imagePath),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.food.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'RM ${widget.food.price.toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(widget.food.description),
                        const SizedBox(height: 10),
                        Divider(color: Theme.of(context).colorScheme.secondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.edit),
                          label: Text("Edit"),
                          onPressed: () => editFood(viewModel, widget.food),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          onPressed: () => deleteFood(viewModel, widget.food),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => {Navigator.pop(context, updatedFood != null)},
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
