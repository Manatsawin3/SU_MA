import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/public/Productdata.dart';
import 'package:http/http.dart' as http;

class ProductAPIscreen extends StatefulWidget {
  const ProductAPIscreen({super.key});

  @override
  State<ProductAPIscreen> createState() => _ProductAPIscreenState();
}

class _ProductAPIscreenState extends State<ProductAPIscreen> {
  List<Product> listproduct = [];
  Future<void> fetchdata() async {
    try {
      var response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body)['products'];
        setState(() {
          listproduct = jsonList.map((json) => Product.fromJson(json)).toList();
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call API')),
      body: ListView.separated(
        itemCount: listproduct.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text('ID ${listproduct[index].id}'),
            title: Text(
              '${listproduct[index].name} ${listproduct[index].description} ${listproduct[index].price}',
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          fetchdata();
        },
        child: Text('Call API'),
      ),
    );
  }
}
