import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/usecases/get_posts.dart';
import 'package:injectable/injectable.dart';

part 'posts_event.dart';

@injectable
class PostsBloc extends Bloc<PostsEvent, BaseState<List<Post>>> {
  final GetPosts getPosts;

  PostsBloc({required this.getPosts}) : super(const LoadingState()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<BaseState<List<Post>>> emit,
  ) async {
    emit(const LoadingState());
    
    final result = await getPosts(NoParams());
    
    result.fold(
      (failure) => emit(ErrorState(failure)),
      (posts) => emit(ContentState(posts)),
    );
  }
} 