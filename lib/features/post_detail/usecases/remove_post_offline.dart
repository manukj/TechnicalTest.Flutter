import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemovePostOffline {
  final OfflinePostsRepository repository;

  RemovePostOffline(this.repository);

  Future<void> call(int postId) async {
    await repository.removePostOffline(postId);
  }
} 