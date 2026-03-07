import 'package:flutter/material.dart';
import '../widgets/action_buttons.dart';
import '../widgets/post_grid.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('John Doe'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileStats(),
          const ProfileHeader(),
          const ActionButtons(),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: [
              PostGrid(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRonwTr_u2kdoMppHjdHgb3wiBR4HjYM8X7-w&s",
              ),
              PostGrid(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYNDs4VuacHNRzUKr5WveHFtepxcjF7ZCl0g&s",
              ),
              PostGrid(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrDer3AHwDQ5t5k8meBYeyXVpwClXiUxddSQ&s",
              ),
              PostGrid(
                imageUrl:
                    "https://www.shutterstock.com/image-photo/closeup-shot-cat-sleepy-judgmental-600nw-2632517633.jpg",
              ),
              PostGrid(
                imageUrl:
                    "https://cdn-useast1.kapwing.com/static/templates/crying-cat-meme-template-full-719a53dc.webp",
              ),
              PostGrid(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSF5EmOMKXYngYyAbipAejzp-ikfYw4PmDH0g&s",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
