import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tCommentModel = CommentModel(
    id: 1,
    postId: 1,
    name: 'Test name',
    email: 'test@example.com',
    body: 'Test body',
  );

  test('should be a subclass of Comment entity', () {
    // assert
    expect(tCommentModel, isA<Comment>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'postId': 1,
        'name': 'Test name',
        'email': 'test@example.com',
        'body': 'Test body',
      };
      final result = CommentModel.fromJson(jsonMap);
      expect(result, tCommentModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // act
      final result = tCommentModel.toJson();
      // assert
      final expectedMap = {
        'id': 1,
        'postId': 1,
        'name': 'Test name',
        'email': 'test@example.com',
        'body': 'Test body',
      };
      expect(result, expectedMap);
    });
  });
} 