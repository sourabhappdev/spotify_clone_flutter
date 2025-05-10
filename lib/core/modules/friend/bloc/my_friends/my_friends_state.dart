part of 'my_friends_cubit.dart';

sealed class MyFriendsState extends Equatable {
  const MyFriendsState();

  @override
  List<Object> get props => [];
}

class MyFriendsInitial extends MyFriendsState {}

class MyFriendsLoading extends MyFriendsState {}

class MyFriendsLoaded extends MyFriendsState {
  final List<ProfileInfoModel> friends;

  const MyFriendsLoaded(this.friends);

  @override
  List<Object> get props => [friends];
}

class MyFriendsError extends MyFriendsState {
  final String message;

  const MyFriendsError(this.message);

  @override
  List<Object> get props => [message];
}
