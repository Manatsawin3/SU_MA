import 'package:flutter/material.dart';

class Textformscreen extends StatefulWidget {
  const Textformscreen({super.key});

  @override
  State<Textformscreen> createState() => _TextformscreenState();
}

class _TextformscreenState extends State<Textformscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  String password = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Textform Screen')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Display name : $name'),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อบัญชีของคุณ';
                }
              },
              onChanged: (String value) {
                setState(() {
                  name = value;
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    name = "Username : ${_nameController.text}";
                    password = "Password : ${_passwordController.text}";
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                  );
                }
              },
              child: Text('ลงชื่อเข้าใช้'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _passwordController.clear();
                setState(() {
                  name = '';
                  password = '';
                });
              },
              child: Text('ล้างข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
