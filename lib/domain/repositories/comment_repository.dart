import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, (List<Comment>, bool)>> getCommentsByPostId(int postId);
  Future<Either<Failure, void>> saveComments(int postId, List<Comment> comments);
  Future<Either<Failure, void>> removeComments(int postId);
} 