import 'package:breeze_mobile/components/my_current_location.dart';
import 'package:breeze_mobile/components/my_description_box.dart';
import 'package:breeze_mobile/components/my_drawer.dart';
import 'package:breeze_mobile/components/my_food_tile.dart';
import 'package:breeze_mobile/components/my_sliver_appbar.dart';
import 'package:breeze_mobile/components/my_tab_bar.dart';
import 'package:breeze_mobile/models/food.dart';
import 'package:breeze_mobile/pages/food_page.dart';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';

import 'admin/admin_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);

      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return FoodTile(
            food: food,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodPage(food: food)),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      drawer: const MyDrawer(),
      body: ViewWrapper<AdminViewModel>(
        builder: (_, viewModel) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              MySliverAppBar(
                title: MyTabBar(tabController: _tabController),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      indent: 25,
                      endIndent: 25,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    MyCurrentLocation(),
                    const MyDescriptionBox(),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: getFoodInThisCategory(viewModel.products),
            ),
          );
        },
      ),
    );
  }
}
