import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/routes/app_routes.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Container(
        color: Colors.blue[100],
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context, 
                AppRoutes.details, 
                arguments: {'postId': 1}
              );
            },
            child: const Text('Go to Details'),
          ),
        ),
      ),
    );
  }
} 