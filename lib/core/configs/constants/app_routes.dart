class AppRoutes {
  static final AppRoutes instance = AppRoutes._();

  factory AppRoutes() {
    return instance;
  }

  AppRoutes._();

  static const String splashScreen = "/",
      upcomingPage = "upcomingPage",
      getStartedPage = 'getStartedPage',
      signInPage = "signInPage",
      signupPage = "signupPage",
      dashboardPage = "dashboardPage",
      profilePage = "profilePage",
      songPlayerPage = "songPlayerPage",
      chooseModePage = "chooseModePage",
      chooseSignInSignUpPage = "chooseSignInSignUpPage",
      uploadSongs = "uploadSongs",
      homePage = "homePage";
}
