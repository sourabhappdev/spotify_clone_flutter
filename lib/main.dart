import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/configs/manager/navigation_manager.dart';
import 'package:spotify_clone/core/configs/observer/bloc_observer.dart';
import 'package:spotify_clone/core/configs/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/modules/choose_mode/bloc/theme_cubit.dart';
import 'firebase_options.dart';

void main() {
  mainDelegate();
}

void mainDelegate() async {
  runZonedGuarded<void>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await dotenv.load(fileName: ".env");
    AppWriteService.instance.init();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
    await JustAudioBackground.init(
        androidNotificationChannelId: 'com.sourabh.spotify.clone.app',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        preloadArtwork: true);
    Bloc.observer = AppBlocObserver();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stack) {
    debugPrint("error found in main=> ${error.toString()}");
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
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
