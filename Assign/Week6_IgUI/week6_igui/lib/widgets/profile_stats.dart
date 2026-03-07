import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/5/5a/John_Doe%2C_born_John_Nommensen_Duchac.jpg",
                fit: BoxFit.cover, // Ensures the image fills the circle
              ),
            ),
          ),
          Container(
            child: Column(
              children: const [
                Text(
                  '150',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Posts'),
              ],
            ),
          ),
          Container(
            child: Column(
              children: const [
                Text(
                  '200',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Followers'),
              ],
            ),
          ),
          Container(
            child: Column(
              children: const [
                Text(
                  '50',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Following'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
