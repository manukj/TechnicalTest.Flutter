import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/get_offline_posts.dart';
import 'package:injectable/injectable.dart';

part 'offline_posts_event.dart';

@injectable
class OfflinePostsBloc extends Bloc<OfflinePostsEvent, BaseState<List<Post>>> {
  final GetOfflinePosts getOfflinePosts;

  OfflinePostsBloc({required this.getOfflinePosts}) : super(const LoadingState()) {
    on<FetchOfflinePostsEvent>(_onFetchOfflinePosts);
  }

  Future<void> _onFetchOfflinePosts(
    FetchOfflinePostsEvent event,
    Emitter<BaseState<List<Post>>> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      final posts = await getOfflinePosts();
      emit(ContentState(posts));
    } catch (e) {
      emit(ErrorState(NetworkFailure(message: e.toString())));
    }
  }
} 