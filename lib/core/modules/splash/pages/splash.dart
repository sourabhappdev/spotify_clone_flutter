import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/configs/manager/storage_manager.dart';

import '../../../configs/assets/app_vectors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset(AppVectors.logo)),
    );
  }

  Future<void> redirect() async {
    await StorageManager.instance.setSPInstance();
    String route = AppRoutes.getStartedPage;
    await Future.wait([
      AppState.instance.setInitialValues(),
    ]);
    if (AppState.instance.userId.isNotEmpty) {
      route = AppRoutes.homePage;
    }
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) context.pushReplacementNamed(route);
  }
}
