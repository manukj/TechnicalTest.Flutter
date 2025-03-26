import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class CommentLocalDataSource {
  Future<List<CommentModel>> getComments(int postId);
  Future<void> saveComments(int postId, List<CommentModel> comments);
  Future<void> removeComments(int postId);
}

@Injectable()
class CommentLocalDataSourceImpl implements CommentLocalDataSource {
  static const String boxName = 'offline_comments';
  final Box<CommentModel> box;

  CommentLocalDataSourceImpl(@Named(boxName) this.box);

  @override
  Future<List<CommentModel>> getComments(int postId) async {
    final comments =
        box.values.where((comment) => comment.postId == postId).toList();
    return Future.value(comments);
  }

  @override
  Future<void> saveComments(int postId, List<CommentModel> comments) async {
    await removeComments(postId);
    
    await box.putAll({
      for (var comment in comments) comment.id: comment
    });
  }

  @override
  Future<void> removeComments(int postId) async {
    final commentIds = box.values
        .where((comment) => comment.postId == postId)
        .map((comment) => comment.id)
        .toList();
    
    for (var id in commentIds) {
      await box.delete(id);
    }
  }
}
