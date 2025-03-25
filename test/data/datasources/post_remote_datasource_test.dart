import 'dart:convert';

import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/core/network/network_info.dart';
import 'package:flutter_tech_task/data/datasources/post_remote_datasource.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client, NetworkInfo])
void main() {
  late PostRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockHttpClient = MockClient();
    mockNetworkInfo = MockNetworkInfo();
    dataSource = PostRemoteDataSourceImpl(
      client: mockHttpClient,
      networkInfo: mockNetworkInfo,
      timeout: const Duration(milliseconds: 100), // Shorter timeout for tests
    );
  });

  const testUrl = 'https://jsonplaceholder.typicode.com';

  group('getPosts', () {
    final testPostsJson = [
      {
        'id': 1,
        'title': 'Test Title 1',
        'body': 'Test Body 1',
        'userId': 1,
      },
      {
        'id': 2,
        'title': 'Test Title 2',
        'body': 'Test Body 2',
        'userId': 1,
      },
    ];

    const testPosts = [
      PostModel(id: 1, title: 'Test Title 1', body: 'Test Body 1', userId: 1),
      PostModel(id: 2, title: 'Test Title 2', body: 'Test Body 2', userId: 1),
    ];

    test('should perform a GET request on a URL with posts endpoint', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts')))
          .thenAnswer((_) async => http.Response(json.encode(testPostsJson), 200));

      // act
      await dataSource.getPosts();

      // assert
      verify(mockHttpClient.get(Uri.parse('$testUrl/posts')));
    });

    test('should return Right with a list of Posts when the response code is 200', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts')))
          .thenAnswer((_) async => http.Response(json.encode(testPostsJson), 200));

      // act
      final result = await dataSource.getPosts();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (posts) => expect(posts, equals(testPosts)),
      );
    });

    test('should return Left with APIFailure when the response code is not 200', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final result = await dataSource.getPosts();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<APIFailure>());
          expect((failure as APIFailure).message, 'Failed to load posts');
          expect(failure.statusCode, 404);
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with NetworkFailure when no internet connection', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await dataSource.getPosts();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, 'Please check your internet connection and try again.');
        },
        (_) => fail('Expected Left but got Right'),
      );
      verifyNever(mockHttpClient.get(any));
    });

    test('should return Left with APIFailure when an exception occurs', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts')))
          .thenThrow(Exception('Test exception'));

      // act
      final result = await dataSource.getPosts();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<APIFailure>());
          expect((failure as APIFailure).message, contains('Test exception'));
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with NetworkFailure when timeout occurs', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts')))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        return http.Response(json.encode(testPostsJson), 200);
      });

      // act
      final result = await dataSource.getPosts();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, contains('Request timed out'));
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getPostById', () {
    const testId = 1;
    final testPostJson = {
      'id': testId,
      'title': 'Test Title',
      'body': 'Test Body',
      'userId': 1,
    };

    const testPost = PostModel(
      id: testId,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
    );

    test('should perform a GET request on a URL with post/:id endpoint', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts/$testId')))
          .thenAnswer((_) async => http.Response(json.encode(testPostJson), 200));

      // act
      await dataSource.getPostById(testId);

      // assert
      verify(mockHttpClient.get(Uri.parse('$testUrl/posts/$testId')));
    });

    test('should return Right with a Post when the response code is 200', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts/$testId')))
          .thenAnswer((_) async => http.Response(json.encode(testPostJson), 200));

      // act
      final result = await dataSource.getPostById(testId);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (post) => expect(post, equals(testPost)),
      );
    });

    test('should return Left with APIFailure when the response code is not 200', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts/$testId')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final result = await dataSource.getPostById(testId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<APIFailure>());
          expect((failure as APIFailure).message, 'Failed to load post with id $testId');
          expect(failure.statusCode, 404);
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getCommentsByPostId', () {
    const testPostId = 1;
    final testCommentsJson = [
      {
        'id': 1,
        'postId': testPostId,
        'name': 'Test Name 1',
        'email': 'test1@example.com',
        'body': 'Test Comment Body 1',
      },
      {
        'id': 2,
        'postId': testPostId,
        'name': 'Test Name 2',
        'email': 'test2@example.com',
        'body': 'Test Comment Body 2',
      },
    ];

    const testComments = [
      CommentModel(
        id: 1,
        postId: testPostId,
        name: 'Test Name 1',
        email: 'test1@example.com',
        body: 'Test Comment Body 1',
      ),
      CommentModel(
        id: 2,
        postId: testPostId,
        name: 'Test Name 2',
        email: 'test2@example.com',
        body: 'Test Comment Body 2',
      ),
    ];

    test('should perform a GET request on a URL with posts/:id/comments endpoint', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts/$testPostId/comments')))
          .thenAnswer((_) async => http.Response(json.encode(testCommentsJson), 200));

      // act
      await dataSource.getCommentsByPostId(testPostId);

      // assert
      verify(mockHttpClient.get(Uri.parse('$testUrl/posts/$testPostId/comments')));
    });

    test('should return Right with a list of Comments when the response code is 200', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts/$testPostId/comments')))
          .thenAnswer((_) async => http.Response(json.encode(testCommentsJson), 200));

      // act
      final result = await dataSource.getCommentsByPostId(testPostId);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (comments) => expect(comments, equals(testComments)),
      );
    });

    test('should return Left with APIFailure when the response code is not 200', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(Uri.parse('$testUrl/posts/$testPostId/comments')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final result = await dataSource.getCommentsByPostId(testPostId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<APIFailure>());
          expect((failure as APIFailure).message, 'Failed to load comments for post with id $testPostId');
          expect(failure.statusCode, 404);
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
} 