import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/get_posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([PostRepository])
import 'get_posts_test.mocks.dart';

void main() {
  late GetPosts usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPosts(mockPostRepository);
  });

  final tPosts = [
    const Post(
      id: 1,
      title: 'Test Post',
      body: 'Test Body',
      userId: 1,
    ),
  ];

  test('should get posts from the repository', () async {
    when(mockPostRepository.getPosts()).thenAnswer((_) async => Right(tPosts));

    final result = await usecase(NoParams());

    expect(result, Right(tPosts));
    verify(mockPostRepository.getPosts());
    verifyNoMoreInteractions(mockPostRepository);
  });

  test('should return a failure when repository fails', () async {
    final failure = APIFailure(message: 'API error', statusCode: 500);
    when(mockPostRepository.getPosts())
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(NoParams());

    expect(result, Left(failure));
    verify(mockPostRepository.getPosts());
    verifyNoMoreInteractions(mockPostRepository);
  });
} 