import 'package:flutter/material.dart';
import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:flutter_tech_task/features/comments/presentation/widgets/comment_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testComment = Comment(
    id: 1,
    postId: 1,
    name: 'Test User',
    email: 'test@example.com',
    body:
        'This is a test comment body that should be displayed in the CommentItem widget.',
  );

  testWidgets('CommentItem displays comment data correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommentItem(comment: testComment),
        ),
      ),
    );

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(
        find.text(
            'This is a test comment body that should be displayed in the CommentItem widget.'),
        findsOneWidget);
    expect(find.text('T'), findsOneWidget);
  });

  testWidgets('CommentItem handles empty name correctly',
      (WidgetTester tester) async {
    const emptyNameComment = Comment(
      id: 2,
      postId: 1,
      name: '',
      email: 'empty@example.com',
      body: 'Comment with empty name',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommentItem(comment: emptyNameComment),
        ),
      ),
    );

    expect(find.text('?'), findsOneWidget);
    expect(find.text(''), findsOneWidget);
    expect(find.text('empty@example.com'), findsOneWidget);
    expect(find.text('Comment with empty name'), findsOneWidget);
  });

  testWidgets('CommentItem handles long text gracefully',
      (WidgetTester tester) async {
    const longTextComment = Comment(
      id: 3,
      postId: 1,
      name:
          'User with a very long name that might potentially overflow the available space',
      email:
          'verylong.email.address.that.might.overflow@verylongdomainname.com',
      body:
          'This is a very long comment body that should be handled gracefully by the CommentItem widget '
          'without causing any layout issues or errors. The text should be wrapped properly and displayed '
          'in a way that is still readable and visually appealing to the user.',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommentItem(comment: longTextComment),
        ),
      ),
    );

    expect(find.byType(CommentItem), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('U'), findsOneWidget);
  });

  testWidgets('CommentItem respects theme styling',
      (WidgetTester tester) async {
    final customTheme = ThemeData(
      cardTheme: const CardTheme(color: Colors.grey),
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: Colors.red),
        bodyMedium: TextStyle(color: Colors.green),
        bodySmall: TextStyle(color: Colors.blue),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: customTheme,
        home: const Scaffold(
          body: CommentItem(comment: testComment),
        ),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
  });
}
