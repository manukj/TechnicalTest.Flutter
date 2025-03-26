import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/data/datasources/comment_local_datasource.dart';
import 'package:flutter_tech_task/data/datasources/post_remote_datasource.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/domain/repositories/comment_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommentRepository)
class CommentRepositoryImpl implements CommentRepository {
  final PostRemoteDataSource remoteDataSource;
  final CommentLocalDataSource localDataSource;

  CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, (List<Comment>, bool)>> getCommentsByPostId(int postId) async {
    try {
      final localComments = await localDataSource.getComments(postId);
      
      if (localComments.isNotEmpty) {
        return Right((localComments, true));
      }
      
      final remoteResult = await remoteDataSource.getCommentsByPostId(postId);
      
      return remoteResult.fold(
        (failure) => Left(failure),
        (comments) async {
          await localDataSource.saveComments(postId, comments);
          return Right((comments, false));
        },
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to get comments: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveComments(int postId, List<Comment> comments) async {
    try {
      final commentModels = comments.map((comment) {
        if (comment is CommentModel) {
          return comment;
        }
        return CommentModel(
          id: comment.id,
          postId: comment.postId,
          name: comment.name,
          email: comment.email,
          body: comment.body,
        );
      }).toList();
      
      await localDataSource.saveComments(postId, commentModels);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to save comments: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> removeComments(int postId) async {
    try {
      await localDataSource.removeComments(postId);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to remove comments: ${e.toString()}'));
    }
  }
} 