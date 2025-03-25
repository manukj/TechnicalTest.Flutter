import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:hive/hive.dart';

part 'offline_post_model.g.dart';

@HiveType(typeId: 0)
class OfflinePostModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final int userId;

  @HiveField(4)
  final DateTime savedAt;

  OfflinePostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.savedAt,
  });

  factory OfflinePostModel.fromPost(Post post) {
    return OfflinePostModel(
      id: post.id,
      title: post.title,
      body: post.body,
      userId: post.userId,
      savedAt: DateTime.now(),
    );
  }

  Post toPost() {
    return Post(
      id: id,
      title: title,
      body: body,
      userId: userId,
    );
  }
} 