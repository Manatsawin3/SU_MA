import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/public/Userdata.dart';
import 'package:http/http.dart' as http;

class UserAPIScreen extends StatefulWidget {
  const UserAPIScreen({super.key});

  @override
  State<UserAPIScreen> createState() => _UserAPIScreenState();
}

class _UserAPIScreenState extends State<UserAPIScreen> {
  List<dynamic> listUser = [];
  List<User> listUserV2 = [];
  void getUser() async {
    try {
      var response = await http.get(Uri.parse('https://dummyjson.com/user'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> jsonList = data['users'];
        setState(() {
          listUser = jsonList;
          listUserV2 = jsonList.map((e) => User.fromJson(e)).toList();
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
        itemCount: listUserV2.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text('ID ${listUserV2[index].id}'),
            title: Text(
              '${listUserV2[index].firstname} ${listUserV2[index].lastname}',
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
