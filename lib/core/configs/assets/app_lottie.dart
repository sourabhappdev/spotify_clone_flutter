class AppLottie {
  static final AppLottie instance = AppLottie._();

  factory AppLottie() {
    return instance;
  }

  AppLottie._();

  static const String basePath = 'assets/lottie/';

  static const String loader = '${basePath}loading_animation.json';
}
