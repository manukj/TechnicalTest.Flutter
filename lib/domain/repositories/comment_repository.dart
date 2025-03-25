import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> getCommentsByPostId(int postId);
} 