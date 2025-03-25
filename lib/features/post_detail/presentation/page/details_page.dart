import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/routes/app_routes.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final postId = args?['postId'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Container(
        color: Colors.green[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Post ID: $postId', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.comments, 
                    arguments: {'postId': postId}
                  );
                },
                child: const Text('View Comments'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // This would save the post offline
                },
                child: const Text('Save Offline'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 