import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/error/failures.dart';

sealed class BaseState<T> extends Equatable {
  const BaseState();
  
  @override
  List<Object?> get props => [];
}

class LoadingState<T> extends BaseState<T> {
  const LoadingState();
}

class ContentState<T> extends BaseState<T> {
  final T data;
  
  const ContentState(this.data);
  
  @override
  List<Object?> get props => [data];
}

class ErrorState<T> extends BaseState<T> {
  final Failure failure;
  
  const ErrorState(this.failure);
  
  @override
  List<Object?> get props => [failure];
} 