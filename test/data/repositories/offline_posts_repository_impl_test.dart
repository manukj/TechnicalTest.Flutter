import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:flutter_tech_task/data/repositories/offline_posts_repository_impl.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Box])
import 'offline_posts_repository_impl_test.mocks.dart';

void main() {
  late OfflinePostsRepositoryImpl repository;
  late MockBox<OfflinePostModel> mockBox;

  setUp(() {
    mockBox = MockBox<OfflinePostModel>();
    repository = OfflinePostsRepositoryImpl(mockBox);
  });

  const tPost = Post(
    id: 1,
    title: 'Test Post',
    body: 'Test Body',
    userId: 1,
  );

  group('OfflinePostsRepositoryImpl', () {
    test('should save post to Hive box', () async {
      await repository.savePostOffline(tPost);

      verify(mockBox.put(tPost.id, any)).called(1);
      verifyNoMoreInteractions(mockBox);
    });

    test('should remove post from Hive box', () async {
      await repository.removePostOffline(tPost.id);

      verify(mockBox.delete(tPost.id)).called(1);
      verifyNoMoreInteractions(mockBox);
    });

    test('should get all posts from Hive box', () async {
      final tOfflinePosts = [
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
      when(mockBox.values).thenReturn(tOfflinePosts);

      final result = await repository.getOfflinePosts();

      expect(result, tOfflinePosts.map((model) => model.toPost()).toList());
      verify(mockBox.values).called(1);
      verifyNoMoreInteractions(mockBox);
    });

    test('should return empty list when no posts in Hive box', () async {
      when(mockBox.values).thenReturn([]);

      final result = await repository.getOfflinePosts();

      expect(result, isEmpty);
      verify(mockBox.values).called(1);
      verifyNoMoreInteractions(mockBox);
    });
  });
}
