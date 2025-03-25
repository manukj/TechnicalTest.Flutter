import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';
import 'package:flutter_tech_task/core/error/failures.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/offline_posts_tab.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflinePostsBloc extends MockBloc<OfflinePostsEvent, BaseState<List<Post>>>
    implements OfflinePostsBloc {}

void main() {
  late MockOfflinePostsBloc mockOfflinePostsBloc;

  setUp(() {
    mockOfflinePostsBloc = MockOfflinePostsBloc();
  });

  testWidgets('OfflinePostsTab shows loading state', (WidgetTester tester) async {
    
    when(() => mockOfflinePostsBloc.state).thenReturn(const LoadingState());

   
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfflinePostsBloc>.value(
          value: mockOfflinePostsBloc,
          child: const OfflinePostsTab(),
        ),
      ),
    );

    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('OfflinePostsTab shows content when posts are loaded', (WidgetTester tester) async {
    
    final testPosts = [
      const Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Test Body 1'),
      const Post(id: 2, userId: 2, title: 'Test Post 2', body: 'Test Body 2'),
    ];
    
    when(() => mockOfflinePostsBloc.state).thenReturn(ContentState(testPosts));

   
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfflinePostsBloc>.value(
          value: mockOfflinePostsBloc,
          child: const OfflinePostsTab(),
        ),
      ),
    );

    
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Test Post 1'), findsOneWidget);
    expect(find.text('Test Post 2'), findsOneWidget);
  });

  testWidgets('OfflinePostsTab shows empty state when no posts', (WidgetTester tester) async {
    
    when(() => mockOfflinePostsBloc.state).thenReturn(const ContentState(<Post>[]));

   
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfflinePostsBloc>.value(
          value: mockOfflinePostsBloc,
          child: const OfflinePostsTab(),
        ),
      ),
    );

    
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.text('No saved posts'), findsOneWidget);
  });

  testWidgets('OfflinePostsTab shows error state', (WidgetTester tester) async {
    
    when(() => mockOfflinePostsBloc.state).thenReturn(ErrorState(NetworkFailure(message: 'Test error')));

   
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfflinePostsBloc>.value(
          value: mockOfflinePostsBloc,
          child: const OfflinePostsTab(),
        ),
      ),
    );

    
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.textContaining('Error:'), findsOneWidget);
  });

  testWidgets('OfflinePostsTab removes saved post when bookmark icon is tapped', (WidgetTester tester) async {
    
    const testPost =  Post(id: 1, userId: 1, title: 'Test Post', body: 'Test Body');
    when(() => mockOfflinePostsBloc.state).thenReturn(const ContentState([testPost]));
    
    registerFallbackValue(const RemovePostOfflineEvent(1));

   
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OfflinePostsBloc>.value(
          value: mockOfflinePostsBloc,
          child: const OfflinePostsTab(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pump();

    
    verify(() => mockOfflinePostsBloc.add(any(that: isA<RemovePostOfflineEvent>()))).called(1);
  });
} 