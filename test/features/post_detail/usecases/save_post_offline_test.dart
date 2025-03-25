import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:flutter_tech_task/features/post_detail/usecases/save_post_offline.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([OfflinePostsRepository])
import 'save_post_offline_test.mocks.dart';

void main() {
  late SavePostOffline usecase;
  late MockOfflinePostsRepository mockRepository;

  setUp(() {
    mockRepository = MockOfflinePostsRepository();
    usecase = SavePostOffline(mockRepository);
  });

  const tPost = Post(
    id: 1,
    title: 'Test Post',
    body: 'Test Body',
    userId: 1,
  );

  test('should save post to offline storage', () async {
    await usecase(tPost);

    verify(mockRepository.savePostOffline(tPost)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
} 