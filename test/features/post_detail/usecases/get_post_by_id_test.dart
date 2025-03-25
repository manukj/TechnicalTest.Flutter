import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/features/post_detail/usecases/get_post_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([PostRepository])
import 'get_post_by_id_test.mocks.dart';

void main() {
  late GetPostById usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPostById(mockPostRepository);
  });

  const tId = 1;
  final tPost = Post(
    id: tId,
    title: 'Test Post',
    body: 'Test Body',
    userId: 1,
  );

  test('should get post by id from the repository', () async {
    when(mockPostRepository.getPostById(tId))
        .thenAnswer((_) async => Right(tPost));

    final result = await usecase(PostParams(id: tId));

    expect(result, Right(tPost));
    verify(mockPostRepository.getPostById(tId));
    verifyNoMoreInteractions(mockPostRepository);
  });

  test('should return a failure when repository fails', () async {
    final failure = APIFailure(message: 'API error', statusCode: 404);
    when(mockPostRepository.getPostById(tId))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(PostParams(id: tId));

    expect(result, Left(failure));
    verify(mockPostRepository.getPostById(tId));
    verifyNoMoreInteractions(mockPostRepository);
  });

  test('should handle different id', () async {
    const differentId = 2;
    when(mockPostRepository.getPostById(differentId))
        .thenAnswer((_) async => const Right(Post(
              id: differentId,
              title: 'Different Post',
              body: 'Different Body',
              userId: 1,
            )));

    await usecase(PostParams(id: differentId));

    verify(mockPostRepository.getPostById(differentId));
    verifyNever(mockPostRepository.getPostById(tId));
  });
}
