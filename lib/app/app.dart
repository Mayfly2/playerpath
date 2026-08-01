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
          );
        },
      ),
    );
  }
}
