import 'package:flutter/material.dart';
import 'pages/signin.dart';
import 'package:go_router/go_router.dart';
import 'pages/signup.dart';
import 'pages/todo.dart';

final _router = GoRouter(
  initialLocation: '/signin',
  routes: [
    GoRoute(
      path: '/signin',
      builder: (context, state) => const Signin(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const Signup(),
    ),
    GoRoute(
      path: '/todo',
      builder: (context, state) => const Todo(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
