// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_super_parameters, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables

import 'package:breeze_mobile/app/service_locator.dart';
import 'package:breeze_mobile/models/food.dart';
import 'package:breeze_mobile/services/admin/menu_service.dart';
import 'package:flutter/material.dart';

class OwnerMainPage extends StatefulWidget {
  const OwnerMainPage({Key? key}) : super(key: key);

  @override
  State<OwnerMainPage> createState() => _OwnerMainPageState();
}

String status = "Pending";
int selectIndex = 1;

class _OwnerMainPageState extends State<OwnerMainPage> {
  final AdminService _adminService = locator<AdminService>();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("pending".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor: selectIndex == 1
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : MaterialStateProperty.all<Color>(
                                Color.fromRGBO(200, 118, 22, 1)),
                        backgroundColor: selectIndex == 1
                            ? MaterialStateProperty.all<Color>(
                                Color.fromRGBO(200, 118, 22, 1))
                            : MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Color.fromRGBO(200, 118, 22, 1)),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() {
                        selectIndex = 1;
                        status = "Pending";
                      }),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      child: Text("completed".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor: selectIndex == 2
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : MaterialStateProperty.all<Color>(
                                Color.fromRGBO(200, 118, 22, 1)),
                        backgroundColor: selectIndex == 2
                            ? MaterialStateProperty.all<Color>(
                                Color.fromRGBO(200, 118, 22, 1))
                            : MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Color.fromRGBO(200, 118, 22, 1)),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() {
                        selectIndex = 2;
                        status = "Completed";
                      }),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      child: Text("Rejected".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor: selectIndex == 3
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : MaterialStateProperty.all<Color>(
                                Color.fromRGBO(200, 118, 22, 1)),
                        backgroundColor: selectIndex == 3
                            ? MaterialStateProperty.all<Color>(
                                Color.fromRGBO(200, 118, 22, 1))
                            : MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Color.fromRGBO(200, 118, 22, 1)),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() {
                        selectIndex = 3;
                        status = "Rejected";
                      }),
                    ),
                  ],
                ),
                FutureBuilder<List<Food>>(
                  future: _adminService.getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Text("Nothis Found in here")),
                          Text('Nothing to show here...',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                              textAlign: TextAlign.center),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final foodItem = snapshot.data![index];
                          return Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(179, 219, 219, 219),
                                  width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              splashColor: Color.fromARGB(255, 254, 223, 188),
                              onTap: () {
                                // Handle item tap if necessary
                              },
                              child: SizedBox(
                                width: 395,
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
                                          image: foodItem.imagePath.isNotEmpty
                                              ? NetworkImage(foodItem.imagePath)
                                              : Text("Nothis Found in here")
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Food Details Container
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Name: ${foodItem.name}',
                                                style: TextStyle(
                                                    height: 1.5,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            // Text(
                                            //     'Description: ${foodItem.description}',
                                            //     style: TextStyle(height: 1.5)),
                                            Text('Price: MYR ${foodItem.price}',
                                                style: TextStyle(height: 1.5)),
                                            Text(
                                                'Category: ${FoodCategory.toStr(foodItem.category)}',
                                                style: TextStyle(height: 1.5)),
                                            // Add more fields as necessary
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Action Button Container
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Delete Product"),
                                                            content: Text(
                                                                "Are you sure you want to delete this product?"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Cancel"),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    // Call deleteProduct method
                                                                    _adminService
                                                                        .deleteProduct(
                                                                            foodItem.name);
                                                                    final List<
                                                                            Food>
                                                                        updatedProducts =
                                                                        await _adminService
                                                                            .getProducts();
                                                                    print(
                                                                        "The deleted product, ${foodItem.name}");
                                                                    setState(
                                                                        () {
                                                                      // Assign the updated list of products to the snapshot
                                                                      snapshot = AsyncSnapshot<
                                                                              List<Food>>.withData(
                                                                          ConnectionState
                                                                              .done,
                                                                          updatedProducts);
                                                                    });
                                                                    Navigator.pop(
                                                                        context); // Close the dialog
                                                                  } catch (e) {
                                                                    // Handle error if necessary
                                                                    print(
                                                                        'Error deleting product: $e');
                                                                  }
                                                                },
                                                                child: Text(
                                                                    "Delete"),
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
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
