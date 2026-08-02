import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';
import '../features/settings/presentation/cubit/theme_cubit.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';

class PlayerPathApp extends StatelessWidget {
  const PlayerPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthCubit(AuthRepositoryImpl())..checkAuth()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeModeState>(
        builder: (context, themeState) {
          final themeCubit = context.read<ThemeCubit>();
          final isAuthenticated = context.watch<AuthCubit>().state is AuthAuthenticated;

          return MaterialApp.router(
            title: 'PlayerPath',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeCubit.themeMode,
            routerConfig: AppRouter.createRouter(isAuthenticated: isAuthenticated),
            builder: (context, child) {
              // Show branded splash while auth is loading
              final authState = context.watch<AuthCubit>().state;
              if (authState is AuthInitial) {
                return const _SplashScreen();
              }
              return child ??= const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF97316).withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.sports_soccer, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 28),
            Text(
              'PlayerPath',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Grassroots Football Recruitment',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFF97316),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
