part of 'comments_bloc.dart';

abstract class CommentsEvent {}

class FetchCommentsByPostId extends CommentsEvent {
  final int postId;

  FetchCommentsByPostId(this.postId);
}

class SaveCommentsEvent extends CommentsEvent {
  final int postId;
  final List<Comment> comments;

  SaveCommentsEvent(this.postId, this.comments);
}

class RemoveCommentsEvent extends CommentsEvent {
  final int postId;

  RemoveCommentsEvent(this.postId);
} 