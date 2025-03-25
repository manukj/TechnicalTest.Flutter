import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/usecases/usecase.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

class PostParams extends Equatable {
  final int id;

  const PostParams({required this.id});

  @override
  List<Object?> get props => [id];
}

@injectable
class GetPostById implements UseCase<Post, PostParams> {
  final PostRepository repository;

  GetPostById(this.repository);

  @override
  Future<Either<Failure, Post>> call(PostParams params) async {
    return await repository.getPostById(params.id);
  }
} 