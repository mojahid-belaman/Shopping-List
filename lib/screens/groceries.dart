import 'package:flutter/material.dart';
import 'package:groceries/data/dummy_items.dart';
import 'package:groceries/widgets/grocery_list.dart';

class Groceries extends StatelessWidget {
  const Groceries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => GroceryList(
          groceryItem: groceryItems[index],
        ),
      ),
    );
  }
}
