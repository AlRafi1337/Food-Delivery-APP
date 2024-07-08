// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_super_parameters, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:breeze_mobile/pages/admin/owner_orders_page/order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';

import '../../../models/orders.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OwnerPageState();
}

String status = "Pending";
int selectIndex = 1;

class _OwnerPageState extends State<OrderPage> {
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
                ViewWrapper<OrderViewModel>(
                  builder: (context, viewModel) {
                    // Filter the orders based on the status
                    final filteredOrders = viewModel.orders.where((order) {
                      if (status == "Pending") {
                        return order.status == OrderStatus.pending;
                      } else if (status == "Completed") {
                        return order.status == OrderStatus.completed;
                      } else if (status == "Rejected") {
                        return order.status == OrderStatus.cancelled;
                      }
                      return false;
                    }).toList();

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, orderIndex) {
                        final foodItem = filteredOrders[orderIndex];

                        return Column(
                          children:
                              List.generate(foodItem.items.length, (itemIndex) {
                            final food = foodItem.items[itemIndex].food;
                            final imageUrl = food.imagePath.isNotEmpty
                                ? food.imagePath
                                : "https://via.placeholder.com/100";
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
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
                                              Text(
                                                  '${foodItem.items[itemIndex].food.name}',
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'Category: ${foodItem.items[itemIndex].food.name}',
                                                  style:
                                                      TextStyle(height: 1.5)),
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
                                                      onPressed: () async {
                                                        if (foodItem.id !=
                                                            null) {
                                                          FoodOrder? updatedOrder =
                                                              await viewModel
                                                                  .updateOrderStatus(
                                                                      foodItem
                                                                          .id!,
                                                                      OrderStatus
                                                                          .completed);
                                                          if (updatedOrder !=
                                                              null) {
                                                            setState(() {
                                                              // Update the order list with the updated order
                                                              int index = viewModel
                                                                  .orders
                                                                  .indexWhere((order) =>
                                                                      order
                                                                          .id ==
                                                                      updatedOrder
                                                                          .id);
                                                              if (index != -1) {
                                                                viewModel.orders[
                                                                        index] =
                                                                    updatedOrder;
                                                              }
                                                            });
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  "Order status updated to Completed"),
                                                            ));
                                                          }
                                                        }
                                                      },
                                                      icon: Icon(Icons
                                                          .thumb_up_alt_outlined),
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Flexible(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Reject Item"),
                                                              content: Text(
                                                                  "Are you sure you want to reject this item?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Cancel"),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    print(
                                                                        'Order ID${foodItem.id}');
                                                                    if (foodItem
                                                                            .id !=
                                                                        null) {
                                                                      FoodOrder?
                                                                          updatedOrder =
                                                                          await viewModel.updateOrderStatus(
                                                                              foodItem.id!,
                                                                              OrderStatus.cancelled);
                                                                      updatedOrder
                                                                          ?.printOrder();
                                                                      Navigator.pop(
                                                                          context);
                                                                      if (updatedOrder !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          // Update the order list with the updated order
                                                                          int index = viewModel.orders.indexWhere((order) =>
                                                                              order.id ==
                                                                              updatedOrder.id);
                                                                          if (index !=
                                                                              -1) {
                                                                            viewModel.orders[index] =
                                                                                updatedOrder;
                                                                          }
                                                                        });
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text("Order status updated to Rejected"),
                                                                        ));
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      "Reject"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(Icons.cancel),
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
                          }),
                        );
                      },
                    );
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
