import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';

import '../../../../configs/manager/storage_manager.dart';

part 'sign_up_state.dart';

class SignUpCubit extends HydratedCubit<SignUpState> {
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
          documentId: ID.unique(),
          permissions: [
            Permission.write(Role.any()),
            Permission.read(Role.any()),
          ],
          data: {
            'name': user.name,
            'email': user.email,
            'id': user.$id,
          });
      await StorageManager.instance.saveData('userId', user.$id);
      await StorageManager.instance.saveData('sessionId', session.$id);
      print('User registered successfully: ${user.toMap()}');
      emit(const SignUpSuccess('Account created'));
    } on AppwriteException catch (e) {
      emit(SignUpFailure(e.toString()));
    } catch (e) {
      emit(const SignUpFailure('Something went wrong'));
    }
  }

  @override
  SignUpState? fromJson(Map<String, dynamic> json) {
    final state = json['state'] as String?;

    switch (state) {
      case 'SignUpInitial':
        return SignUpInitial();
      case 'SignUpLoading':
        return SignUpLoading();
      case 'SignUpSuccess':
        return const SignUpSuccess('Account created');
      case 'SignUpFailure':
        final error = json['error'] as String?;
        return SignUpFailure(error ?? 'Unknown error');
      default:
        return SignUpInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(SignUpState state) {
    // Serialize the state to JSON
    if (state is SignUpInitial) {
      return {'state': 'SignUpInitial'};
    } else if (state is SignUpLoading) {
      return {'state': 'SignUpLoading'};
    } else if (state is SignUpSuccess) {
      return {'state': 'SignUpSuccess'};
    } else if (state is SignUpFailure) {
      return {
        'state': 'SignUpFailure',
        'error': state.error,
      };
    }
    return null;
  }
}
