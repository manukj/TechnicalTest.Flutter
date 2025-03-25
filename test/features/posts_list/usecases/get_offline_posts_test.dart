import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/get_offline_posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([OfflinePostsRepository])
import 'get_offline_posts_test.mocks.dart';

void main() {
  late GetOfflinePosts usecase;
  late MockOfflinePostsRepository mockRepository;

  setUp(() {
    mockRepository = MockOfflinePostsRepository();
    usecase = GetOfflinePosts(mockRepository);
  });

  final tPosts = [
    const Post(
      id: 1,
      title: 'Test Post 1',
      body: 'Test Body 1',
      userId: 1,
    ),
    const Post(
      id: 2,
      title: 'Test Post 2',
      body: 'Test Body 2',
      userId: 2,
    ),
  ];

  test('should get all posts from offline storage', () async {
    when(mockRepository.getOfflinePosts()).thenAnswer((_) async => tPosts);

    final result = await usecase();

    expect(result, tPosts);
    verify(mockRepository.getOfflinePosts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when no posts in offline storage', () async {
    when(mockRepository.getOfflinePosts()).thenAnswer((_) async => []);

    final result = await usecase();

    expect(result, isEmpty);
    verify(mockRepository.getOfflinePosts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
} 