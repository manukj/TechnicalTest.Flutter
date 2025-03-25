import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/widgets/lce_handler.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/post_item.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostsBloc>().add(const FetchPostsEvent());
      },
      child: BlocBuilder<PostsBloc, BaseState<List<Post>>>(
        builder: (context, state) {
          return LceHandler<List<Post>>(
            state: state,
            contentBuilder: (posts) => _buildPostsList(context, posts),
            emptyBuilder: () => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('No posts available'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostsList(BuildContext context, List<Post> posts) {
    final offlinePostsBloc = context.read<OfflinePostsBloc>();
    
    return BlocBuilder<OfflinePostsBloc, BaseState<List<Post>>>(
      builder: (context, offlineState) {
        final offlinePosts = offlineState is ContentState<List<Post>>
            ? offlineState.data
            : <Post>[];
        
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final post = posts[index];
            final isSaved = offlinePosts.any((p) => p.id == post.id);
            
            return PostItem(
              post: post,
              isSaved: isSaved,
              onSavePressed: () {
                if (isSaved) {
                  offlinePostsBloc.add(RemovePostOfflineEvent(post.id));
                } else {
                  offlinePostsBloc.add(SavePostOfflineEvent(post));
                }
              },
            );
          },
        );
      },
    );
  }
} 