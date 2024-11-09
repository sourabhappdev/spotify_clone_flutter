import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/core/modules/profile/models/profile_info_model.dart';

import '../../../../common/services/appwrite_service.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit() : super(ProfileInfoInitial());

  Future<void> getProfileInfo(String id) async {
    try {
      emit(ProfileInfoLoading());

      final userDoc = await AppWriteService.databases.getDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['USERS'] ?? '',
        documentId: id,
      );

      emit(ProfileInfoSuccess(
        profileInfoModel: ProfileInfoModel.fromMap(userDoc.data),
      ));
    } on AppwriteException catch (e) {
      emit(ProfileInfoFailure(error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const ProfileInfoFailure(error: 'Something went wrong'));
    }
  }
}
