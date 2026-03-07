import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class CallProductAPIScreen extends StatefulWidget {
  const CallProductAPIScreen({super.key});

  @override
  State<CallProductAPIScreen> createState() => _CallProductAPIScreenState();
}

class _CallProductAPIScreenState extends State<CallProductAPIScreen> {
  Future<void> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:3000/products'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        //code somthing...
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createProduct() async {
    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/products"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": "iPhone 5s",
          "description": "Apple smartphone",
          "price": 21999.00,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Create success!'),
            backgroundColor: Colors.green,
          ),
        );
        //code somthing...
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct({dynamic idUpdate = "5ac6"}) async {
    try {
      var response = await http.put(
        Uri.parse("http://localhost:3000/products/$idUpdate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": "iPhone 17",
          "description": "Apple smartphone",
          "price": 40900.00,
        }),
      );
      if (response.statusCode == 200) {
        //code somthing...
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct({dynamic idDelete = "b625"}) async {
    try {
      var response = await http.delete(
        Uri.parse("http://localhost:3000/products/$idDelete"),
      );
      if (response.statusCode == 200) {
        //code somthing...
      } else {
        throw Exception("Failed to delete products");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Example')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text('GET'),
            ),
            ElevatedButton(
              onPressed: () {
                createProduct();
              },
              child: Text('POST'),
            ),
            ElevatedButton(
              onPressed: () {
                updateProduct();
              },
              child: Text('PUT'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProduct();
              },
              child: Text('DELETE'),
            ),
          ],
        ),
      ),
    );
  }
}
