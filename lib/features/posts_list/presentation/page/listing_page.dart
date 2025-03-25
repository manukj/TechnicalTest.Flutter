import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/offline_posts_tab.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/posts_tab.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load data when page opens
    context.read<PostsBloc>().add(const FetchPostsEvent());
    context.read<OfflinePostsBloc>().add(const FetchOfflinePostsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'Posts'),
            BlocBuilder<OfflinePostsBloc, BaseState<List<Post>>>(
              builder: (context, state) {
                int count = 0;
                if (state is ContentState<List<Post>>) {
                  count = state.data.length;
                }
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Saved Posts'),
                      if (count > 0) ...[
                        const SizedBox(width: 4),
                        Badge(
                          label: Text('$count'),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PostsTab(),
          OfflinePostsTab(),
        ],
      ),
    );
  }
}
