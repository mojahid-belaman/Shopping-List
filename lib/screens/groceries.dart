import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groceries/data/categories.dart';
import 'package:groceries/modal/category.dart';
import 'package:http/http.dart' as http;

import 'package:groceries/modal/grocery_item.dart';
import 'package:groceries/screens/new_grocery.dart';
import 'package:groceries/widgets/grocery_list.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadGroceries();
  }

  void _loadGroceries() async {
    final url = Uri.https(
        'flutter-grocery-cfefa-default-rtdb.firebaseio.com', 'Groceries.json');
    final response = await http.get(url);
    final Map<String, dynamic> groceries = json.decode(response.body);
    final List<GroceryItem> listData = [];

    for (final grocery in groceries.entries) {
      final Category category = categories.values
          .firstWhere((cartItem) => cartItem.name == grocery.value['category']);
      listData.add(GroceryItem(
          id: grocery.key,
          name: grocery.value['name'],
          quantity: grocery.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems = listData;
    });
  }

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
      body: content,
    );
  }
}
