import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CallAPIScreen extends StatefulWidget {
  const CallAPIScreen({super.key});

  @override
  State<CallAPIScreen> createState() => _CallAPIScreenState();
}

class _CallAPIScreenState extends State<CallAPIScreen> {
  List<dynamic> listUser = [];
  void getUser() async {
    try {
      var response = await http.get(Uri.parse('https://dummyjson.com/user'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> jsonList = data['users'];
        setState(() {
          listUser = jsonList;
        });
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
        itemCount: listUser.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text('ID ${listUser[index]['id']}'),
            title: Text(
              '${listUser[index]['firstName']} ${listUser[index]['lastName']}',
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          getUser();
        },
        child: Text('Call API'),
      ),
    );
  }
}
