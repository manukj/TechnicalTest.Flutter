import 'package:flutter_tech_task/data/datasources/comment_local_datasource.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for Box
@GenerateMocks([Box])
import 'comment_local_datasource_test.mocks.dart';

void main() {
  late CommentLocalDataSourceImpl dataSource;
  late MockBox<CommentModel> mockBox;

  setUp(() {
    mockBox = MockBox<CommentModel>();
    dataSource = CommentLocalDataSourceImpl(mockBox);
  });

  final tCommentModel1 = CommentModel(
    id: 1,
    postId: 10,
    name: 'Test Name 1',
    email: 'test1@example.com',
    body: 'Test Comment 1',
  );

  final tCommentModel2 = CommentModel(
    id: 2,
    postId: 10,
    name: 'Test Name 2',
    email: 'test2@example.com',
    body: 'Test Comment 2',
  );

  final tCommentModel3 = CommentModel(
    id: 3,
    postId: 20,
    name: 'Test Name 3',
    email: 'test3@example.com',
    body: 'Test Comment 3',
  );

  group('getComments', () {
    test('should return list of comments for a post ID when available', () async {
      // Arrange
      final testComments = [tCommentModel1, tCommentModel2, tCommentModel3];
      when(mockBox.values).thenReturn(testComments);
      
      // Act
      final result = await dataSource.getComments(10);
      
      // Assert
      expect(result, [tCommentModel1, tCommentModel2]);
      verify(mockBox.values).called(1);
    });

    test('should return empty list when no comments for post ID', () async {
      // Arrange
      final testComments = [tCommentModel3]; // Only has postId 20
      when(mockBox.values).thenReturn(testComments);
      
      // Act
      final result = await dataSource.getComments(10);
      
      // Assert
      expect(result, isEmpty);
      verify(mockBox.values).called(1);
    });
  });

  group('saveComments', () {
    test('should save comments for a post ID after removing existing ones', () async {
      // Arrange
      final existingComments = [tCommentModel1, tCommentModel3];
      when(mockBox.values).thenReturn(existingComments);
      
      final newComments = [tCommentModel2];
      
      // Act
      await dataSource.saveComments(10, newComments);
      
      // Assert
      // Verify it gets existing comments to find IDs to delete
      verify(mockBox.values).called(1);
      
      // Verify it deletes the existing comment for this post ID
      verify(mockBox.delete(tCommentModel1.id)).called(1);
      
      // Verify it doesn't delete comments from other posts
      verifyNever(mockBox.delete(tCommentModel3.id));
      
      // Verify it saves new comments
      verify(mockBox.putAll({tCommentModel2.id: tCommentModel2})).called(1);
    });
  });

  group('removeComments', () {
    test('should remove all comments for a specific post ID', () async {
      // Arrange
      final testComments = [tCommentModel1, tCommentModel2, tCommentModel3];
      when(mockBox.values).thenReturn(testComments);
      
      // Act
      await dataSource.removeComments(10);
      
      // Assert
      verify(mockBox.values).called(1);
      verify(mockBox.delete(tCommentModel1.id)).called(1);
      verify(mockBox.delete(tCommentModel2.id)).called(1);
      verifyNever(mockBox.delete(tCommentModel3.id));
    });

    test('should not delete any comments if none match post ID', () async {
      // Arrange
      final testComments = [tCommentModel3]; // Only has postId 20
      when(mockBox.values).thenReturn(testComments);
      
      // Act
      await dataSource.removeComments(10);
      
      // Assert
      verify(mockBox.values).called(1);
      verifyNever(mockBox.delete(any));
    });
  });
} 