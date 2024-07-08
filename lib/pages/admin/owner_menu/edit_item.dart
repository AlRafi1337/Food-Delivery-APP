// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, avoid_print, use_build_context_synchronously, prefer_const_constructors

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_web/image_picker_web.dart';

// import '../../../models/food.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/food.dart';

class EditMenuItemPage extends StatefulWidget {
  final Food food;

  EditMenuItemPage({required this.food});

  @override
  _EditMenuItemPageState createState() => _EditMenuItemPageState();
}

class _EditMenuItemPageState extends State<EditMenuItemPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  File? _image;
  Uint8List? _webImage;
  late FoodCategory _category;
  late List<Map<String, dynamic>> _addons;
  final _picker = ImagePicker();
  final TextEditingController _addonNameController = TextEditingController();
  final TextEditingController _addonPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.food.name;
    _description = widget.food.description;
    _price = widget.food.price.toDouble();
    _category = widget.food.category;
    _addons = widget.food.availableAddons
        .map((addon) => {'name': addon.name, 'price': addon.price.toDouble()})
        .toList();
  }

  // Future<void> _pickImage() async {
  //   if (kIsWeb) {
  //     final pickedFile = await ImagePickerWeb.getImageAsBytes();
  //     if (pickedFile != null) {
  //       setState(() {
  //         _webImage = pickedFile;
  //         _image = null;
  //       });
  //     } else {
  //       print('No image selected.');
  //     }
  //   } else {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //         _webImage = null;
  //       });
  //     } else {
  //       print('No image selected.');
  //     }
  //   }
  // }
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _image = null;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
          _webImage = null;
        });
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> _updateMenuItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String imageUrl = widget.food.imagePath;
        if (_image != null || _webImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('menu_images')
              .child('${DateTime.now().toIso8601String()}.jpg');
          if (kIsWeb && _webImage != null) {
            await ref.putData(_webImage!);
          } else if (_image != null) {
            await ref.putFile(_image!);
          }
          imageUrl = await ref.getDownloadURL();
          print('Image uploaded successfully: $imageUrl');
        }
        var data = {
          'name': _name,
          'description': _description,
          'price': _price,
          'imagePath': imageUrl,
          'category': FoodCategory.toStr(_category),
          'availableAddons': _addons,
        };

        // Update the item by its name
        var querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('name', isEqualTo: widget.food.name)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;
          await FirebaseFirestore.instance
              .collection('products')
              .doc(doc.id)
              .update(data);

          // Return the updated food object to the previous screen
          Food updatedFood = Food(
            name: _name,
            description: _description,
            imagePath: imageUrl,
            price: _price,
            category: _category,
            availableAddons: _addons
                .map((addon) => Addon(
                      name: addon['name'],
                      price: addon['price'],
                    ))
                .toList(),
          );

          Navigator.pop(context, updatedFood);
          print('Data updated successfully: $data');
        } else {
          print('No item found with the name ${widget.food.name}');
        }
      } catch (e) {
        print('Error updating menu item: $e');
      }
    }
  }

  void _addAddon() {
    setState(() {
      _addons.add({
        'name': _addonNameController.text,
        'price': double.tryParse(_addonPriceController.text) ?? 0.0,
      });
      _addonNameController.clear();
      _addonPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu Item'),
        backgroundColor: Color.fromRGBO(200, 118, 22, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = double.parse(value!),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<FoodCategory>(
                value: _category,
                items: FoodCategory.values
                    .map((category) => DropdownMenuItem<FoodCategory>(
                          value: category,
                          child: Text(FoodCategory.toStr(category)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _category = value!;
                }),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 10),
              Text('Add-ons'),
              TextFormField(
                controller: _addonNameController,
                decoration: InputDecoration(labelText: 'Addon Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addonPriceController,
                decoration: InputDecoration(labelText: 'Addon Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addAddon,
                child: Text('Add Addon'),
              ),
              SizedBox(height: 10),
              ..._addons.map((addon) => ListTile(
                    title: Text(addon['name']),
                    subtitle: Text('Price: RM ${addon['price']}'),
                  )),
              SizedBox(height: 10),
              _webImage != null
                  ? Image.memory(_webImage!)
                  : _image != null
                      ? Image.file(_image!)
                      : widget.food.imagePath.isNotEmpty
                          ? Image.network(widget.food.imagePath)
                          : Text('No image selected.'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateMenuItem,
                child: Text('Update Menu Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
