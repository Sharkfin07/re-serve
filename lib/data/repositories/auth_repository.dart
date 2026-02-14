import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

// TODO: Repository specific features?
class AuthRepository {
  AuthRepository({AuthService? authService, ApiClient? apiClient})
    : _authService = authService ?? AuthService(),
      _apiClient = apiClient ?? ApiClient.instance();

  final AuthService _authService;
  final ApiClient _apiClient;

  Future<String> login({required String email, required String password}) {
    return _authService.login(email: email, password: password);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordRepeat,
    required String role,
    String? profilePictureUrl,
    String? phoneNumber,
  }) {
    return _authService.register(
      name: name,
      email: email,
      password: password,
      passwordRepeat: passwordRepeat,
      role: role,
      profilePictureUrl: profilePictureUrl,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> logout() => _authService.logout();

  Future<bool> isLoggedIn() => _authService.isLoggedIn();

  Future<String?> getToken() => _authService.getToken();

  Future<UserModel> fetchCurrentUser() async {
    final options = await _authService.authorizedHeaders();
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/api/v1/user',
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception("User data not found");
    }
    return UserModel.fromJson(data);
  }
}
