part of 'offline_posts_bloc.dart';

sealed class OfflinePostsEvent extends Equatable {
  const OfflinePostsEvent();

  @override
  List<Object> get props => [];
}

class FetchOfflinePostsEvent extends OfflinePostsEvent {
  const FetchOfflinePostsEvent();
} 