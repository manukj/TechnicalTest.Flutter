import 'package:flutter/material.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';

class CommentListItem extends StatelessWidget {
  final Comment comment;

  const CommentListItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              comment.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(comment.body),
          ],
        ),
      ),
    );
  }
} 