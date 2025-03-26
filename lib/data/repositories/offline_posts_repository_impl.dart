import 'package:flutter_tech_task/data/datasources/post_local_datasource.dart';
import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OfflinePostsRepositoryImpl implements OfflinePostsRepository {
  final PostLocalDataSource dataSource;

  OfflinePostsRepositoryImpl(this.dataSource);

  @override
  Future<List<Post>> getOfflinePosts() async {
    final models = await dataSource.getOfflinePosts();
    return models.map((model) => model.toPost()).toList();
  }

  @override
  Future<void> removePostOffline(int postId) async {
    await dataSource.removePostOffline(postId);
  }

  @override
  Future<void> savePostOffline(Post post) async {
    final model = OfflinePostModel.fromPost(post);
    await dataSource.savePostOffline(model);
  }
} 