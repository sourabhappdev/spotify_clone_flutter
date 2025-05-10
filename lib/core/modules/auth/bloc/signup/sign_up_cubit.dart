import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/configs/constants/string_res.dart';

import '../../../../../common/services/app_state.dart';
import '../../../../../common/services/firebase_services.dart';
import '../../../../configs/manager/storage_manager.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  void createAccount(
      {required String email,
      required String password,
      required String name}) async {
    try {
      emit(SignUpLoading());
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return emit(const SignUpFailure("Fields cannot be empty"));
      }

      final User user = await AppWriteService.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      final Session session = await AppWriteService.account
          .createEmailPasswordSession(email: email, password: password);
      await AppWriteService.databases.createDocument(
          databaseId: dotenv.env['DB'] ?? '',
          collectionId: dotenv.env['USERS'] ?? '',
          documentId: user.$id,
          permissions: [
            Permission.write(Role.any()),
            Permission.read(Role.any()),
          ],
          data: {
            'name': user.name,
            'email': user.email,
            'id': user.$id,
            'fcm_token': FirebaseServices().fcmToken,
          });
      AppState.instance.setUserId = user.$id;
      AppState.instance.setSessionId = session.$id;
      await StorageManager.instance.saveData(StringRes.userId, user.$id);
      await StorageManager.instance.saveData(StringRes.sessionId, session.$id);
      emit(const SignUpSuccess('Account created'));
    } on AppwriteException catch (e) {
      emit(SignUpFailure(e.toString()));
    } catch (e) {
      emit(const SignUpFailure('Something went wrong'));
    }
  }
}
