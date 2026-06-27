import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared/core/errors/cloudinary_exception.dart';

class CloudinaryConfig {
  final String cloudName;
  final String apiKey;
  final String apiSecret;

  const CloudinaryConfig({
    required this.cloudName,
    required this.apiKey,
    required this.apiSecret,
  });
}

class CloudinaryService {
  final CloudinaryConfig config;
  final http.Client _client;

  CloudinaryService({required this.config, http.Client? client})
    : _client = client ?? http.Client();

  String get baseUrl => 'https://api.cloudinary.com/v1_1/${config.cloudName}';

  String _generateSignature(Map<String, dynamic> params) {
    final sortedKeys = params.keys.toList()..sort();
    final signatureString = sortedKeys
        .map((key) => '$key=${params[key]}')
        .join('&');
    final fullString = '$signatureString${config.apiSecret}';
    return sha1.convert(utf8.encode(fullString)).toString();
  }

  Future<String> getUploadSignature({
    required String timestamp,
    Map<String, dynamic>? extraParams,
  }) async {
    final params = <String, dynamic>{
      'timestamp': timestamp,
      ...?extraParams,
    };
    return _generateSignature(params);
  }

  String getTransformUrl({
    required String publicId,
    int? width,
    int? height,
    String? crop,
    String? quality,
    String? format,
  }) {
    final transformations = <String>[];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (crop != null) transformations.add('c_$crop');
    if (quality != null) transformations.add('q_$quality');
    if (format != null) transformations.add('f_$format');

    final transformationStr = transformations.isNotEmpty
        ? transformations.join(',')
        : const String.fromEnvironment(
            'default_quality',
            defaultValue: 'q_auto',
          );

    return 'https://res.cloudinary.com/${config.cloudName}/image/upload/$transformationStr/$publicId';
  }

  Future<Map<String, dynamic>> upload({
    required String filePath,
    String? publicId,
    String? folder,
    Map<String, dynamic>? extraParams,
  }) async {
    throw const CloudinaryException(
      message: 'Upload not implemented yet',
      code: 'NOT_IMPLEMENTED',
    );
  }

  Future<void> delete({required String publicId}) async {
    throw const CloudinaryException(
      message: 'Delete not implemented yet',
      code: 'NOT_IMPLEMENTED',
    );
  }

  void dispose() {
    _client.close();
  }
}
