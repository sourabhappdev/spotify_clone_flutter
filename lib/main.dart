import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/configs/manager/navigation_manager.dart';
import 'package:spotify_clone/core/configs/observer/bloc_observer.dart';
import 'package:spotify_clone/core/configs/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/modules/choose_mode/bloc/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  AppWriteService.instance.init();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationManager.navigatorKey,
            themeMode: mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            title: 'Spotify',
            initialRoute: AppRoutes.splashScreen,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            onGenerateRoute: NavigationManager.onGenerateRoute,
          );
        },
      ),
    );
  }
}
