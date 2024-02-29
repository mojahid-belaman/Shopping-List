import 'package:flutter/material.dart';
import 'package:groceries/modal/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({super.key, required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: groceryItem.category.color,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(groceryItem.name),
        const Spacer(),
        Text(groceryItem.quantity.toString()),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
