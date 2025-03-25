part of 'offline_posts_bloc.dart';

sealed class OfflinePostsEvent extends Equatable {
  const OfflinePostsEvent();

  @override
  List<Object> get props => [];
}

class FetchOfflinePostsEvent extends OfflinePostsEvent {
  const FetchOfflinePostsEvent();
}

class SavePostOfflineEvent extends OfflinePostsEvent {
  final Post post;
  
  const SavePostOfflineEvent(this.post);
  
  @override
  List<Object> get props => [post];
}

class RemovePostOfflineEvent extends OfflinePostsEvent {
  final int postId;
  
  const RemovePostOfflineEvent(this.postId);
  
  @override
  List<Object> get props => [postId];
} 