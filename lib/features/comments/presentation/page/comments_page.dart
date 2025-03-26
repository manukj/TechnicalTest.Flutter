import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/widgets/lce_handler.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:flutter_tech_task/features/comments/presentation/widgets/comment_item.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late int postId;
  late bool isSavedPost;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    postId = args?['postId'] ?? 0;
    isSavedPost = args?['isSaved'] ?? false;

    context
        .read<CommentsBloc>()
        .add(FetchCommentsByPostIdEvent(postId: postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          if (isSavedPost)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.bookmark,
                color: Colors.blue,
              ),
            ),
        ],
      ),
      body: BlocBuilder<CommentsBloc, BaseState<List<Comment>>>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<CommentsBloc>()
                  .add(FetchCommentsByPostIdEvent(postId: postId));
            },
            child: LceHandler<List<Comment>>(
              state: state,
              contentBuilder: (comments) => _buildCommentsList(comments),
              emptyBuilder: () => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.comment_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No comments for this post',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentsList(List<Comment> comments) {
    return ListView.builder(
      itemCount: comments.length,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return CommentItem(comment: comments[index]);
      },
    );
  }
}
