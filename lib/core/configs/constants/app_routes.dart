class AppRoutes {
  static final AppRoutes instance = AppRoutes._();

  factory AppRoutes() {
    return instance;
  }

  AppRoutes._();

  static const String splashScreen = "/",
      upcomingPage = "upcomingPage",
      addFriends = "addFriendsPage",
      friendRequest = "friendRequest",
      friendsProfile = "friendsProfile",
      myFriends = "myFriends",
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
