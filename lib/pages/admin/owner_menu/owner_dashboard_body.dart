// // ignore_for_file: prefer_const_constructors, use_super_parameters

// import 'package:flutter/material.dart';

// import '../../../components/admin_food_tile.dart';
// import '../../../models/food.dart';
// import '../../../services/admin/admin_service.dart';
// import '../../../services/admin/admin_service_firebase.dart';
// import '../../food_page.dart';

// class OwnerDashboardBodyPage extends StatefulWidget {
//   const OwnerDashboardBodyPage({Key? key}) : super(key: key);

//   @override
//   State<OwnerDashboardBodyPage> createState() => _OwnerDashboardBodyPageState();
// }

// class _OwnerDashboardBodyPageState extends State<OwnerDashboardBodyPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late AdminService _adminService;

//   @override
//   void initState() {
//     super.initState();
//     _tabController =
//         TabController(length: FoodCategory.values.length, vsync: this);
//     _adminService = AdminSeviceFirebase(); // Initialize AdminServiceFirebase
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<List<Food>> _fetchCategoryMenu(FoodCategory category) async {
//     return await _adminService.getProductsByCategory(category);
//   }

//   List<Widget> getFoodInThisCategory() {
//     return FoodCategory.values.map((category) {
//       return FutureBuilder<List<Food>>(
//         future: _fetchCategoryMenu(category),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching data'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No food items in this category'));
//           } else {
//             List<Food> categoryMenu = snapshot.data!;
//             return ListView.builder(
//               itemCount: categoryMenu.length,
//               physics: const NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.zero,
//               itemBuilder: (context, index) {
//                 final food = categoryMenu[index];
//                 return AdminFoodTile(
//                   food: food,
//                   onTap: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => FoodPage(food: food)),
//                     );
//                     if (result == true) {
//                       setState(() {
//                         // Refresh the list after returning from FoodPage
//                       });
//                     }
//                   },
//                 );
//               },
//             );
//           }
//         },
//       );
//     }).toList();
//   }

// ignore_for_file: prefer_const_constructors, use_super_parameters

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.secondary,
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           SliverAppBar(
//             pinned: true,
//             floating: true,
//             title: Text('Owner Dashboard'),
//             bottom: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               tabs: FoodCategory.values
//                   .map((category) =>
//                       Tab(text: category.toString().split('.').last))
//                   .toList(),
//             ),
//           ),
//         ],
//         body: TabBarView(
//           controller: _tabController,
//           children: getFoodInThisCategory(),
//         ),
//       ),
//     );
//   }
// }
// // ignore_for_file: prefer_const_constructors, use_super_parameters
import 'package:breeze_mobile/pages/admin/owner_menu/food_details.dart';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';

import '../../../components/admin_food_tile.dart';
import '../../../models/food.dart';
import '../admin_viewmodel.dart';

class OwnerDashboardBodyPage extends StatefulWidget {
  const OwnerDashboardBodyPage({Key? key}) : super(key: key);

  @override
  State<OwnerDashboardBodyPage> createState() => _OwnerDashboardBodyPageState();
}

class _OwnerDashboardBodyPageState extends State<OwnerDashboardBodyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  Future<void> _navigateToFoodDetails(
      BuildContext context, Food food, AdminViewModel viewModel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailsPage(food: food),
      ),
    );
    if (result == true) {
      await viewModel.getProductsByCategory(food.category);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<AdminViewModel>(
      builder: (_, viewModel) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              floating: true,
              title: Text('Edit Menu'),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: FoodCategory.values
                    .map((category) =>
                        Tab(text: category.toString().split('.').last))
                    .toList(),
              ),
            ),
          ],
          body: viewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
                  ? Center(child: Text(viewModel.errorMessage!))
                  : TabBarView(
                      controller: _tabController,
                      children: FoodCategory.values.map((category) {
                        final categoryMenu = viewModel.products
                            .where((food) => food.category == category)
                            .toList();
                        if (categoryMenu.isEmpty) {
                          return Center(
                              child: Text('No food items in this category'));
                        }
                        return ListView.builder(
                          itemCount: categoryMenu.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final food = categoryMenu[index];
                            return AdminFoodTile(
                              food: food,
                              onTap: () => _navigateToFoodDetails(
                                  context, food, viewModel),
                            );
                          },
                        );
                      }).toList(),
                    ),
        ),
      ),
    );
  }
}
