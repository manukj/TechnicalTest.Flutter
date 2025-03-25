import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/comment.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, Post>> getPostById(int id);
  Future<Either<Failure, List<Comment>>> getCommentsByPostId(int postId);
} 