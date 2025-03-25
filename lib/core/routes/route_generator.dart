import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/routes/app_routes.dart';
import 'package:flutter_tech_task/features/comments/presentation/page/comments_page.dart';
import 'package:flutter_tech_task/features/post_detail/presentation/page/details_page.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/page/listing_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.listing:
        return MaterialPageRoute(
          builder: (_) => const ListingPage(),
        );
      case AppRoutes.details:
        return MaterialPageRoute(
          builder: (_) => const DetailsPage(),
          settings: settings,
        );
      case AppRoutes.comments:
        return MaterialPageRoute(
          builder: (_) => const CommentsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
    }
  }
}
