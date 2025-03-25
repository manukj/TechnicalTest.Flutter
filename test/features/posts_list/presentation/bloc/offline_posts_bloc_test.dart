import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/get_offline_posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'offline_posts_bloc_test.mocks.dart';

@GenerateMocks([GetOfflinePosts])
void main() {
  late MockGetOfflinePosts mockGetOfflinePosts;
  late OfflinePostsBloc bloc;

  setUp(() {
    mockGetOfflinePosts = MockGetOfflinePosts();
    bloc = OfflinePostsBloc(getOfflinePosts: mockGetOfflinePosts);
  });

  const tPosts = [
    Post(id: 1, userId: 1, title: 'Test title 1', body: 'Test body 1'),
    Post(id: 2, userId: 1, title: 'Test title 2', body: 'Test body 2'),
  ];

  group('FetchOfflinePostsEvent', () {
    test(
        'should emit [LoadingState, ContentState] when data is fetched successfully',
        () async {
      when(mockGetOfflinePosts()).thenAnswer((_) async => tPosts);

      final expected = [
        const LoadingState<List<Post>>(),
        const ContentState<List<Post>>(tPosts),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const FetchOfflinePostsEvent());
    });

    test('should emit [LoadingState, ErrorState] when fetching data fails',
        () async {
      when(mockGetOfflinePosts()).thenThrow(Exception('Database error'));

      final expected = [
        const LoadingState<List<Post>>(),
        isA<ErrorState<List<Post>>>(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const FetchOfflinePostsEvent());
    });
  });
}
