import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';
import 'usecase.dart';

class GetPostById implements UseCase<Post, Params> {
  final PostRepository repository;

  GetPostById(this.repository);

  @override
  Future<Either<Failure, Post>> call(Params params) async {
    return await repository.getPostById(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
} 