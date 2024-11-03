import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';

part 'upload_profile_image_state.dart';

class UploadProfileImageCubit extends Cubit<UploadProfileImageState> {
  UploadProfileImageCubit() : super(UploadProfileImageInitial());

  Future<void> uploadImage(String imagePath, String docID) async {
    try {
      emit(UploadProfileImageLoading());

      final result = await AppWriteService.storage.createFile(
        bucketId: dotenv.env['PROFILE'] ?? '',
        fileId: ID.unique(),
        file: InputFile.fromPath(path: imagePath),
      );

      final fileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['PROFILE']}/files/${result.$id}/view?project=${dotenv.env['PROJECT']}';

      // Update the user's profile image URL in the database
      final updatedDoc = await AppWriteService.databases.updateDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['USERS'] ?? '',
        documentId: docID,
        data: {
          'image': fileUrl,
        },
      );
      print(updatedDoc);
      emit(const UploadProfileImageSuccess(message: "Upload success"));
    } on AppwriteException catch (e) {
      emit(UploadProfileImageFailure(
          error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const UploadProfileImageFailure(error: 'Something went wrong'));
    }
  }
}
