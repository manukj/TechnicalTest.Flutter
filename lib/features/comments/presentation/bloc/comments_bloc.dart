import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/features/comments/usecases/get_comments_by_post_id.dart';
import 'package:injectable/injectable.dart';

part 'comments_event.dart';

@injectable
class CommentsBloc extends Bloc<CommentsEvent, BaseState<List<Comment>>> {
  final GetCommentsByPostId getCommentsByPostId;

  CommentsBloc({
    required this.getCommentsByPostId,
  }) : super(const LoadingState()) {
    on<FetchCommentsByPostIdEvent>(_onFetchCommentsByPostId);
  }

  Future<void> _onFetchCommentsByPostId(
    FetchCommentsByPostIdEvent event,
    Emitter<BaseState<List<Comment>>> emit,
  ) async {
    emit(const LoadingState());
    
    final result = await getCommentsByPostId(CommentParams(postId: event.postId));
    
    result.fold(
      (failure) => emit(ErrorState(failure)),
      (comments) => emit(ContentState(comments)),
    );
  }
} 