import 'package:dartz/dartz.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/data/datasources/comment_local_datasource.dart';
import 'package:flutter_tech_task/data/datasources/post_remote_datasource.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/data/repositories/comment_repository_impl.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for dependencies
@GenerateMocks([PostRemoteDataSource, CommentLocalDataSource])
import 'comment_repository_impl_test.mocks.dart';

void main() {
  late CommentRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockCommentLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockLocalDataSource = MockCommentLocalDataSource();
    repository = CommentRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tPostId = 10;

  const tCommentModel1 = CommentModel(
    id: 1,
    postId: tPostId,
    name: 'Test Name 1',
    email: 'test1@example.com',
    body: 'Test Comment 1',
  );

  const tCommentModel2 = CommentModel(
    id: 2,
    postId: tPostId,
    name: 'Test Name 2',
    email: 'test2@example.com',
    body: 'Test Comment 2',
  );

  final tCommentList = [tCommentModel1, tCommentModel2];

  group('getCommentsByPostId', () {
    test('should return local comments when available', () async {
      when(mockLocalDataSource.getComments(tPostId))
          .thenAnswer((_) async => tCommentList);

      final result = await repository.getCommentsByPostId(tPostId);

      expect(result, Right<Failure, List<Comment>>(tCommentList));
      verify(mockLocalDataSource.getComments(tPostId)).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should get remote comments when local comments are empty', () async {
      when(mockLocalDataSource.getComments(tPostId))
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getCommentsByPostId(tPostId))
          .thenAnswer((_) async => Right(tCommentList));

      final result = await repository.getCommentsByPostId(tPostId);

      expect(result, Right<Failure, List<Comment>>(tCommentList));
      verify(mockLocalDataSource.getComments(tPostId)).called(1);
      verify(mockRemoteDataSource.getCommentsByPostId(tPostId)).called(1);
      verify(mockLocalDataSource.saveComments(tPostId, tCommentList)).called(1);
    });

    test('should return failure from remote data source when local is empty',
        () async {
      final tFailure = NetworkFailure(message: 'Network error');

      when(mockLocalDataSource.getComments(tPostId))
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getCommentsByPostId(tPostId))
          .thenAnswer((_) async => Left(tFailure));

      final result = await repository.getCommentsByPostId(tPostId);

      expect(result, Left<Failure, List<Comment>>(tFailure));
      verify(mockLocalDataSource.getComments(tPostId)).called(1);
      verify(mockRemoteDataSource.getCommentsByPostId(tPostId)).called(1);
      verifyNever(mockLocalDataSource.saveComments(any, any));
    });

    test('should return failure when an exception occurs', () async {
      // Arrange
      when(mockLocalDataSource.getComments(tPostId))
          .thenThrow(Exception('Test error'));

      final result = await repository.getCommentsByPostId(tPostId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('saveComments', () {
    test('should save comments to local data source', () async {
      when(mockLocalDataSource.saveComments(tPostId, tCommentList))
          .thenAnswer((_) async => {});

      final result = await repository.saveComments(tPostId, tCommentList);

      expect(result, const Right<Failure, void>(null));
      verify(mockLocalDataSource.saveComments(tPostId, tCommentList)).called(1);
    });

    test('should return failure when save throws an exception', () async {
      when(mockLocalDataSource.saveComments(tPostId, tCommentList))
          .thenThrow(Exception('Test error'));

      final result = await repository.saveComments(tPostId, tCommentList);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('removeComments', () {
    test('should remove comments from local data source', () async {
      when(mockLocalDataSource.removeComments(tPostId))
          .thenAnswer((_) async => {});

      final result = await repository.removeComments(tPostId);

      expect(result, const Right<Failure, void>(null));
      verify(mockLocalDataSource.removeComments(tPostId)).called(1);
    });

    test('should return failure when remove throws an exception', () async {
      when(mockLocalDataSource.removeComments(tPostId))
          .thenThrow(Exception('Test error'));

      final result = await repository.removeComments(tPostId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}
