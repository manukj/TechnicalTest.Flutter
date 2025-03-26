part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchCommentsByPostIdEvent extends CommentsEvent {
  final int postId;

  const FetchCommentsByPostIdEvent({required this.postId});

  @override
  List<Object> get props => [postId];
} 