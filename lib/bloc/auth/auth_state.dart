part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final KaryawanModel karyawan;

  const AuthSuccess({
    required this.karyawan,
  });

  @override
  List<Object> get props => [karyawan];
}

class AuthFailed extends AuthState {
  final ErrorModel errorModel;

  const AuthFailed({required this.errorModel});

  @override
  List<Object> get props => [errorModel];
}

class SignupSuccess extends AuthState {}

class SignupFailed extends AuthState {
  final ErrorModel errorModel;

  const SignupFailed({required this.errorModel});

  @override
  List<Object> get props => [errorModel];
}

class SignoutSuccess extends AuthState {}

class SignoutFailed extends AuthState {
  final String errorMessage;

  const SignoutFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class EmailValidationSuccess extends AuthState {
  final String email;

  const EmailValidationSuccess({required this.email});

  @override
  List<Object> get props => [email];
}

class EmailValidationFailed extends AuthState {
  final ErrorModel errorModel;

  const EmailValidationFailed({
    required this.errorModel,
  });

  @override
  List<Object> get props => [errorModel];
}

class EmailValidationForResetPasswordSuccess extends AuthState {
  final String message;

  const EmailValidationForResetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class EmailValidationForResetPasswordFailed extends AuthState {
  final ErrorModel errorModel;

  const EmailValidationForResetPasswordFailed({
    required this.errorModel,
  });

  @override
  List<Object> get props => [errorModel];
}
