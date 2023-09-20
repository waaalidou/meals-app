import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealsNotifier() : super([]);
  bool toggleFavouriteStatus(Meal meal) {
    final isFavourite = state.contains(meal);
    state = isFavourite
        ? state.where((element) => meal.id != element.id).toList()
        : [...state, meal];
    return !isFavourite;
  }
}

final favouriteMealsProvider =
    StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>(
  (ref) => FavouriteMealsNotifier(),
);
