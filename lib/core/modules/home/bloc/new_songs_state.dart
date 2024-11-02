import 'package:equatable/equatable.dart';
import 'package:spotify_clone/core/modules/auth/Models/song_model.dart';

sealed class NewSongsState extends Equatable {
  const NewSongsState();

  @override
  List<Object?> get props => [];
}

final class NewSongsInitial extends NewSongsState {}

final class NewSongsLoading extends NewSongsState {}

final class NewSongsSuccess extends NewSongsState {
  final List<SongModel> songs;

  const NewSongsSuccess(this.songs);
}

final class NewSongsFailure extends NewSongsState {
  final String error;

  const NewSongsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
