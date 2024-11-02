// sign_in_state.dart
import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final String message;

  const SignInSuccess(this.message);
}

final class SignInFailure extends SignInState {
  final String error;

  const SignInFailure(this.error);

  @override
  List<Object?> get props => [error];
}
