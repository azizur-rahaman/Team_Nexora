import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_home_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/rewards/presentation/pages/rewards_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/consumption/presentation/pages/consumption_logs_list_page.dart';
import '../../features/consumption/presentation/pages/add_consumption_log_page.dart';
import '../../features/consumption/presentation/pages/edit_consumption_log_page.dart';
import '../../features/consumption/presentation/pages/consumption_log_details_page.dart';
import 'scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    
    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    
    // Notifications (outside shell)
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
    
    // Consumption Logs (outside shell)
    GoRoute(
      path: '/consumption-logs',
      builder: (context, state) => const ConsumptionLogsListPage(),
    ),
    GoRoute(
      path: '/consumption-logs/add',
      builder: (context, state) => const AddConsumptionLogPage(),
    ),
    GoRoute(
      path: '/consumption-logs/edit',
      builder: (context, state) => EditConsumptionLogPage(),
    ),
    GoRoute(
      path: '/consumption-logs/details',
      builder: (context, state) => ConsumptionLogDetailsPage.preview(),
    ),
    
    // Profile Settings (outside shell)
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/profile/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    
    // Shell Routes with Bottom Navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        // Home/Dashboard
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardHomePage(),
          ),
        ),
        
        // Explore
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ExplorePage(),
          ),
        ),
        
        // Rewards
        GoRoute(
          path: '/rewards',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: RewardsPage(),
          ),
        ),
        
        // Profile
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
      ],
    ),
  ],
);
