part of 'search_friend_cubit.dart';

sealed class SearchFriendState extends Equatable {
  const SearchFriendState();

  @override
  List<Object> get props => [];
}

final class SearchFriendInitial extends SearchFriendState {}

final class SearchFriendLoading extends SearchFriendState {}

final class SearchFriendLoaded extends SearchFriendState {
  final List<ProfileInfoModel> searchResults;

  const SearchFriendLoaded(this.searchResults);

  @override
  List<Object> get props => [searchResults];
}

