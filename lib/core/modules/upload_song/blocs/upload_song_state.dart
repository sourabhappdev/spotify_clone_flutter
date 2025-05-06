import 'package:equatable/equatable.dart';

sealed class UploadSongState extends Equatable {
  const UploadSongState();

  @override
  List<Object> get props => [];
}

class UploadSongInitial extends UploadSongState {}

class UploadSongLoading extends UploadSongState {}

class UploadSongSuccess extends UploadSongState {
  final String message;

  const UploadSongSuccess(this.message);
}

class UploadSongFailure extends UploadSongState {
  final String error;

  const UploadSongFailure(this.error);
}
