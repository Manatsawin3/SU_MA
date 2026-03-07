import 'package:flutter/material.dart';

class Profilescreen extends StatefulWidget {
  final String username;
  final String password;
  final String firstname;
  final String lastname;

  const Profilescreen({
    super.key,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
  });

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 213, 255, 165),
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 213, 255, 165),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: const Color.fromARGB(255, 111, 181, 78),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'สมัครสมาชิกสำเร็จ',
                    style: TextStyle(
                      fontSize: 25,
                      color: const Color.fromARGB(255, 111, 181, 78),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Username: ${widget.username}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Password: ${widget.password}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'First Name: ${widget.firstname}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Last Name: ${widget.lastname}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
