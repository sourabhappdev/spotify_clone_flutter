import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signin/signin_cubit.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signup/sign_up_cubit.dart';
import 'package:spotify_clone/core/modules/friend/add_friend_screen.dart';
import 'package:spotify_clone/core/modules/friend/bloc/friend_request/friend_request_cubit.dart';
import 'package:spotify_clone/core/modules/friend/friend_request_page.dart';
import 'package:spotify_clone/core/modules/friend/bloc/my_friends/my_friends_cubit.dart';
import 'package:spotify_clone/core/modules/friend/bloc/search_friends/search_friend_cubit.dart';
import 'package:spotify_clone/core/modules/friend/my_friends_screen.dart';
import 'package:spotify_clone/core/modules/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify_clone/core/modules/profile/bloc/log_out_cubit.dart';
import 'package:spotify_clone/core/modules/profile/bloc/profile_info_cubit.dart';
import 'package:spotify_clone/core/modules/profile/bloc/upload_profile_image_cubit.dart';
import 'package:spotify_clone/core/modules/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/core/modules/upload_song/blocs/upload_song_cubit.dart';
import 'package:spotify_clone/core/modules/upload_song/page/upload_song.dart';

import '../../modules/auth/pages/signin.dart';
import '../../modules/auth/pages/signup.dart';
import '../../modules/auth/pages/signup_or_siginin.dart';
import '../../modules/choose_mode/pages/choose_mode_page.dart';
import '../../modules/friend/bloc/add_friend/add_friend_cubit.dart';
import '../../modules/friend/friend_profile.dart';
import '../../modules/home/bloc/new_songs_cubit.dart';
import '../../modules/home/pages/home.dart';
import '../../modules/intro/pages/get_started_page.dart';
import '../../modules/profile/bloc/select_image_cubit.dart';
import '../../modules/profile/pages/profile.dart';
import '../../modules/song_player/pages/song_player.dart';
import '../../modules/splash/pages/splash.dart';
import '../../modules/upcoming_page.dart';

class NavigationManager {
  static final NavigationManager instance = NavigationManager._();

  factory NavigationManager() {
    return instance;
  }

  NavigationManager._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => getRouteScreen(
        routeName: settings.name ?? "",
        args: args,
      ),
    );
  }

  static Widget getRouteScreen({
    required final String routeName,
    required final Map<String, dynamic>? args,
  }) {
    Widget routeScreen = const UpcomingPage();
    switch (routeName) {
      case AppRoutes.splashScreen:
        routeScreen = const SplashPage();
        break;
      case AppRoutes.upcomingPage:
        routeScreen = const UpcomingPage();
        break;
      case AppRoutes.getStartedPage:
        routeScreen = const GetStartedPage();
        break;
      case AppRoutes.uploadSongs:
        routeScreen = BlocProvider(
          create: (_) => UploadSongCubit(),
          child: const UploadSongPage(),
        );
      case AppRoutes.signInPage:
        routeScreen = BlocProvider(
          create: (_) => SignInCubit(),
          child: const SignInPage(),
        );
        break;
      case AppRoutes.signupPage:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => SignUpCubit(),
            ),
          ],
          child: const SignupPage(),
        );
        break;
      case AppRoutes.dashboardPage:
        // routeScreen = const DashboardPage();
        break;
      case AppRoutes.profilePage:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ProfileInfoCubit(),
            ),
            BlocProvider(
              create: (_) => SelectImageCubit(),
            ),
            BlocProvider(
              create: (_) => UploadProfileImageCubit(),
            ),
            BlocProvider(
              create: (_) => FavoriteSongsCubit(),
            ),
            BlocProvider(
              create: (_) => LogOutCubit(),
            ),
          ],
          child: const ProfilePage(),
        );
        break;
      case AppRoutes.songPlayerPage:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SongPlayerCubit(),
            ),
            BlocProvider(
              create: (context) => FavoriteSongsCubit(),
            ),
          ],
          child: SongPlayerPage(
            songEntityList: args!['songEntity'],
          ),
        );
        break;
      case AppRoutes.chooseModePage:
        routeScreen = const ChooseModePage();
        break;
      case AppRoutes.homePage:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => NewSongsCubit(),
            ),
            BlocProvider(
              create: (_) => FavoriteSongsCubit(),
            ),
          ],
          child: const HomePage(),
        );
        break;
      case AppRoutes.addFriends:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => SearchFriendCubit(),
            ),
            BlocProvider(
              create: (_) => AddFriendCubit(),
            ),
          ],
          child: const AddFriendsScreen(),
        );
        break;
      case AppRoutes.friendRequest:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => FriendRequestsCubit(),
            ),
            BlocProvider(
              create: (_) => AddFriendCubit(),
            ),
          ],
          child: const FriendRequestsPage(),
        );
        break;
      case AppRoutes.myFriends:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => MyFriendsCubit(),
            ),
          ],
          child: const MyFriendsScreen(),
        );
        break;
      case AppRoutes.friendsProfile:
        routeScreen = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => MyFriendsCubit(),
            ),
            BlocProvider(
              create: (_) => FavoriteSongsCubit(),
            ),
          ],
          child: FriendsProfile(
            profileInfoModel: args?['profileInfoModel'],
          ),
        );
        break;
      case AppRoutes.chooseSignInSignUpPage:
        routeScreen = const SignupOrSigninPage();
        break;
      default:
        routeScreen = const UpcomingPage();
        break;
    }
    return routeScreen;
  }
}
