import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/post_list_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'posts_bloc_test.mocks.dart';

@GenerateMocks([PostListUseCase])
void main() {
  late MockPostListUseCase mockPostListUseCase;
  late PostsBloc bloc;

  setUp(() {
    mockPostListUseCase = MockPostListUseCase();
    bloc = PostsBloc(postListUseCase: mockPostListUseCase);
  });

  const tPosts = [
    Post(id: 1, userId: 1, title: 'Test title 1', body: 'Test body 1'),
    Post(id: 2, userId: 1, title: 'Test title 2', body: 'Test body 2'),
  ];

  group('FetchPostsEvent', () {
    test(
        'should emit [LoadingState, ContentState] when data is fetched successfully',
        () async {
      when(mockPostListUseCase.getPosts())
          .thenAnswer((_) async => const Right(tPosts));

      final expected = [
        const LoadingState<List<Post>>(),
        const ContentState<List<Post>>(tPosts),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const FetchPostsEvent());
    });

    test('should emit [LoadingState, ErrorState] when fetching data fails',
        () async {
      final failure = NetworkFailure(message: 'Network error');
      when(mockPostListUseCase.getPosts())
          .thenAnswer((_) async => Left(failure));

      final expected = [
        const LoadingState<List<Post>>(),
        ErrorState<List<Post>>(failure),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const FetchPostsEvent());
    });
  });
}
