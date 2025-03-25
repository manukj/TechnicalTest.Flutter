import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/post_list_usecase.dart';
import 'package:injectable/injectable.dart';

part 'offline_posts_event.dart';

@injectable
class OfflinePostsBloc extends Bloc<OfflinePostsEvent, BaseState<List<Post>>> {
  final PostListUseCase postListUseCase;

  OfflinePostsBloc({
    required this.postListUseCase,
  }) : super(const LoadingState()) {
    on<FetchOfflinePostsEvent>(_onFetchOfflinePosts);
    on<SavePostOfflineEvent>(_onSavePostOffline);
    on<RemovePostOfflineEvent>(_onRemovePostOffline);
  }

  Future<void> _onFetchOfflinePosts(
    FetchOfflinePostsEvent event,
    Emitter<BaseState<List<Post>>> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      final posts = await postListUseCase.getOfflinePosts();
      emit(ContentState(posts));
    } catch (e) {
      emit(ErrorState(NetworkFailure(message: e.toString())));
    }
  }

  Future<void> _onSavePostOffline(
    SavePostOfflineEvent event,
    Emitter<BaseState<List<Post>>> emit,
  ) async {
    try {
      await postListUseCase.savePostOffline(event.post);
      // Fetch the updated list after saving
      add(const FetchOfflinePostsEvent());
    } catch (e) {
      emit(ErrorState(NetworkFailure(message: e.toString())));
    }
  }

  Future<void> _onRemovePostOffline(
    RemovePostOfflineEvent event,
    Emitter<BaseState<List<Post>>> emit,
  ) async {
    try {
      await postListUseCase.removePostOffline(event.postId);
      // Fetch the updated list after removing
      add(const FetchOfflinePostsEvent());
    } catch (e) {
      emit(ErrorState(NetworkFailure(message: e.toString())));
    }
  }
} 