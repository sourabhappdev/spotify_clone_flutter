import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify_clone/core/modules/profile/models/profile_info_model.dart';

import '../../../../common/services/appwrite_service.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends HydratedCubit<ProfileInfoState> {
  ProfileInfoCubit() : super(ProfileInfoInitial());

  Future<void> getProfileInfo(String id) async {
    try {
      emit(ProfileInfoLoading());

      final data = await AppWriteService.databases.listDocuments(
          databaseId: dotenv.env['DB'] ?? '',
          collectionId: dotenv.env['USERS'] ?? '',
          queries: [Query.equal('id', id)]);

      emit(ProfileInfoSuccess(
        profileInfoModel: ProfileInfoModel.fromMap(data.documents.first.data),
      ));
    } on AppwriteException catch (e) {
      emit(ProfileInfoFailure(error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const ProfileInfoFailure(error: 'Something went wrong'));
    }
  }

  @override
  ProfileInfoState? fromJson(Map<String, dynamic> json) {
    try {
      switch (json['status']) {
        case 'ProfileInfoLoading':
          return ProfileInfoLoading();
        case 'ProfileInfoSuccess':
          return ProfileInfoSuccess(
            profileInfoModel:
                ProfileInfoModel.fromMap(json['profileInfoModel']),
          );
        case 'ProfileInfoFailure':
          return ProfileInfoFailure(error: json['error']);
        default:
          return ProfileInfoInitial();
      }
    } catch (_) {
      return ProfileInfoInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileInfoState state) {
    try {
      if (state is ProfileInfoLoading) {
        return {'status': 'ProfileInfoLoading'};
      } else if (state is ProfileInfoSuccess) {
        return {
          'status': 'ProfileInfoSuccess',
          'profileInfoModel': state.profileInfoModel.toMap(),
        };
      } else if (state is ProfileInfoFailure) {
        return {
          'status': 'ProfileInfoFailure',
          'error': state.error,
        };
      }
      return {'status': 'ProfileInfoInitial'};
    } catch (_) {
      return null;
    }
  }
}
