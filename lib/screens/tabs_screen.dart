import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favourites_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import '../providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedTabIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _setScreen(String indentifier) {
    Navigator.of(context).pop();
    if (indentifier == "filters") {
      Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) {
            return const FiltersScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filterMealsProvider);

    //Initially the active Page is Set to Categories Screen.
    var activePageTitle = "Categories";
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );

    if (_selectedTabIndex == 1) {
      final favouriteMeals = ref.watch(favoriteMealsProvider);
      const favTitle = "Your Favourites";
      activePage = MealsScreen(
        meals: favouriteMeals,
      );

      activePageTitle = favTitle;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      //This is a custom Drawer function which trigger the appDrawer
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourite"),
        ],
        currentIndex: _selectedTabIndex,
      ),
    );
  }
}
