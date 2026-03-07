import 'package:flutter/material.dart';

class PostGrid extends StatelessWidget {
  final String imageUrl;
  const PostGrid({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
