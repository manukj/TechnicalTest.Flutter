import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<Either<Failure, List<PostModel>>> getPosts();

  Future<Either<Failure, PostModel>> getPostById(int id);

  Future<Either<Failure, List<CommentModel>>> getCommentsByPostId(int postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  final String baseUrl;
  final Duration timeout;

  PostRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
    this.timeout = const Duration(seconds: 10),
  });

  Future<Either<Failure, T>> _performRequest<T>({
    required Uri uri,
    required T Function(dynamic json) parser,
    String? errorContext,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'Please check your internet connection and try again.',
      ));
    }

    try {
      final response = await client.get(uri).timeout(timeout);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return Right(parser(data));
      } else {
        return Left(APIFailure(
          message: 'Failed to load $errorContext',
          statusCode: response.statusCode,
        ));
      }
    } on SocketException {
      return Left(NetworkFailure(
        message: 'Network connection issue. Please check your internet and try again.',
      ));
    } on FormatException catch (e) {
      return Left(APIFailure(
        message: 'Invalid response format: ${e.message}',
      ));
    } on TimeoutException {
      return Left(NetworkFailure(
        message: 'Request timed out. Please try again later.',
      ));
    } catch (e) {
      return Left(APIFailure(
        message: 'An unexpected error occurred: ${e.toString().split('\n').first}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPosts() async {
    return _performRequest<List<PostModel>>(
      uri: Uri.parse('$baseUrl/posts'),
      parser: (data) => (data as List)
          .map((item) => PostModel.fromJson(item))
          .toList(),
      errorContext: 'posts',
    );
  }

  @override
  Future<Either<Failure, PostModel>> getPostById(int id) async {
    return _performRequest<PostModel>(
      uri: Uri.parse('$baseUrl/posts/$id'),
      parser: (data) => PostModel.fromJson(data),
      errorContext: 'post with id $id',
    );
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getCommentsByPostId(int postId) async {
    return _performRequest<List<CommentModel>>(
      uri: Uri.parse('$baseUrl/posts/$postId/comments'),
      parser: (data) => (data as List)
          .map((item) => CommentModel.fromJson(item))
          .toList(),
      errorContext: 'comments for post with id $postId',
    );
  }
} 