import 'package:flutter_tech_task/domain/entities/post.dart';

abstract class OfflinePostsRepository {
  Future<void> savePostOffline(Post post);
  Future<void> removePostOffline(int postId);
  Future<List<Post>> getOfflinePosts();
} 