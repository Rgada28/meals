import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false
        });

  void setFilters(Map<Filter, bool> chosenFiters) {
    state = chosenFiters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
    (ref) => FilterNotifier());

final filterMealsProvider = Provider((ref) {
  final meals = ref.read(mealsProvider);
  final activeFilters = ref.watch(filterProvider);
  return meals.where((meals) {
    if (activeFilters[Filter.glutenFree]! && !meals.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meals.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meals.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meals.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
