import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/post_list_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_list_usecase_test.mocks.dart';

@GenerateMocks([PostRepository, OfflinePostsRepository])
void main() {
  late PostListUseCase usecase;
  late MockPostRepository mockPostRepository;
  late MockOfflinePostsRepository mockOfflinePostsRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    mockOfflinePostsRepository = MockOfflinePostsRepository();
    usecase = PostListUseCase(mockPostRepository, mockOfflinePostsRepository);
  });

  const testPost = Post(id: 1, userId: 1, title: 'Test', body: 'Test body');
  final testPosts = [testPost];

  group('getPosts', () {
    test('should get posts from the repository', () async {
      when(mockPostRepository.getPosts())
          .thenAnswer((_) async => Right(testPosts));

      final result = await usecase.getPosts();

      
      expect(result, Right(testPosts));
      verify(mockPostRepository.getPosts());
      verifyNoMoreInteractions(mockPostRepository);
    });
  });

  group('getOfflinePosts', () {
    test('should get offline posts from the repository', () async {
      when(mockOfflinePostsRepository.getOfflinePosts())
          .thenAnswer((_) async => testPosts);

      final result = await usecase.getOfflinePosts();

      
      expect(result, testPosts);
      verify(mockOfflinePostsRepository.getOfflinePosts());
      verifyNoMoreInteractions(mockOfflinePostsRepository);
    });
  });

  group('savePostOffline', () {
    test('should call the repository to save a post offline', () async {
      when(mockOfflinePostsRepository.savePostOffline(any))
          .thenAnswer((_) async => {});

      await usecase.savePostOffline(testPost);

      
      verify(mockOfflinePostsRepository.savePostOffline(testPost));
      verifyNoMoreInteractions(mockOfflinePostsRepository);
    });
  });

  group('removePostOffline', () {
    test('should call the repository to remove a post offline', () async {
      when(mockOfflinePostsRepository.removePostOffline(any))
          .thenAnswer((_) async => {});

      await usecase.removePostOffline(1);

      
      verify(mockOfflinePostsRepository.removePostOffline(1));
      verifyNoMoreInteractions(mockOfflinePostsRepository);
    });
  });
}
