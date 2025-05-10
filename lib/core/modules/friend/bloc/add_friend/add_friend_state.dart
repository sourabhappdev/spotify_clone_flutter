part of 'add_friend_cubit.dart';

sealed class AddFriendState extends Equatable {
  const AddFriendState();

  @override
  List<Object> get props => [];
}

final class AddFriendInitial extends AddFriendState {}

final class AddFriendLoading extends AddFriendState {}

final class AddFriendSuccess extends AddFriendState {
  final String msg;

  const AddFriendSuccess(this.msg);
}
final class AddFriendFailure extends AddFriendState {
  final String msg;

  const AddFriendFailure(this.msg);
}
