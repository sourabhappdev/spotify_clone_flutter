import 'dart:io';

import 'package:appwrite/appwrite.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/modules/upload_song/blocs/upload_song_state.dart';

class UploadSongCubit extends Cubit<UploadSongState> {
  UploadSongCubit() : super(UploadSongInitial());

  Future<File?> pickMP3File() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        return File(result.files.single.path!);
      }
      emit(const UploadSongFailure('Pick MP3 file cancelled'));
      return null;
    } catch (e) {
      emit(UploadSongFailure('Failed to pick MP3 file: ${e.toString()}'));
      return null;
    }
  }

  Future<File?> pickCoverImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      emit(UploadSongFailure('Failed to pick image: ${e.toString()}'));
      return null;
    }
  }

  Future<void> uploadSong({
    required String songName,
    required List<String> artists,
    required File songFile,
    required File coverImage,
    required String duration,
  }) async {
    try {
      emit(UploadSongLoading());
      final songFileResult = await AppWriteService.storage.createFile(
          bucketId: dotenv.env['SONGS_BUCKET'] ?? '',
          fileId: ID.unique(),
          file: InputFile.fromPath(path: songFile.path));
      final songFileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['SONGS_BUCKET']}/files/${songFileResult.$id}/view?project=${dotenv.env['PROJECT']}';

      final coverImageFileResult = await AppWriteService.storage.createFile(
          bucketId: dotenv.env['COVER_IMAGES_BUCKET'] ?? '',
          fileId: ID.unique(),
          file: InputFile.fromPath(path: coverImage.path));
      final coverImageFileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['COVER_IMAGES_BUCKET']}/files/${coverImageFileResult.$id}/view?project=${dotenv.env['PROJECT']}';

      await AppWriteService.databases.createDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['SONGS'] ?? '',
        documentId: ID.unique(),
        data: {
          'name': songName,
          'artists': artists,
          'url': songFileUrl,
          'cover_image': coverImageFileUrl,
          'duration': duration,
        },
      );

      emit(const UploadSongSuccess('Song uploaded successfully!'));
    } catch (e) {
      emit(UploadSongFailure('Failed to upload song: ${e.toString()}'));
    }
  }
}
