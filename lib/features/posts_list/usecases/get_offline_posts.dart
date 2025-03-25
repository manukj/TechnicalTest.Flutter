import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOfflinePosts {
  final OfflinePostsRepository repository;

  GetOfflinePosts(this.repository);

  Future<List<Post>> call() async {
    return await repository.getOfflinePosts();
  }
} 