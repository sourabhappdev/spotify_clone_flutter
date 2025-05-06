import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';

part 'upload_profile_image_state.dart';

class UploadProfileImageCubit extends Cubit<UploadProfileImageState> {
  UploadProfileImageCubit() : super(UploadProfileImageInitial());

  Future<void> uploadImage(String imagePath) async {
    try {
      emit(UploadProfileImageLoading());
      final Document doc = await AppWriteService.databases.getDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['USERS'] ?? '',
        documentId: AppState.instance.userId,
      );

      final data = doc.data;
      final oldImageId = data['image_id'];

      if (oldImageId != null && oldImageId.isNotEmpty) {
        await AppWriteService.storage.deleteFile(
          bucketId: dotenv.env['PROFILE'] ?? '',
          fileId: oldImageId,
        );
      }

      final result = await AppWriteService.storage.createFile(
        bucketId: dotenv.env['PROFILE'] ?? '',
        fileId: ID.unique(),
        file: InputFile.fromPath(path: imagePath),
      );

      final fileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['PROFILE']}/files/${result.$id}/view?project=${dotenv.env['PROJECT']}';

      await AppWriteService.databases.updateDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['USERS'] ?? '',
        documentId: AppState.instance.userId,
        data: {
          'image': fileUrl,
          'image_id': result.$id,
        },
      );

      emit(const UploadProfileImageSuccess(message: "Upload success"));
    } on AppwriteException catch (e) {
      emit(UploadProfileImageFailure(
          error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const UploadProfileImageFailure(error: 'Something went wrong'));
    }
  }
}
