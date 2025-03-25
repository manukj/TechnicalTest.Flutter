import 'package:flutter_tech_task/domain/repositories/offline_posts_repository.dart';
import 'package:flutter_tech_task/features/post_detail/usecases/remove_post_offline.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([OfflinePostsRepository])
import 'remove_post_offline_test.mocks.dart';

void main() {
  late RemovePostOffline usecase;
  late MockOfflinePostsRepository mockRepository;

  setUp(() {
    mockRepository = MockOfflinePostsRepository();
    usecase = RemovePostOffline(mockRepository);
  });

  const tPostId = 1;

  test('should remove post from offline storage', () async {
    await usecase(tPostId);

    verify(mockRepository.removePostOffline(tPostId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
} 