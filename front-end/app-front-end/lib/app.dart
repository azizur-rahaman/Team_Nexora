
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khaddo/core/navigation/app_router.dart';
import 'package:khaddo/core/theme/app_theme.dart';
import 'package:khaddo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khaddo/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:khaddo/features/resources/presentation/bloc/resource_bloc.dart';
import 'package:khaddo/features/surplus/presentation/bloc/surplus_bloc.dart';
import 'package:khaddo/injection_container.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => di.sl<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => di.sl<InventoryBloc>(),
            ),
            BlocProvider(
              create: (_) => di.sl<ResourceBloc>(),
            ),
            BlocProvider(
              create: (_) => di.sl<SurplusBloc>(),
            ),
          ],
          child: MaterialApp.router(
            title: 'FoodFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}

