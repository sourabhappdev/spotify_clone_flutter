class AppImages {
  static final AppImages instance = AppImages._();

  factory AppImages() {
    return instance;
  }

  AppImages._();

  static const String basePath = 'assets/images/';

  static const String introBG = '${basePath}intro_bg.png';
  static const String chooseModeBG = '${basePath}choose_mode_bg.png';
  static const String authBG = '${basePath}auth_bg.png';
  static const String homeArtist = '${basePath}home_artist.png';
}
