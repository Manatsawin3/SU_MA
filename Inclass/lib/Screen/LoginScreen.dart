import 'package:flutter/material.dart';
import 'package:flutter_application_2/Screen/ProfileScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  String username = '';
  String password = '';
  String firstname = '';
  String lastname = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 213, 255, 165),
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อผู้ใช้';
                }
              },
              onChanged: (String value) {
                setState(() {
                  username = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกรหัสผ่าน';
                }
              },
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty || value != password) {
                  return 'กรุณากรอกรหัสผ่านอีกครั้ง';
                }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Firstname',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อจริง';
                }
              },
              onChanged: (String value) {
                setState(() {
                  firstname = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lastname',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกนามสกุล';
                }
              },
              onChanged: (String value) {
                setState(() {
                  lastname = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    username = _usernameController.text;
                    password = _passwordController.text;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profilescreen(
                        username: username,
                        password: password,
                        firstname: firstname,
                        lastname: lastname,
                      ),
                    ),
                  );
                }
              },
              child: Text('สมัครสมาชิก'),
            ),
          ],
        ),
      ),
    );
  }
}
