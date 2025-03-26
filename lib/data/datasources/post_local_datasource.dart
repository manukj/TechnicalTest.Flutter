import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class PostLocalDataSource {
  Future<List<OfflinePostModel>> getOfflinePosts();
  Future<void> removePostOffline(int postId);
  Future<void> savePostOffline(OfflinePostModel postModel);
}

@Injectable()
class PostLocalDataSourceImpl implements PostLocalDataSource {
  static const String boxName = 'offline_posts';
  final Box<OfflinePostModel> box;

  PostLocalDataSourceImpl(@Named(boxName) this.box);

  @override
  Future<List<OfflinePostModel>> getOfflinePosts() async {
    return Future.value(box.values.toList());
  }

  @override
  Future<void> removePostOffline(int postId) async {
    await box.delete(postId);
  }

  @override
  Future<void> savePostOffline(OfflinePostModel postModel) async {
    await box.put(postModel.id, postModel);
  }
} 