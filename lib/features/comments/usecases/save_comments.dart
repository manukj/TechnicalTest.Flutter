import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/domain/repositories/comment_repository.dart';
import 'package:injectable/injectable.dart';

class SaveCommentsParams extends Equatable {
  final int postId;
  final List<Comment> comments;

  const SaveCommentsParams({
    required this.postId,
    required this.comments,
  });

  @override
  List<Object?> get props => [postId, comments];
}

@injectable
class SaveComments implements UseCase<void, SaveCommentsParams> {
  final CommentRepository repository;

  SaveComments(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveCommentsParams params) async {
    return await repository.saveComments(params.postId, params.comments);
  }
} 