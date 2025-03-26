import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/extensions/context_extensions.dart';
import 'package:flutter_tech_task/core/widgets/lce_handler.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/post_item.dart';

class OfflinePostsTab extends StatelessWidget {
  const OfflinePostsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OfflinePostsBloc>().add(const FetchOfflinePostsEvent());
      },
      child: BlocBuilder<OfflinePostsBloc, BaseState<List<Post>>>(
        builder: (context, state) {
          return LceHandler<List<Post>>(
            state: state,
            contentBuilder: (posts) => _buildSavedPostsList(context, posts),
            emptyBuilder: () => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(context.tr.noPosts),
                  const SizedBox(height: 8),
                  Text(
                    context.tr.bookmarkToSee,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedPostsList(BuildContext context, List<Post> posts) {
    final offlinePostsBloc = context.read<OfflinePostsBloc>();
    
    return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final post = posts[index];
        
        return PostItem(
          post: post,
          isSaved: true,
          onSavePressed: () {
            offlinePostsBloc.add(RemovePostOfflineEvent(post.id));
          },
        );
      },
    );
  }
} 