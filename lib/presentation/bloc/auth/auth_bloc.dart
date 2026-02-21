import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_event.dart';
import 'package:re_serve/presentation/bloc/auth/auth_state.dart';
import 'package:re_serve/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthRefreshUserRequested>(_onRefreshUserRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (!isLoggedIn) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
        return;
      }

      final user = await _authRepository.fetchCurrentUser();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _friendlyError(e),
          user: null,
        ),
      );
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.login(email: event.email, password: event.password);
      final user = await _authRepository.fetchCurrentUser();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _friendlyError(e),
          user: null,
        ),
      );
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordRepeat: event.passwordRepeat,
        role: 'user',
      );
      await _authRepository.login(email: event.email, password: event.password);
      final user = await _authRepository.fetchCurrentUser();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _friendlyError(e),
          user: null,
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.logout();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _friendlyError(e),
          user: null,
        ),
      );
    }
  }

  Future<void> _onRefreshUserRequested(
    AuthRefreshUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _authRepository.fetchCurrentUser();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _friendlyError(e),
          user: null,
        ),
      );
    }
  }

  Future<void> _onUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.updateProfile(
        name: event.name,
        email: event.email,
        profilePictureUrl: event.profilePictureUrl,
        phoneNumber: event.phoneNumber,
      );
      final user = await _authRepository.fetchCurrentUser();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _friendlyError(e),
        ),
      );
    }
  }

  String _friendlyError(Object e) {
    if (e is DioException) {
      // Try to extract API message from response body
      final data = e.response?.data;
      String? apiMessage;

      if (data is Map<String, dynamic>) {
        apiMessage = (data['message'] ?? data['error'])?.toString();
      } else if (data is String && data.isNotEmpty) {
        // Response might be a JSON string not yet parsed
        try {
          final parsed = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(data);
          apiMessage = parsed?.group(1);
        } catch (_) {}
      }

      if (apiMessage != null && apiMessage.isNotEmpty) {
        return apiMessage;
      }

      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 400:
          return 'Invalid request. Please check your input.';
        case 401:
          return 'Invalid email or password.';
        case 403:
          return 'Access denied.';
        case 404:
          return 'Service not found. Please try again later.';
        case 409:
          return 'Account already exists. Please login instead.';
        case 422:
          return 'Invalid data. Please check your input.';
        case 500:
          return 'Server error. Please try again later.';
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return 'Request timed out. Please try again.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network.';
      }

      return 'Something went wrong. Please try again.';
    }

    final raw = e.toString();
    final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Something went wrong.';
  }
}
