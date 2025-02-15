class StringRes {
  static final StringRes instance = StringRes._();

  factory StringRes() {
    return instance;
  }

  StringRes._();

  static const String userId = "userId",
      sessionId = "sessionId",
      likedSongs = "liked_songs",
      somethingWrong = "Oops! Something went wrong. Please try again.";
}
