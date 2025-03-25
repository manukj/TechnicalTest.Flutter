import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/post_list_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'offline_posts_bloc_test.mocks.dart';

@GenerateMocks([PostListUseCase])
void main() {
  late MockPostListUseCase mockPostListUseCase;
  late OfflinePostsBloc bloc;

  setUp(() {
    mockPostListUseCase = MockPostListUseCase();
    bloc = OfflinePostsBloc(postListUseCase: mockPostListUseCase);
  });

  const tPosts = [
    Post(id: 1, userId: 1, title: 'Test title 1', body: 'Test body 1'),
    Post(id: 2, userId: 1, title: 'Test title 2', body: 'Test body 2'),
  ];

  group('FetchOfflinePostsEvent', () {
    test('should emit [LoadingState, ContentState] when data is fetched successfully',
        () async {
      
      when(mockPostListUseCase.getOfflinePosts())
          .thenAnswer((_) async => tPosts);

      
      final expected = [
        const LoadingState<List<Post>>(),
       const ContentState<List<Post>>(tPosts),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      
      bloc.add(const FetchOfflinePostsEvent());
    });

    test('should emit [LoadingState, ErrorState] when fetching data fails',
        () async {
      
      when(mockPostListUseCase.getOfflinePosts())
          .thenThrow(Exception('Database error'));

      
      final expected = [
        const LoadingState<List<Post>>(),
        isA<ErrorState<List<Post>>>(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      
      bloc.add(const FetchOfflinePostsEvent());
    });
  });

  group('SavePostOfflineEvent', () {
    test('should call use case to save post and then fetch posts', () async {
      
      when(mockPostListUseCase.savePostOffline(any))
          .thenAnswer((_) async => {});
      when(mockPostListUseCase.getOfflinePosts())
          .thenAnswer((_) async => tPosts);
      
      
      bloc.add(SavePostOfflineEvent(tPosts[0]));
      await untilCalled(mockPostListUseCase.getOfflinePosts());
      
      
      verify(mockPostListUseCase.savePostOffline(tPosts[0]));
      verify(mockPostListUseCase.getOfflinePosts());
    });
  });

  group('RemovePostOfflineEvent', () {
    test('should call use case to remove post and then fetch posts', () async {
      
      when(mockPostListUseCase.removePostOffline(any))
          .thenAnswer((_) async => {});
      when(mockPostListUseCase.getOfflinePosts())
          .thenAnswer((_) async => tPosts);
      
      
      bloc.add(const RemovePostOfflineEvent(1));
      await untilCalled(mockPostListUseCase.getOfflinePosts());
      
      
      verify(mockPostListUseCase.removePostOffline(1));
      verify(mockPostListUseCase.getOfflinePosts());
    });
  });
}
