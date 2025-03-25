import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OfflinePostsRepositoryImpl implements OfflinePostsRepository {
  static const String boxName = 'offline_posts';
  final Box<OfflinePostModel> box;

  OfflinePostsRepositoryImpl(@Named(boxName) this.box);

  @override
  Future<List<Post>> getOfflinePosts() async {
    return box.values.map((model) => model.toPost()).toList();
  }

  @override
  Future<void> removePostOffline(int postId) async {
    await box.delete(postId);
  }

  @override
  Future<void> savePostOffline(Post post) async {
    final model = OfflinePostModel.fromPost(post);
    await box.put(post.id, model);
  }
} 