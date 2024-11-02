part of 'profile_info_cubit.dart';

sealed class ProfileInfoState extends Equatable {
  const ProfileInfoState();

  @override
  List<Object> get props => [];
}

final class ProfileInfoInitial extends ProfileInfoState {}

final class ProfileInfoLoading extends ProfileInfoState {}

final class ProfileInfoSuccess extends ProfileInfoState {
  final ProfileInfoModel profileInfoModel;

  const ProfileInfoSuccess({required this.profileInfoModel});
}

final class ProfileInfoFailure extends ProfileInfoState {
  final String error;

  const ProfileInfoFailure({required this.error});
}
