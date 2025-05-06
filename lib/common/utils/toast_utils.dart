import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

class ToastUtils {
  static void showSuccessToast(
      {required BuildContext context, required String msg}) {
    showSuccess(message: msg);
  }

  static void showFailedToast(
      {required BuildContext context, required String msg}) {
    showFailed(message: msg);
  }

  static void showSuccess({required String message, int duration = 3}) {
    BotToast.showCustomNotification(
      align: Alignment.bottomCenter,
      duration: Duration(seconds: duration),
      toastBuilder: (cancelFunc) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Card(
          elevation: 15,
          color: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: "Satoshi"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showFailed({required String message, int duration = 3}) {
    BotToast.showCustomNotification(
      align: Alignment.bottomCenter,
      duration: Duration(seconds: duration),
      toastBuilder: (cancelFunc) => Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 15,
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: "Satoshi"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
