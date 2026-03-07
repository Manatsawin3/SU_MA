import 'package:flutter/material.dart';

class Optionscreen extends StatefulWidget {
  const Optionscreen({super.key});

  @override
  State<Optionscreen> createState() => _OptionscreenState();
}

class _OptionscreenState extends State<Optionscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectItem;
  String? _gender = 'Female';
  List<String> _options = ['Male', 'Female', 'Other'];
  bool _isChecked = false;
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Option Screen'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 213, 255, 165),
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Select Gender'),
              items: _options.map((String option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectItem = value;
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
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _isSwitched,
              onChanged: (bool value) {
                setState(() {
                  _isSwitched = value;
                });
              },
            ),
            SizedBox(height: 20),
            Column(
              children: [
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
                RadioListTile(
                  value: 'Other',
                  title: const Text('Other'),
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as String;
                    });
                  },
                ),
              ],
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
    );
  }
}
