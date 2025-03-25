import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/data/datasources/post_remote_datasource.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/repositories/post_repository_impl.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_repository_impl_test.mocks.dart';

@GenerateMocks([PostRemoteDataSource])
void main() {
  late PostRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    repository = PostRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getPosts', () {
    const tPostModels = [
      PostModel(id: 1, title: 'Test Title 1', body: 'Test Body 1', userId: 1),
      PostModel(id: 2, title: 'Test Title 2', body: 'Test Body 2', userId: 1),
    ];

    const List<Post> tPosts = tPostModels;

    test(
      'should return List<Post> when the remote data source call is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPosts())
            .thenAnswer((_) async => Right(tPostModels));

        // act
        final result = await repository.getPosts();

        // assert
        verify(mockRemoteDataSource.getPosts());
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (posts) => expect(posts, equals(tPosts)),
        );
      },
    );

    test(
      'should return APIFailure when the remote data source call is unsuccessful',
      () async {
        // arrange
        final apiFailure = APIFailure(message: 'Error message', statusCode: 404);
        when(mockRemoteDataSource.getPosts())
            .thenAnswer((_) async => Left(apiFailure));

        // act
        final result = await repository.getPosts();

        // assert
        verify(mockRemoteDataSource.getPosts());
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<APIFailure>());
            expect((failure as APIFailure).message, equals('Error message'));
            expect(failure.statusCode, equals(404));
          },
          (posts) => fail('Expected Left but got Right'),
        );
      },
    );
  });

  group('getPostById', () {
    const tId = 1;
    const tPostModel = PostModel(
      id: tId,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
    );
    const Post tPost = tPostModel;

    test(
      'should return Post when the remote data source call is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPostById(tId))
            .thenAnswer((_) async => Right(tPostModel));

        // act
        final result = await repository.getPostById(tId);

        // assert
        verify(mockRemoteDataSource.getPostById(tId));
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (post) => expect(post, equals(tPost)),
        );
      },
    );

    test(
      'should return APIFailure when the remote data source call is unsuccessful',
      () async {
        // arrange
        final apiFailure = APIFailure(message: 'Error message', statusCode: 404);
        when(mockRemoteDataSource.getPostById(tId))
            .thenAnswer((_) async => Left(apiFailure));

        // act
        final result = await repository.getPostById(tId);

        // assert
        verify(mockRemoteDataSource.getPostById(tId));
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<APIFailure>());
            expect((failure as APIFailure).message, equals('Error message'));
            expect(failure.statusCode, equals(404));
          },
          (post) => fail('Expected Left but got Right'),
        );
      },
    );
  });

  group('getCommentsByPostId', () {
    const tPostId = 1;
    const tCommentModels = [
      CommentModel(
        id: 1,
        postId: tPostId,
        name: 'Test Name 1',
        email: 'test1@example.com',
        body: 'Test Comment Body 1',
      ),
      CommentModel(
        id: 2,
        postId: tPostId,
        name: 'Test Name 2',
        email: 'test2@example.com',
        body: 'Test Comment Body 2',
      ),
    ];
    const List<Comment> tComments = tCommentModels;

    test(
      'should return List<Comment> when the remote data source call is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getCommentsByPostId(tPostId))
            .thenAnswer((_) async => Right(tCommentModels));

        // act
        final result = await repository.getCommentsByPostId(tPostId);

        // assert
        verify(mockRemoteDataSource.getCommentsByPostId(tPostId));
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (comments) => expect(comments, equals(tComments)),
        );
      },
    );

    test(
      'should return APIFailure when the remote data source call is unsuccessful',
      () async {
        // arrange
        final apiFailure = APIFailure(message: 'Error message', statusCode: 404);
        when(mockRemoteDataSource.getCommentsByPostId(tPostId))
            .thenAnswer((_) async => Left(apiFailure));

        // act
        final result = await repository.getCommentsByPostId(tPostId);

        // assert
        verify(mockRemoteDataSource.getCommentsByPostId(tPostId));
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<APIFailure>());
            expect((failure as APIFailure).message, equals('Error message'));
            expect(failure.statusCode, equals(404));
          },
          (comments) => fail('Expected Left but got Right'),
        );
      },
    );
  });
} 