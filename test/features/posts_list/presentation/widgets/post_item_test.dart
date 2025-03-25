import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/routes/app_routes.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/widgets/post_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late Post testPost;
  
  setUp(() {
    testPost = const Post(
      id: 1,
      userId: 1,
      title: 'Test Post Title',
      body: 'Test Post Body with more content to test the ellipsis',
    );
  });
  
  testWidgets('PostItem displays post data correctly', (WidgetTester tester) async {
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostItem(
            post: testPost,
          ),
        ),
      ),
    );
    
    
    expect(find.text('Test Post Title'), findsOneWidget);
    expect(find.text('Test Post Body with more content to test the ellipsis'), findsOneWidget);
    expect(find.text('User: 1'), findsOneWidget);
    
    expect(find.byIcon(Icons.bookmark), findsNothing);
    expect(find.byIcon(Icons.bookmark_border), findsNothing);
  });
  
  testWidgets('PostItem shows bookmark_border icon when post is not saved', (WidgetTester tester) async {
    
    bool savePressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostItem(
            post: testPost,
            isSaved: false,
            onSavePressed: () {
              savePressed = true;
            },
          ),
        ),
      ),
    );
    
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    
    await tester.tap(find.byIcon(Icons.bookmark_border));
    
    expect(savePressed, true);
  });
  
  testWidgets('PostItem shows filled bookmark icon for saved posts', (WidgetTester tester) async {
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostItem(
            post: testPost,
            isSaved: true,
            onSavePressed: () {},
          ),
        ),
      ),
    );
    
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsNothing);
  });
  
  testWidgets('PostItem navigates to details when tapped', (WidgetTester tester) async {
    
    final mockObserver = MockNavigatorObserver();
    
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.details) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Text('Details Page'),
              ),
              settings: settings,
            );
          }
          return null;
        },
        home: Scaffold(
          body: PostItem(
            post: testPost,
          ),
        ),
      ),
    );
    
    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();
    
    expect(find.text('Details Page'), findsOneWidget);
  });
} 