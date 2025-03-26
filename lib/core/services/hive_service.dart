import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OfflinePostModelAdapter());
    Hive.registerAdapter(CommentModelAdapter());
  }

  @factoryMethod
  @Named('offline_posts')
  Future<Box<OfflinePostModel>> openOfflinePostsBox() async {
    return await Hive.openBox<OfflinePostModel>('offline_posts');
  }
  
  @factoryMethod
  @Named('offline_comments')
  Future<Box<CommentModel>> openOfflineCommentsBox() async {
    return await Hive.openBox<CommentModel>('offline_comments');
  }
} 