import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    return remoteDataSource.getPosts();
  }

  @override
  Future<Either<Failure, Post>> getPostById(int id) async {
    return remoteDataSource.getPostById(id);
  }

  @override
  Future<Either<Failure, List<Comment>>> getCommentsByPostId(int postId) async {
    return remoteDataSource.getCommentsByPostId(postId);
  }
} 