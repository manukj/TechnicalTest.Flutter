import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tPostModel = PostModel(
    id: 1,
    title: 'Test title',
    body: 'Test body',
    userId: 1,
  );

  test('should be a subclass of Post entity', () {
    expect(tPostModel, isA<Post>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'title': 'Test title',
        'body': 'Test body',
        'userId': 1,
      };
      final result = PostModel.fromJson(jsonMap);
      expect(result, tPostModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tPostModel.toJson();
      final expectedMap = {
        'id': 1,
        'title': 'Test title',
        'body': 'Test body',
        'userId': 1,
      };
      expect(result, expectedMap);
    });
  });
} 