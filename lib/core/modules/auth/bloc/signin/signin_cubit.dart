import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/configs/constants/string_res.dart';
import 'package:spotify_clone/core/configs/manager/storage_manager.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signin/signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  void signIn({required String email, required String password}) async {
    try {
      emit(SignInLoading());
      if (email.isEmpty || password.isEmpty) {
        return emit(const SignInFailure("Fields cannot be empty"));
      }
      final Session session = await AppWriteService.account
          .createEmailPasswordSession(email: email, password: password);
      AppState.instance.setUserId = session.userId;
      AppState.instance.setSessionId = session.$id;
      await StorageManager.instance.saveData(StringRes.userId, session.userId);
      await StorageManager.instance.saveData(StringRes.sessionId, session.$id);
      emit(const SignInSuccess('Signed In'));
    } on AppwriteException catch (e) {
      emit(SignInFailure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const SignInFailure('Something went wrong'));
    }
  }
}
