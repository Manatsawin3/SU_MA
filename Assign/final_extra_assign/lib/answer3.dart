import 'package:flutter/material.dart';

class Answer3 extends StatefulWidget {
  const Answer3({super.key});

  @override
  State<Answer3> createState() => _Answer3State();
}

class _Answer3State extends State<Answer3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int totalPrice = 0;
  int basePrice = 150;
  bool vacuum = false;
  bool wax = false;

  int calculateTotalPrice() {
    int totalPrice = basePrice;
    if (vacuum) {
      totalPrice += 50;
    }
    if (wax) {
      totalPrice += 100;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('คํานวณค่าบริการล้างรถ')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'ขนาดรถ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 150,
                  child: Text("รถเล็ก (Small) - 150 บาท"),
                ),
                DropdownMenuItem(
                  value: 200,
                  child: Text("รถเก๋ง (Medium) - 200 บาท"),
                ),
                DropdownMenuItem(
                  value: 250,
                  child: Text("รถ SUV/กระบะ (Large) - 250 บาท"),
                ),
              ],
              onChanged: (int? newValue) {
                setState(() {
                  basePrice = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('ดูดฝุ่น (+50 บาท)'),
              value: vacuum,
              onChanged: (bool? value) {
                setState(() {
                  vacuum = value!;
                });
              },
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('เคลือบแว็กซ์ (+100 บาท)'),
              value: wax,
              onChanged: (bool? value) {
                setState(() {
                  wax = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Center(child: Text('รวม: $totalPrice บาท')),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  totalPrice = calculateTotalPrice();
                });
              },
              child: Text('คํานวณราคา'),
            ),
          ],
        ),
      ),
    );
  }
}
