import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';
import 'auth_service.dart';

// TODO: Mechanism of uploading a image file?
class UploadService {
  UploadService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient.instance(),
      _authService = authService ?? AuthService();

  final ApiClient _client;
  final AuthService _authService;

  /// Upload an image file and return the URL string from the API response.
  Future<String> uploadImage(File file) async {
    final options = await _authService.authorizedHeaders();
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path),
    });

    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/upload-image',
      data: formData,
      options: options,
    );

    final url = response.data?['url'];
    if (url == null || url is! String || url.isEmpty) {
      throw Exception('Upload failed: URL not found');
    }
    return url;
  }
}
