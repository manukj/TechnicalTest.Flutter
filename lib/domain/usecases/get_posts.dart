import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';
import 'usecase.dart';

class GetPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await repository.getPosts();
  }
} 