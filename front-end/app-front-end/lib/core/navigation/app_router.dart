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
import '../../features/consumption/presentation/pages/ai_insights_page.dart';
import '../../features/inventory/presentation/pages/inventory_list_page.dart';
import '../../features/inventory/presentation/pages/add_inventory_item_page.dart';
import '../../features/inventory/presentation/pages/edit_inventory_item_page.dart';
import '../../features/inventory/presentation/pages/inventory_item_details_page.dart';
import '../../features/inventory/domain/entities/inventory_item.dart';
import '../../features/resources/presentation/pages/resources_list_page.dart';
import '../../features/resources/presentation/pages/resource_details_page.dart';
import '../../features/resources/domain/entities/resource.dart';
import '../../features/surplus/presentation/pages/surplus_feed_page.dart';
import '../../features/surplus/presentation/pages/surplus_detail_page.dart';
import '../../features/surplus/presentation/pages/request_surplus_page.dart';
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
    
    // AI Insights (outside shell)
    GoRoute(
      path: '/ai-insights',
      builder: (context, state) => const AIInsightsPage(),
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
    
    // Inventory Routes (outside shell)
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryListPage(),
    ),
    GoRoute(
      path: '/inventory/add',
      builder: (context, state) => const AddInventoryItemPage(),
    ),
    GoRoute(
      path: '/inventory/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        // In a real app, fetch item from BLoC/repository
        // For now, using sample data
        final item = InventoryItemSamples.items.firstWhere(
          (item) => item.id == id,
          orElse: () => InventoryItemSamples.featured,
        );
        return EditInventoryItemPage(item: item);
      },
    ),
    GoRoute(
      path: '/inventory/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        // In a real app, fetch item from BLoC/repository
        // For now, using sample data
        final item = InventoryItemSamples.items.firstWhere(
          (item) => item.id == id,
          orElse: () => InventoryItemSamples.featured,
        );
        return InventoryItemDetailsPage(item: item);
      },
    ),
    
    // Resources Routes (outside shell)
    GoRoute(
      path: '/resources',
      builder: (context, state) => const ResourcesListPage(),
    ),
    GoRoute(
      path: '/resources/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        // In a real app, fetch resource from BLoC/repository
        // For now, using sample data
        final resource = ResourceSamples.items.firstWhere(
          (resource) => resource.id == id,
          orElse: () => ResourceSamples.featured,
        );
        return ResourceDetailsPage(resource: resource);
      },
    ),
    
    // Surplus Routes (outside shell)
    GoRoute(
      path: '/surplus',
      builder: (context, state) => const SurplusFeedPage(),
    ),
    GoRoute(
      path: '/surplus/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SurplusDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/surplus/request/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RequestSurplusPage(itemId: id);
      },
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
