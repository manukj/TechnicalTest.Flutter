import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/domain/usecases/get_post_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_post_by_id_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late GetPostById usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPostById(mockPostRepository);
  });

  const tId = 1;
  const tPost =
      Post(id: tId, title: 'Test Title', body: 'Test Body', userId: 1);

  test(
    'should get post by id from the repository',
    () async {
      when(mockPostRepository.getPostById(tId))
          .thenAnswer((_) async => const Right(tPost));

      final result = await usecase(const Params(id: tId));

      expect(result, const Right(tPost));
      verify(mockPostRepository.getPostById(tId));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );

  test(
    'should return server failure when repository returns failure',
    () async {
      final failure = APIFailure(message: 'API error', statusCode: 500);
      when(mockPostRepository.getPostById(tId))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(const Params(id: tId));

      expect(result, Left(failure));
      verify(mockPostRepository.getPostById(tId));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );

  test(
    'should pass the Params to the repository correctly',
    () async {
      const differentId = 42;
      when(mockPostRepository.getPostById(differentId))
          .thenAnswer((_) async => const Right(tPost));

      await usecase(const Params(id: differentId));

      verify(mockPostRepository.getPostById(differentId));
      verifyNever(mockPostRepository
          .getPostById(tId)); // Ensure the original ID was not used
    },
  );
}
