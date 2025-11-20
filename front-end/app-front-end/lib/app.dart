
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khaddo/core/navigation/app_router.dart';
import 'package:khaddo/core/theme/app_theme.dart';
import 'package:khaddo/features/auth/presentation/bloc/auth_bloc.dart';
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
        return BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
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

