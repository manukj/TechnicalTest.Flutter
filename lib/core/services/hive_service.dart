import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OfflinePostModelAdapter());
  }

  @factoryMethod
  @Named('offline_posts')
  Future<Box<OfflinePostModel>> openOfflinePostsBox() async {
    return await Hive.openBox<OfflinePostModel>('offline_posts');
  }
} 