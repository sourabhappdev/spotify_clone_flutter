import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/configs/manager/storage_manager.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signin/signin_state.dart';

class SignInCubit extends HydratedCubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  void signIn({required String email, required String password}) async {
    try {
      emit(SignInLoading());
      if (email.isEmpty || password.isEmpty) {
        return emit(const SignInFailure("Fields cannot be empty"));
      }
      final session = await AppWriteService.account
          .createEmailPasswordSession(email: email, password: password);
      await StorageManager.instance.saveData('userId', session.userId);
      await StorageManager.instance.saveData('sessionId', session.secret);
      print(session.toMap());

      emit(const SignInSuccess('Signed In'));
    } on AppwriteException catch (e) {
      emit(SignInFailure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const SignInFailure('Something went wrong'));
    }
  }

  @override
  SignInState? fromJson(Map<String, dynamic> json) {
    final state = json['state'] as String?;

    switch (state) {
      case 'SignInInitial':
        return SignInInitial();
      case 'SignInLoading':
        return SignInLoading();
      case 'SignInSuccess':
        return const SignInSuccess('Signed In');
      case 'SignInFailure':
        final error = json['error'] as String?;
        return SignInFailure(error ?? 'Unknown error');
      default:
        return SignInInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(SignInState state) {
    if (state is SignInInitial) {
      return {'state': 'SignInInitial'};
    } else if (state is SignInLoading) {
      return {'state': 'SignInLoading'};
    } else if (state is SignInSuccess) {
      return {'state': 'SignInSuccess'};
    } else if (state is SignInFailure) {
      return {
        'state': 'SignInFailure',
        'error': state.error,
      };
    }
    return null;
  }
}
