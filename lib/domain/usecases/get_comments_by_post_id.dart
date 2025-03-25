import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/comment.dart';
import '../repositories/post_repository.dart';
import 'usecase.dart';

class GetCommentsByPostId implements UseCase<List<Comment>, PostIdParam> {
  final PostRepository repository;

  GetCommentsByPostId(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(PostIdParam params) async {
    return await repository.getCommentsByPostId(params.postId);
  }
}

class PostIdParam extends Equatable {
  final int postId;

  const PostIdParam({required this.postId});

  @override
  List<Object> get props => [postId];
} 