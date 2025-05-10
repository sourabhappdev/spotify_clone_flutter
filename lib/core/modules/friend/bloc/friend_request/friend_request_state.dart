part of 'friend_request_cubit.dart';


sealed class FriendRequestsState extends Equatable {
  const FriendRequestsState();
  @override
  List<Object> get props => [];
}

class FriendRequestsInitial extends FriendRequestsState {}

class FriendRequestsLoading extends FriendRequestsState {}

class FriendRequestsLoaded extends FriendRequestsState {
  final List<FriendRequest> requests;
  const FriendRequestsLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class FriendRequestsError extends FriendRequestsState {
  final String message;
  const FriendRequestsError(this.message);
}
