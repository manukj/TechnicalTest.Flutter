// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_tech_task/core/services/hive_service.dart' as _i421;
import 'package:flutter_tech_task/data/models/offline_post_model.dart' as _i516;
import 'package:flutter_tech_task/data/repositories/offline_posts_repository_impl.dart'
    as _i624;
import 'package:flutter_tech_task/domain/repositories/comment_repository.dart'
    as _i1054;
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart'
    as _i670;
import 'package:flutter_tech_task/domain/repositories/post_repository.dart'
    as _i488;
import 'package:flutter_tech_task/features/comments/usecases/get_comments_by_post_id.dart'
    as _i310;
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart'
    as _i995;
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart'
    as _i582;
import 'package:flutter_tech_task/features/posts_list/usecases/post_list_usecase.dart'
    as _i524;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i421.HiveService>(() => _i421.HiveService());
    gh.factory<_i524.PostListUseCase>(() => _i524.PostListUseCase(
          gh<_i488.PostRepository>(),
          gh<_i670.OfflinePostsRepository>(),
        ));
    gh.factory<_i624.OfflinePostsRepositoryImpl>(() =>
        _i624.OfflinePostsRepositoryImpl(gh<_i979.Box<_i516.OfflinePostModel>>(
            instanceName: 'offline_posts')));
    gh.factory<_i310.GetCommentsByPostId>(
        () => _i310.GetCommentsByPostId(gh<_i1054.CommentRepository>()));
    gh.factory<_i995.OfflinePostsBloc>(() =>
        _i995.OfflinePostsBloc(postListUseCase: gh<_i524.PostListUseCase>()));
    gh.factory<_i582.PostsBloc>(
        () => _i582.PostsBloc(postListUseCase: gh<_i524.PostListUseCase>()));
    return this;
  }
}
