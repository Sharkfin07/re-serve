import 'dart:io';

import '../services/upload_service.dart';

class UploadRepository {
  UploadRepository({UploadService? service})
    : _service = service ?? UploadService();

  final UploadService _service;

  Future<String> uploadImage(File file) => _service.uploadImage(file);
}
