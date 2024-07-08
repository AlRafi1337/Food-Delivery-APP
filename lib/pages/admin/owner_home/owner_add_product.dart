// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_mvvm/view/view.dart';

import '../admin_viewmodel.dart';

class AddProductToMenu extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => AddProductToMenu());
  @override
  _AddProductToMenuState createState() => _AddProductToMenuState();
}

class _AddProductToMenuState extends State<AddProductToMenu> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _price = 0.0;
  File? _image;
  Uint8List? _webImage;
  String _category = 'noodles';
  List<Map<String, dynamic>> _addons = [];
  final _picker = ImagePicker();
  final TextEditingController _addonNameController = TextEditingController();
  final TextEditingController _addonPriceController = TextEditingController();

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

  Future<void> _uploadMenuItem(AdminViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final item = {
        'name': _name,
        'description': _description,
        'price': _price,
        'image': _image,
        'webImage': _webImage,
        'category': _category,
        'addons': _addons,
      };

      await viewModel.addProduct(item);

      if (viewModel.errorMessage == null) {
        print('Data uploaded successfully');
        Navigator.pop(context);
      } else {
        print('Error uploading menu item: ${viewModel.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Add Menu Item'),
            backgroundColor: Color.fromRGBO(200, 118, 22, 1),
          ),
          body: ViewWrapper<AdminViewModel>(
            builder: (_, viewModel) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onSaved: (value) => _name = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onSaved: (value) => _description = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _price = double.parse(value!),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a price' : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: ['rice', 'noodles', 'sides', 'drinks']
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
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
                          subtitle: Text('Price: \$${addon['price']}'),
                        )),
                    SizedBox(height: 10),
                    _webImage != null
                        ? Image.memory(_webImage!)
                        : _image != null
                            ? Image.file(_image!)
                            : Text('No image selected.'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _uploadMenuItem(viewModel),
                      child: Text('Add Menu Item'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
