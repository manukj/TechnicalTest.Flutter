import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostListUseCase {
  final PostRepository postRepository;
  final OfflinePostsRepository offlinePostsRepository;

  PostListUseCase(this.postRepository, this.offlinePostsRepository);

  // Online posts
  Future<Either<Failure, List<Post>>> getPosts() async {
    return await postRepository.getPosts();
  }

  Future<Either<Failure, Post>> getPostById(int id) async {
    return await postRepository.getPostById(id);
  }

  // Offline posts
  Future<List<Post>> getOfflinePosts() async {
    return await offlinePostsRepository.getOfflinePosts();
  }

  Future<void> savePostOffline(Post post) async {
    return await offlinePostsRepository.savePostOffline(post);
  }

  Future<void> removePostOffline(int postId) async {
    return await offlinePostsRepository.removePostOffline(postId);
  }
} 