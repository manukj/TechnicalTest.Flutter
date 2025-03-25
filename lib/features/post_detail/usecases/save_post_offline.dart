import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SavePostOffline {
  final OfflinePostsRepository repository;

  SavePostOffline(this.repository);

  Future<void> call(Post post) async {
    await repository.savePostOffline(post);
  }
} 