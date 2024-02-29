import 'package:flutter/material.dart';
import 'package:groceries/data/dummy_items.dart';
import 'package:groceries/widgets/grocery_item_widget.dart';

class Groceries extends StatelessWidget {
  const Groceries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final grocerie in groceryItems)
              GroceryItemWidget(
                groceryItem: grocerie,
              )
          ],
        ),
      ),
    );
  }
}
