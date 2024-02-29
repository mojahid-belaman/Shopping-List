import 'package:flutter/material.dart';
import 'package:groceries/modal/grocery_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key, required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(groceryItem.name),
      leading: Container(
        width: 24,
        height: 24,
        color: groceryItem.category.color,
      ),
      trailing: Text(groceryItem.quantity.toString()),
    );
  }
}
