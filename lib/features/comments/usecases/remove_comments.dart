import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/repositories/comment_repository.dart';
import 'package:injectable/injectable.dart';

class RemoveCommentsParams extends Equatable {
  final int postId;

  const RemoveCommentsParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}

@injectable
class RemoveComments implements UseCase<void, RemoveCommentsParams> {
  final CommentRepository repository;

  RemoveComments(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveCommentsParams params) async {
    return await repository.removeComments(params.postId);
  }
} 