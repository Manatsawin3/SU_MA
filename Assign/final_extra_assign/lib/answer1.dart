import 'package:flutter/material.dart';

class Answer1 extends StatefulWidget {
  const Answer1({super.key});

  @override
  State<Answer1> createState() => _Answer1State();
}

class CardWidget extends StatelessWidget {
  final String username;
  final String username_profile;
  final String userText;
  final String commenterName;
  final String commenterName_profile;
  final String commentText;
  final String time;
  const CardWidget({
    super.key,
    required this.username,
    required this.username_profile,
    required this.userText,
    required this.commenterName,
    required this.commenterName_profile,
    required this.commentText,
    required this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color.fromARGB(255, 245, 185, 255),
                child: Text(username_profile),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(username, style: TextStyle(fontWeight: FontWeight.bold),), Text(userText)],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.thumb_up, size: 18),
              ),
              Text('12'),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.comment_outlined, size: 18),
              ),
              Text('Reply'),
              Spacer(),
              Text(time),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color.fromARGB(255, 185, 233, 255),
                  child: Text(commenterName_profile),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commenterName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(commentText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Answer1State extends State<Answer1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comment Thread')),
      body: Column(
        children: [
          CardWidget(
            username: 'User A',
            username_profile: 'A',
            userText: 'This is the main comment. Flutter layouts are fun!',
            commenterName: 'User B',
            commenterName_profile: 'B',
            commentText: 'I agree!',
            time: '1h ago',
          ),
        ],
      ),
    );
  }
}
