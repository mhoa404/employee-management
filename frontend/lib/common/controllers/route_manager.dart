import 'package:error404project/web/views/AdminDashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../mobile/views/CompleteProfilePage.dart';
import '../../mobile/views/WorkSchedulePage.dart';
import '../../mobile/views/NotificationPage.dart';
import '../../mobile/views/WelcomePage.dart';
import '../../mobile/views/ManagePage.dart';
import '../../mobile/views/LoginPage.dart';
import '../../mobile/views/RegisPage.dart';
import '../../mobile/views/HomePage.dart';
import '../../mobile/views/TaskPage.dart';
import '../../web/views/WebRegister.dart';
import '../../web/views/WebLogin.dart';
import '../../web/views/Home.dart';

import '../widgets/BottomNavBarWidget.dart';
import '../services/auth_service.dart';

bool isAuthenticated = false; 

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) async {
    final path = state.uri.path;
    isAuthenticated = await authService.checkAuthStatus();
    if (kIsWeb) {
      if (isAuthenticated) {
        if (
          path == '/login' || 
          path == '/register' || 
          path == '/') {
          return '/home';
        }
      } else {
        if (path == '/home' ||
            path == '/tasks' ||
            path == '/notifications' ||
            path == '/manage' ||
            path == '/work-schedule' ||
            path == '/admin' ||
            path == '/') {
          return '/login';
        }
      }
    }
    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return kIsWeb ? const WebLogin() : const WelcomePage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return kIsWeb ? const WebLogin() : const LoginPage();
      },
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboard()
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return kIsWeb ? const WebRegister() : const RegisterPage();
      },
    ),
    GoRoute(
      path: '/work-schedule',
      builder: (context, state) {
        return const WorkSchedulePage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return kIsWeb ? const WebHome() : const HomePage();
      },
    ),

    GoRoute(
      path: '/complete-profile',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null || extra['userId'] == null) {
          return kIsWeb ? const WebLogin() : const LoginPage();
        }
        final int userId = extra['userId'];
        final bool fromRegister = extra['fromRegister'] ?? false;
        return CompleteProfilePage(userId: userId, fromRegister: fromRegister);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        int currentIndex = _getIndexFromPath(state.uri.toString());
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavBarWidget(currentIndex: currentIndex),
        );
      },
      routes: [
        GoRoute(path: '/tasks', builder: (context, state) => const TaskPage()),
        GoRoute(path: '/notifications', builder: (context, state) => const NotificationPage()),
        GoRoute(path: '/manage', builder: (context, state) => const ManagePage()),
      ],
    ),
  ],
);

int _getIndexFromPath(String path) {
  switch (path) {
    case '/home':
      return 0;
    case '/tasks':
      return 1;
    case '/notifications':
      return 2;
    case '/manage':
      return 3;
    default:
      return 0;
  }
}
