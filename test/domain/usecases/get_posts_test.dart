import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/domain/usecases/get_posts.dart';
import 'package:flutter_tech_task/domain/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_posts_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late GetPosts usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPosts(mockPostRepository);
  });

  final tPosts = [
    const Post(id: 1, title: 'Test Title 1', body: 'Test Body 1', userId: 1),
    const Post(id: 2, title: 'Test Title 2', body: 'Test Body 2', userId: 2),
  ];

  test(
    'should get list of posts from the repository',
    () async {
      // arrange
      when(mockPostRepository.getPosts())
          .thenAnswer((_) async => Right(tPosts));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(tPosts));
      verify(mockPostRepository.getPosts());
      verifyNoMoreInteractions(mockPostRepository);
    },
  );

  test(
    'should return server failure when repository returns failure',
    () async {
      // arrange
      final failure = APIFailure(message: 'API error', statusCode: 500);
      when(mockPostRepository.getPosts())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Left(failure));
      verify(mockPostRepository.getPosts());
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
} 