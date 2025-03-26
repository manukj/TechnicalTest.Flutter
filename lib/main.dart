import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/core/di/injection_container.dart' as di;
import 'package:flutter_tech_task/core/routes/app_routes.dart';
import 'package:flutter_tech_task/core/routes/route_generator.dart';
import 'package:flutter_tech_task/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/offline_posts_bloc.dart';
import 'package:flutter_tech_task/features/posts_list/presentation/bloc/posts_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsBloc>(
          create: (_) => di.sl<PostsBloc>(),
        ),
        BlocProvider<OfflinePostsBloc>(
          create: (_) => di.sl<OfflinePostsBloc>(),
        ),
        BlocProvider<CommentsBloc>(
          create: (_) => di.sl<CommentsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Tech Task',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRoutes.listing,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
