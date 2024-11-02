import 'package:flutter/material.dart';

extension HelperExtension on BuildContext {
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    final bool withNavBar = true,
    Object? args,
  }) =>
      Navigator.of(this, rootNavigator: !withNavBar)
          .pushNamed<T>(routeName, arguments: args);

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String routeName,
      {Object? args}) {
    return Navigator.of(this, rootNavigator: true).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: args,
    );
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    final bool withNavBar = true,
    Object? args,
  }) =>
      Navigator.of(this, rootNavigator: !withNavBar)
          .pushReplacementNamed<T?, TO>(routeName,
              arguments: args, result: result);

  void pop<T extends Object?>({T? args, bool withNavBar = true}) =>
      Navigator.of(this, rootNavigator: !withNavBar).pop<T?>(args);

  bool canPop({final bool withNavBar = true}) {
    final NavigatorState? navigator =
        Navigator.maybeOf(this, rootNavigator: !withNavBar);
    return navigator != null && navigator.canPop();
  }

  void hideBottomSheet<T extends Object?>({T? args}) =>
      pop(args: args, withNavBar: false);

  void hideDialog<T extends Object?>({T? args}) =>
      pop(args: args, withNavBar: false);
}
