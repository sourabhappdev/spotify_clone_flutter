import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spotify_clone/core/configs/assets/app_lottie.dart';

class CustomLoader {
  static void hideLoader<T extends Object?>(
    BuildContext context, {
    final T? args,
  }) =>
      Navigator.of(context).pop();

  /// Method to Show Loader from current Context
  static void showLoader(BuildContext context) => _showCustomLoader(context);

  static Future<void> _showCustomLoader(
    BuildContext context, {
    bool isDismissible = false,
  }) async =>
      await showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (context) =>
            PopScope(canPop: isDismissible, child: const SpotifyLoader()),
      );
}

class SpotifyLoader extends StatelessWidget {
  const SpotifyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 250,
        width: 250,
        child: LottieBuilder.asset(
          AppLottie.loader,
          alignment: Alignment.center,
          frameRate: FrameRate.max,
          filterQuality: FilterQuality.high,
          repeat: true,
        ),
      ),
    );
  }
}
