import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify_clone/core/modules/profile/models/profile_info_model.dart';

import '../../../../common/services/appwrite_service.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit() : super(ProfileInfoInitial());

  late String docId;

  Future<void> getProfileInfo(String id) async {
    try {
      emit(ProfileInfoLoading());

      final data = await AppWriteService.databases.listDocuments(
          databaseId: dotenv.env['DB'] ?? '',
          collectionId: dotenv.env['USERS'] ?? '',
          queries: [Query.equal('id', id)]);

      docId = data.documents.first.$id;

      emit(ProfileInfoSuccess(
        profileInfoModel: ProfileInfoModel.fromMap(data.documents.first.data),
      ));
    } on AppwriteException catch (e) {
      emit(ProfileInfoFailure(error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const ProfileInfoFailure(error: 'Something went wrong'));
    }
  }
}
