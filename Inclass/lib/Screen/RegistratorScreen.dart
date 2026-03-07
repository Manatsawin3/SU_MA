import 'package:flutter/material.dart';

class Registratorscreen extends StatefulWidget {
  const Registratorscreen({super.key});

  @override
  State<Registratorscreen> createState() => _RegistratorscreenState();
}

class _RegistratorscreenState extends State<Registratorscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String fullname = '';
  String email = '';
  String? _gender = 'Male';
  bool _isChecked = false;
  String? _province;
  List<String> _provincesOption = ['Bangkok', 'Chiang Mai', 'Phuket'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 213, 255, 165),
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ-นามสกุล';
                  }
                },
                onChanged: (String value) {
                  setState(() {
                    fullname = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                },
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Gender'),
              RadioListTile(
                value: 'Male',
                title: const Text('Male'),
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value as String;
                  });
                },
              ),
              SizedBox(height: 20),
              RadioListTile(
                value: 'Female',
                title: const Text('Female'),
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value as String;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Select Province'),
                items: _provincesOption.map((String option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _province = value;
                  });
                },
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('Accept Terms and Conditions'),
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
