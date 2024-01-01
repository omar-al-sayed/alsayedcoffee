import 'package:alsayed/common_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class ShowItems extends StatefulWidget {
  final String selectedMenu;

  const ShowItems({Key? key, required this.selectedMenu}) : super(key: key);

  @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  bool _load = false;
  final List<Map<String, dynamic>> _items = [];
  final String _baseURL = 'https://alsayedcoffee.000webhostapp.com/';

  @override
  void initState() {
    super.initState();
    updateItems(update);
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
        title: const Text('Available Items'),
        centerTitle: true,
      ),
      drawer: CommonDrawer(),
      body: _load
          ? ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item['item_name']),
            subtitle: Text('Price: \$${item['item_price']}'),
            leading: Image.network(item['item_image']),
          );
        },
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

  void updateItems(Function(bool success) update) async {
    try {
      final url = Uri.parse('$_baseURL/getItem.php?menu_id=${widget.selectedMenu}');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      _items.clear(); // Clear old items

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        for (var row in jsonResponse) {
          _items.add({
            'item_name': row['item_name'],
            'item_price': row['item_price'],
            'item_image': '${_baseURL}${row['item_image']}',
          });
        }

        update(true); // Callback to inform that we completed retrieving data
      }
    } catch (e) {
      update(false); // Inform through callback that we failed to get data
    }
  }
}
