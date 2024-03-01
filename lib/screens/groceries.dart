import 'package:flutter/material.dart';

import 'package:groceries/modal/grocery_item.dart';
import 'package:groceries/screens/new_grocery.dart';
import 'package:groceries/widgets/grocery_list.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  final List<GroceryItem> _groceryItems = [];

  void _addGrocery() async {
    final newGrocery = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewGrocery();
        },
      ),
    );
    if (newGrocery == null) return;
    setState(() {
      _groceryItems.add(newGrocery);
    });
  }

  void _removeGrocery(GroceryItem grocery) {
    final indexRemovedGrocery = _groceryItems.indexOf(grocery);
    setState(() {
      _groceryItems.remove(grocery);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: const Text('Grocery Removed!'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _groceryItems.insert(indexRemovedGrocery, grocery);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'You Got No Items Yet!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error,
            child: const Icon(Icons.delete),
          ),
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeGrocery(_groceryItems[index]);
          },
          child: GroceryList(
            groceryItem: _groceryItems[index],
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addGrocery, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
