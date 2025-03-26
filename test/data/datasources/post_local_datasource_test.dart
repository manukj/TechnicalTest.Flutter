import 'package:flutter_tech_task/data/datasources/post_local_datasource.dart';
import 'package:flutter_tech_task/data/models/offline_post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for Box
@GenerateMocks([Box])
import 'post_local_datasource_test.mocks.dart';

void main() {
  late PostLocalDataSourceImpl dataSource;
  late MockBox<OfflinePostModel> mockBox;

  setUp(() {
    mockBox = MockBox<OfflinePostModel>();
    dataSource = PostLocalDataSourceImpl(mockBox);
  });

  final tDateTime = DateTime.now();
  final tOfflinePostModel = OfflinePostModel(
    id: 1,
    title: 'Test Post',
    body: 'Test Body',
    userId: 1,
    savedAt: tDateTime,
  );

  group('PostLocalDataSourceImpl', () {
    test('should save post model to Hive box', () async {
      await dataSource.savePostOffline(tOfflinePostModel);

      verify(mockBox.put(tOfflinePostModel.id, tOfflinePostModel)).called(1);
      verifyNoMoreInteractions(mockBox);
    });

    test('should remove post from Hive box', () async {
      await dataSource.removePostOffline(tOfflinePostModel.id);

      verify(mockBox.delete(tOfflinePostModel.id)).called(1);
      verifyNoMoreInteractions(mockBox);
    });

    test('should get all posts from Hive box', () async {
      final tOfflinePostModels = [
        tOfflinePostModel,
        OfflinePostModel(
          id: 2,
          title: 'Test Post 2',
          body: 'Test Body 2',
          userId: 2,
          savedAt: tDateTime,
        ),
      ];
      when(mockBox.values).thenReturn(tOfflinePostModels);

      final result = await dataSource.getOfflinePosts();

      expect(result, tOfflinePostModels);
      verify(mockBox.values).called(1);
      verifyNoMoreInteractions(mockBox);
    });

    test('should return empty list when no posts in Hive box', () async {
      when(mockBox.values).thenReturn([]);

      final result = await dataSource.getOfflinePosts();

      expect(result, isEmpty);
      verify(mockBox.values).called(1);
      verifyNoMoreInteractions(mockBox);
    });
  });
} 