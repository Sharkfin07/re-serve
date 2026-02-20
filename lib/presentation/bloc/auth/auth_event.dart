import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordRepeat,
  });

  final String name;
  final String email;
  final String password;
  final String passwordRepeat;

  @override
  List<Object?> get props => [name, email, password, passwordRepeat];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthRefreshUserRequested extends AuthEvent {
  const AuthRefreshUserRequested();
}

class AuthUpdateProfileRequested extends AuthEvent {
  const AuthUpdateProfileRequested({
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.phoneNumber,
  });

  final String name;
  final String email;
  final String? profilePictureUrl;
  final String? phoneNumber;

  @override
  List<Object?> get props => [name, email, profilePictureUrl, phoneNumber];
}
