import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/domain/repositories/comment_repository.dart';
import 'package:flutter_tech_task/features/comments/usecases/get_comments_by_post_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([CommentRepository])
import 'get_comments_by_post_id_test.mocks.dart';

void main() {
  late GetCommentsByPostId usecase;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    usecase = GetCommentsByPostId(mockCommentRepository);
  });

  const tPostId = 1;
  const tComments = [
    Comment(
      id: 1,
      postId: tPostId,
      name: 'Test Comment',
      email: 'test@example.com',
      body: 'Test Body',
    ),
    Comment(
      id: 2,
      postId: tPostId,
      name: 'Test Comment 2',
      email: 'test2@example.com',
      body: 'Test Body 2',
    ),
  ];

  test('should get comments by post id from the repository', () async {
    when(mockCommentRepository.getCommentsByPostId(tPostId))
        .thenAnswer((_) async =>const Right(tComments));

    final result = await usecase(const CommentParams(postId: tPostId));

    expect(result,const Right(tComments));
    verify(mockCommentRepository.getCommentsByPostId(tPostId));
    verifyNoMoreInteractions(mockCommentRepository);
  });

  test('should return a failure when repository fails', () async {
    final failure = APIFailure(message: 'API error', statusCode: 404);
    when(mockCommentRepository.getCommentsByPostId(tPostId))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(const CommentParams(postId: tPostId));

    expect(result, Left(failure));
    verify(mockCommentRepository.getCommentsByPostId(tPostId));
    verifyNoMoreInteractions(mockCommentRepository);
  });

  test('should handle different post id', () async {
    const differentPostId = 2;
    const differentComments = [
      Comment(
        id: 3,
        postId: differentPostId,
        name: 'Different Comment',
        email: 'different@example.com',
        body: 'Different Body',
      ),
    ];
    
    when(mockCommentRepository.getCommentsByPostId(differentPostId))
        .thenAnswer((_) async =>const Right(differentComments));

    await usecase(const CommentParams(postId: differentPostId));

    verify(mockCommentRepository.getCommentsByPostId(differentPostId));
    verifyNever(mockCommentRepository.getCommentsByPostId(tPostId));
  });
} 