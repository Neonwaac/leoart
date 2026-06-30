import 'dart:convert';
import 'dart:io';
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
    try {
      final bytes = await File(filePath).readAsBytes();
      final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

      final params = <String, dynamic>{
        'timestamp': timestamp,
        if (folder != null) 'folder': folder,
      };
      if (publicId != null) params['public_id'] = publicId;
      if (extraParams != null) params.addAll(extraParams);

      final signature = _generateSignature(params);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/image/upload'),
      );

      request.fields['api_key'] = config.apiKey;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature;
      request.fields['folder'] = folder ?? '';
      request.fields['blur_hash'] = 'true';
      if (publicId != null) request.fields['public_id'] = publicId;

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'upload.jpg',
      ));

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        throw CloudinaryException(
          message: (body as Map?)?['error']?['message'] ?? 'Upload failed',
          code: response.statusCode.toString(),
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } on CloudinaryException {
      rethrow;
    } catch (e) {
      throw CloudinaryException(
        message: 'Upload failed: $e',
        code: 'UPLOAD_ERROR',
      );
    }
  }

  Future<Map<String, dynamic>> uploadBytes({
    required List<int> bytes,
    String? publicId,
    String? folder,
    Map<String, dynamic>? extraParams,
  }) async {
    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

      final params = <String, dynamic>{
        'timestamp': timestamp,
        if (folder != null) 'folder': folder,
      };
      if (publicId != null) params['public_id'] = publicId;
      if (extraParams != null) params.addAll(extraParams);

      final signature = _generateSignature(params);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/image/upload'),
      );

      request.fields['api_key'] = config.apiKey;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature;
      request.fields['folder'] = folder ?? '';
      request.fields['blur_hash'] = 'true';
      if (publicId != null) request.fields['public_id'] = publicId;

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'upload.jpg',
      ));

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        throw CloudinaryException(
          message: (body as Map?)?['error']?['message'] ?? 'Upload failed',
          code: response.statusCode.toString(),
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } on CloudinaryException {
      rethrow;
    } catch (e) {
      throw CloudinaryException(
        message: 'Upload failed: $e',
        code: 'UPLOAD_ERROR',
      );
    }
  }

  Future<void> delete({required String publicId}) async {
    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
      final params = <String, dynamic>{
        'public_id': publicId,
        'timestamp': timestamp,
      };
      final signature = _generateSignature(params);

      final response = await _client.post(
        Uri.parse('$baseUrl/image/destroy'),
        body: {
          'api_key': config.apiKey,
          'timestamp': timestamp,
          'signature': signature,
          'public_id': publicId,
        },
      );

      if (response.statusCode != 200) {
        final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        throw CloudinaryException(
          message: (body as Map?)?['error']?['message'] ?? 'Delete failed',
          code: response.statusCode.toString(),
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['result'] != 'ok') {
        throw CloudinaryException(
          message: 'Delete failed: ${data['result']}',
          code: 'DELETE_FAILED',
        );
      }
    } on CloudinaryException {
      rethrow;
    } catch (e) {
      throw CloudinaryException(
        message: 'Delete failed: $e',
        code: 'DELETE_ERROR',
      );
    }
  }

  String? getPublicIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 1 >= segments.length) return null;
      final publicIdWithExt = segments.last;
      final folderParts = segments.sublist(uploadIndex + 1, segments.length - 1)
          .where((s) => !s.startsWith('v') || int.tryParse(s.substring(1)) == null);
      final folder = folderParts.isNotEmpty ? '${folderParts.join('/')}/' : '';
      final dotIndex = publicIdWithExt.lastIndexOf('.');
      final publicId = dotIndex > 0 ? publicIdWithExt.substring(0, dotIndex) : publicIdWithExt;
      return '$folder$publicId';
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
