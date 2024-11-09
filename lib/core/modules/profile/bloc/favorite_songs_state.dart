part of 'favorite_songs_cubit.dart';

sealed class FavoriteSongsState extends Equatable {
  const FavoriteSongsState();

  @override
  List<Object> get props => [];
}

final class FavoriteSongsInitial extends FavoriteSongsState {}

final class AddToFavoriteSongsLoading extends FavoriteSongsState {}

final class AddToFavoriteSongsSuccess extends FavoriteSongsState {
  final String message;

  const AddToFavoriteSongsSuccess({required this.message});
}

final class AddToFavoriteSongsFailure extends FavoriteSongsState {
  final String error;

  const AddToFavoriteSongsFailure({required this.error});
}

final class RemoveFavoriteSongsLoading extends FavoriteSongsState {}

final class RemoveFavoriteSongsSuccess extends FavoriteSongsState {
  final String message;

  const RemoveFavoriteSongsSuccess({required this.message});
}

final class RemoveFavoriteSongsFailure extends FavoriteSongsState {
  final String error;

  const RemoveFavoriteSongsFailure({required this.error});
}

final class SetLikedSongsLoading extends FavoriteSongsState {}

final class SetLikedSongsSuccess extends FavoriteSongsState {}

final class SetLikedSongsFailure extends FavoriteSongsState {
  final String error;

  const SetLikedSongsFailure({required this.error});
}
