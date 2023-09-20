import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favourite_providers.dart';
import '../models/meal.dart';

class MealDetailsScreen extends ConsumerStatefulWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final isFavourite = favouriteMeals.contains(widget.meal);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.meal.title),
          actions: [
            IconButton(
              onPressed: () {
                final wasAdded = ref
                    .read(favouriteMealsProvider.notifier)
                    .toggleFavouriteStatus(widget.meal);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasAdded ? "Meals Added" : "Meal removed"),
                  ),
                );
              },
              icon: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(
                      begin: 0.8,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: Icon(
                  isFavourite ? Icons.star : Icons.star_border,
                  key: ValueKey(isFavourite),
                ),
              ),
            )
          ],
        ),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => SlideTransition(
            position: Tween(begin: const Offset(0, .5), end: const Offset(0, 0))
                .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.linear,
              ),
            ),
            child: child,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: widget.meal.id,
                  child: Image.network(
                    widget.meal.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                for (final ingredient in widget.meal.ingredients)
                  Text(
                    ingredient,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                for (final step in widget.meal.steps)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      step,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
