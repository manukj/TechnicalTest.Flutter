import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/domain/usecases/get_comments_by_post_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_comments_by_post_id_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late GetCommentsByPostId usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetCommentsByPostId(mockPostRepository);
  });

  const tPostId = 1;
  final tComments = [
    const Comment(id: 1, postId: tPostId, name: 'Name 1', email: 'email1@test.com', body: 'Body 1'),
    const Comment(id: 2, postId: tPostId, name: 'Name 2', email: 'email2@test.com', body: 'Body 2'),
  ];

  test(
    'should get comments by post id from the repository',
    () async {
      // arrange
      when(mockPostRepository.getCommentsByPostId(tPostId))
          .thenAnswer((_) async => Right(tComments));

      // act
      final result = await usecase(const PostIdParam(postId: tPostId));

      // assert
      expect(result, Right(tComments));
      verify(mockPostRepository.getCommentsByPostId(tPostId));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );

  test(
    'should return server failure when repository returns failure',
    () async {
      // arrange
      final failure = APIFailure(message: 'API error', statusCode: 500);
      when(mockPostRepository.getCommentsByPostId(tPostId))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(const PostIdParam(postId: tPostId));

      // assert
      expect(result, Left(failure));
      verify(mockPostRepository.getCommentsByPostId(tPostId));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );

  test(
    'should pass the PostIdParam to the repository correctly',
    () async {
      // arrange
      const differentPostId = 42;
      when(mockPostRepository.getCommentsByPostId(differentPostId))
          .thenAnswer((_) async => Right(tComments));

      // act
      await usecase(const PostIdParam(postId: differentPostId));

      // assert
      verify(mockPostRepository.getCommentsByPostId(differentPostId));
      verifyNever(mockPostRepository.getCommentsByPostId(tPostId)); // Ensure the original postId was not used
    },
  );
} 