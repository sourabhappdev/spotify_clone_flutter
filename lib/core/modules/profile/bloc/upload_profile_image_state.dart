part of 'upload_profile_image_cubit.dart';

sealed class UploadProfileImageState extends Equatable {
  const UploadProfileImageState();

  @override
  List<Object> get props => [];
}

final class UploadProfileImageInitial extends UploadProfileImageState {}

final class UploadProfileImageLoading extends UploadProfileImageState {}

final class UploadProfileImageSuccess extends UploadProfileImageState {
  final String message;

  const UploadProfileImageSuccess({required this.message});
}

final class UploadProfileImageFailure extends UploadProfileImageState {
  final String error;

  const UploadProfileImageFailure({required this.error});
}
