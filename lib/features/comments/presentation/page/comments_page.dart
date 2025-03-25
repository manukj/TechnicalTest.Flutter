import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final postId = args?['postId'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Container(
        color: Colors.amber[100],
        child: Center(
          child: Text(
            'Comments for Post ID: $postId',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
} 