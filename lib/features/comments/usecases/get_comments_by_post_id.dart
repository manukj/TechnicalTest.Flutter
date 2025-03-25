import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/domain/repositories/comment_repository.dart';
import 'package:injectable/injectable.dart';

class CommentParams extends Equatable {
  final int postId;

  const CommentParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}

@injectable
class GetCommentsByPostId implements UseCase<List<Comment>, CommentParams> {
  final CommentRepository repository;

  GetCommentsByPostId(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(CommentParams params) async {
    return await repository.getCommentsByPostId(params.postId);
  }
} 