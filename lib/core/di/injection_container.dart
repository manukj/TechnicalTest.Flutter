import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tech_task/core/network/network_info.dart';
import 'package:flutter_tech_task/core/services/hive_service.dart';
import 'package:flutter_tech_task/data/datasources/post_remote_datasource.dart';
import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:flutter_tech_task/data/repositories/offline_posts_repository_impl.dart';
import 'package:flutter_tech_task/data/repositories/post_repository_impl.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/post_list_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Core and external dependencies
  await _registerExternalDependencies();

  // Features - Posts Listing
  _registerPostsDataSources();
  _registerPostsRepositories();
  _registerPostsUseCases();
  _registerPostsBlocs();
}

Future<void> _registerExternalDependencies() async {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerSingleton<HiveService>(HiveService());
  await sl<HiveService>().init();

  var offlinePostsBox = await sl<HiveService>().openOfflinePostsBox();
  sl.registerSingleton<Box<OfflinePostModel>>(offlinePostsBox,
      instanceName: 'offline_posts');
}

// Register BLoCs for posts feature
void _registerPostsBlocs() {
  sl.registerFactory(() => PostsBloc(postListUseCase: sl()));
  sl.registerFactory(() => OfflinePostsBloc(postListUseCase: sl()));
}

// Register Use Cases for posts feature
void _registerPostsUseCases() {
  sl.registerLazySingleton(() => PostListUseCase(sl(), sl()));
}

// Register Repositories for posts feature
void _registerPostsRepositories() {
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<OfflinePostsRepository>(
    () => OfflinePostsRepositoryImpl(
      sl.get<Box<OfflinePostModel>>(instanceName: 'offline_posts'),
    ),
  );
}

// Register Data Sources for posts featur
void _registerPostsDataSources() {
  // Remote data source
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      client: sl(),
      networkInfo: sl(),
    ),
  );
}
