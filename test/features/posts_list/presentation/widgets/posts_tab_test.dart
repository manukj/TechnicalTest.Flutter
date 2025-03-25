import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/posts_tab.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsBloc extends MockBloc<PostsEvent, BaseState<List<Post>>>
    implements PostsBloc {}

class MockOfflinePostsBloc
    extends MockBloc<OfflinePostsEvent, BaseState<List<Post>>>
    implements OfflinePostsBloc {}

void main() {
  late MockPostsBloc mockPostsBloc;
  late MockOfflinePostsBloc mockOfflinePostsBloc;

  setUp(() {
    mockPostsBloc = MockPostsBloc();
    mockOfflinePostsBloc = MockOfflinePostsBloc();
  });

  testWidgets('PostsTab shows loading state', (WidgetTester tester) async {
    when(() => mockPostsBloc.state).thenReturn(const LoadingState());
    when(() => mockOfflinePostsBloc.state).thenReturn(const LoadingState());

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PostsBloc>.value(value: mockPostsBloc),
            BlocProvider<OfflinePostsBloc>.value(value: mockOfflinePostsBloc),
          ],
          child: const PostsTab(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('PostsTab shows content when posts are loaded',
      (WidgetTester tester) async {
    final testPosts = [
      const Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Test Body 1'),
      const Post(id: 2, userId: 2, title: 'Test Post 2', body: 'Test Body 2'),
    ];

    when(() => mockPostsBloc.state).thenReturn(ContentState(testPosts));
    when(() => mockOfflinePostsBloc.state).thenReturn(const ContentState([]));

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PostsBloc>.value(value: mockPostsBloc),
            BlocProvider<OfflinePostsBloc>.value(value: mockOfflinePostsBloc),
          ],
          child: const PostsTab(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Test Post 1'), findsOneWidget);
    expect(find.text('Test Post 2'), findsOneWidget);
  });

  testWidgets('PostsTab shows empty state when no posts',
      (WidgetTester tester) async {
    when(() => mockPostsBloc.state).thenReturn(const ContentState(<Post>[]));
    when(() => mockOfflinePostsBloc.state)
        .thenReturn(const ContentState(<Post>[]));

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PostsBloc>.value(value: mockPostsBloc),
            BlocProvider<OfflinePostsBloc>.value(value: mockOfflinePostsBloc),
          ],
          child: const PostsTab(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.text('No posts available'), findsOneWidget);
  });

  testWidgets('PostsTab shows error state', (WidgetTester tester) async {
    when(() => mockPostsBloc.state)
        .thenReturn(ErrorState(NetworkFailure(message: 'Test error')));
    when(() => mockOfflinePostsBloc.state)
        .thenReturn(const ContentState(<Post>[]));

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PostsBloc>.value(value: mockPostsBloc),
            BlocProvider<OfflinePostsBloc>.value(value: mockOfflinePostsBloc),
          ],
          child: const PostsTab(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.textContaining('Error:'), findsOneWidget);
  });
}
