import 'package:alsayed/show_items.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'common_drawer.dart';


final List<Map<String, dynamic>> _menus = [];
const String _baseURL = 'https://alsayedcoffee.000webhostapp.com/';

class ShowMenus extends StatefulWidget {
  const ShowMenus({Key? key}) : super(key: key);

  @override
  State<ShowMenus> createState() => _ShowMenusState();
}

class _ShowMenusState extends State<ShowMenus> {
  bool _load = false;
  String? _selectedMenu;

  @override
  void initState() {
    super.initState();
    updateMenus(update);
  }

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Menus'),
        centerTitle: true,
      ),
      drawer: CommonDrawer(),
      body: _load
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListMenusDropdown(
              menus: _menus,
              selectedMenu: _selectedMenu,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMenu = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedMenu != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowItems(selectedMenu: _selectedMenu!),
                    ),
                  );
                } else {
                  // Show a message if no menu is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please choose a menu')),
                  );
                }
              },
              child: const Text('Show Items'),
            ),
          ],
        ),
      )
          : const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Text('Data Loading...'),
        ),
      ),
    );
  }
}

class ListMenusDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> menus;
  final String? selectedMenu;
  final ValueChanged<String?> onChanged;

  const ListMenusDropdown({
    Key? key,
    required this.menus,
    required this.selectedMenu,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMenu,
      onChanged: onChanged,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: const Text('Choose Menu'),
        ),
        ...menus.map<DropdownMenuItem<String>>((menu) {
          return DropdownMenuItem<String>(
            value: menu['menu_id'].toString(),
            child: Text(menu['menu_name']),
          );
        }),
      ],
    );
  }
}


void updateMenus(Function(bool success) update) async {
  try {
    final url = Uri.parse('$_baseURL/getMenu.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    _menus.clear(); // Clear old menus

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);

      for (var row in jsonResponse) {
        _menus.add({
          'menu_id': row['menu_id'],
          'menu_name': row['menu_name'],
          'menu_logo': '${_baseURL}images/menu/${row['menu_logo']}',
        });
      }

      update(true); // Callback to inform that we completed retrieving data
    }
  } catch (e) {
    update(false); // Inform through callback that we failed to get data
  }
}
