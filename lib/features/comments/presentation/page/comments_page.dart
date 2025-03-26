import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/extensions/context_extensions.dart';
import 'package:flutter_tech_task/core/widgets/lce_handler.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:flutter_tech_task/features/comments/presentation/widgets/comment_item.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late final int postId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    postId = args['postId'] as int;
    context.read<CommentsBloc>().add(FetchCommentsByPostId(postId));
  }

  void _toggleSaveAllComments(List<Comment> comments) {
    final state = context.read<CommentsBloc>().state;

    if (state is ContentState<List<Comment>>) {
      if (state.isFromCache) {
        context.read<CommentsBloc>().add(RemoveCommentsEvent(postId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr.commentsRemoved)),
        );
      } else {
        context.read<CommentsBloc>().add(SaveCommentsEvent(postId, comments));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr.commentsSaved)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.comments),
      ),
      floatingActionButton: BlocBuilder<CommentsBloc, BaseState<List<Comment>>>(
        builder: (context, state) {
          if (state is ContentState<List<Comment>> && state.data.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () => _toggleSaveAllComments(state.data),
              icon: Icon(
                state.isFromCache
                    ? Icons.bookmark_remove_rounded
                    : Icons.bookmark_add_rounded,
                size: 24,
                color: state.isFromCache
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                state.isFromCache
                    ? context.tr.removeFromSaved
                    : context.tr.saveForOffline,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: state.isFromCache
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              backgroundColor: state.isFromCache
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.primaryContainer,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<CommentsBloc, BaseState<List<Comment>>>(
          builder: (context, state) {
        return LceHandler<List<Comment>>(
          state: state,
          onRetry: () =>
              context.read<CommentsBloc>().add(FetchCommentsByPostId(postId)),
          contentBuilder: (comments) => RefreshIndicator(
            onRefresh: () async {
              context.read<CommentsBloc>().add(FetchCommentsByPostId(postId));
            },
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentItem(comment: comments[index]);
              },
            ),
          ),
        );
      }),
    );
  }
}
