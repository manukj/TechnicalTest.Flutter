import 'package:flutter_tech_task/data/datasources/post_local_datasource.dart';
import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:flutter_tech_task/data/repositories/offline_posts_repository_impl.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for PostLocalDataSource
@GenerateMocks([PostLocalDataSource])
import 'offline_posts_repository_impl_test.mocks.dart';

void main() {
  late OfflinePostsRepositoryImpl repository;
  late MockPostLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPostLocalDataSource();
    repository = OfflinePostsRepositoryImpl(mockDataSource);
  });

  const tPost = Post(
    id: 1,
    title: 'Test Post',
    body: 'Test Body',
    userId: 1,
  );

  group('OfflinePostsRepositoryImpl', () {
    test('should save post to local storage', () async {
      await repository.savePostOffline(tPost);

      verify(mockDataSource.savePostOffline(any)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should remove post from local storage', () async {
      await repository.removePostOffline(tPost.id);

      verify(mockDataSource.removePostOffline(tPost.id)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should get all posts from local storage', () async {
      final tOfflinePostModels = [
        OfflinePostModel.fromPost(tPost),
        OfflinePostModel.fromPost(
          const Post(
            id: 2,
            title: 'Test Post 2',
            body: 'Test Body 2',
            userId: 2,
          ),
        ),
      ];
      when(mockDataSource.getOfflinePosts())
          .thenAnswer((_) async => tOfflinePostModels);

      final result = await repository.getOfflinePosts();

      expect(result, tOfflinePostModels.map((model) => model.toPost()).toList());
      verify(mockDataSource.getOfflinePosts()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return empty list when no posts in local storage', () async {
      when(mockDataSource.getOfflinePosts())
          .thenAnswer((_) async => []);

      final result = await repository.getOfflinePosts();

      expect(result, isEmpty);
      verify(mockDataSource.getOfflinePosts()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
