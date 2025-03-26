import 'package:bloc/bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/features/comments/usecases/get_comments_by_post_id.dart';
import 'package:flutter_tech_task/features/comments/usecases/remove_comments.dart';
import 'package:flutter_tech_task/features/comments/usecases/save_comments.dart';
import 'package:injectable/injectable.dart';

part 'comments_event.dart';

@injectable
class CommentsBloc extends Bloc<CommentsEvent, BaseState<List<Comment>>> {
  final GetCommentsByPostId getCommentsByPostId;
  final SaveComments saveComments;
  final RemoveComments removeComments;

  CommentsBloc({
    required this.getCommentsByPostId,
    required this.saveComments,
    required this.removeComments,
  }) : super(const LoadingState()) {
    on<FetchCommentsByPostId>(_onFetchCommentsByPostId);
    on<SaveCommentsEvent>(_onSaveComments);
    on<RemoveCommentsEvent>(_onRemoveComments);
  }

  Future<void> _onFetchCommentsByPostId(
    FetchCommentsByPostId event,
    Emitter<BaseState<List<Comment>>> emit,
  ) async {
    emit(const LoadingState());
    
    final result = await getCommentsByPostId(CommentParams(postId: event.postId));
    
    result.fold(
      (failure) => emit(ErrorState(failure)),
      (data) => emit(ContentState(data.$1, isFromCache: data.$2)),
    );
  }

  Future<void> _onSaveComments(
    SaveCommentsEvent event,
    Emitter<BaseState<List<Comment>>> emit,
  ) async {
    final currentState = state;
    if (currentState is ContentState<List<Comment>>) {
      final result = await saveComments(SaveCommentsParams(
        postId: event.postId,
        comments: event.comments,
      ));
      
      result.fold(
        (failure) => emit(ErrorState(failure)),
        (_) => emit(ContentState(event.comments, isFromCache: true)),
      );
    }
  }

  Future<void> _onRemoveComments(
    RemoveCommentsEvent event,
    Emitter<BaseState<List<Comment>>> emit,
  ) async {
    final currentState = state;
    if (currentState is ContentState<List<Comment>>) {
      final result = await removeComments(RemoveCommentsParams(postId: event.postId));
      
      result.fold(
        (failure) => emit(ErrorState(failure)),
        (_) => add(FetchCommentsByPostId(event.postId)),
      );
    }
  }
} 