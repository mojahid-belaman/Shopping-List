import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:groceries/data/categories.dart';
import 'package:groceries/modal/category.dart';

class NewGrocery extends StatefulWidget {
  const NewGrocery({super.key});

  @override
  State<NewGrocery> createState() {
    return _NewGroceryState();
  }
}

class _NewGroceryState extends State<NewGrocery> {
  final _formKey = GlobalKey<FormState>();
  var _eneteredName = '';
  var _enteredQuantity = 1;
  var _enteredCategory = categories[Categories.convenience]!;

  void _submitGrocery() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https('flutter-grocery-cfefa-default-rtdb.firebaseio.com',
          'Groceries.json');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _eneteredName,
            'quantity': _enteredQuantity,
            'category': _enteredCategory.name
          }));
      print(response.body);
      print(response.statusCode);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grocery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Please, fill the field name correct';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _eneteredName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Please, fill the field quantity correct';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _enteredCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(category.value.name)
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _enteredCategory = value!;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _submitGrocery();
                      },
                      child: const Text('Add Grocery'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
