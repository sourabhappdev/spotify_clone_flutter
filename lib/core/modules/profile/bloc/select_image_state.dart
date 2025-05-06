part of 'select_image_cubit.dart';

sealed class SelectImageState extends Equatable {
  const SelectImageState();

  @override
  List<Object> get props => [];
}

final class SelectImageInitial extends SelectImageState {}

final class SelectImageLoading extends SelectImageState {}

final class SelectImageSuccess extends SelectImageState {
  final String image;

  const SelectImageSuccess({required this.image});
}

final class SelectImageFailure extends SelectImageState {
  final String error;

  const SelectImageFailure({required this.error});
}
