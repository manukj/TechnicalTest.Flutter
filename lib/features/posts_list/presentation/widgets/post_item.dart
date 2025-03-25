import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/routes/app_routes.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onSavePressed;
  final bool isSaved;

  const PostItem({
    Key? key,
    required this.post,
    this.onSavePressed,
    this.isSaved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context, 
            AppRoutes.details, 
            arguments: {'postId': post.id}
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onSavePressed != null) ...[
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.blue : null,
                      ),
                      onPressed: onSavePressed,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'User: ${post.userId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 