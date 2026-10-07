import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImageShareService {
  final Dio _dio = Dio();

  Future<void> shareImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      throw Exception('Image URL is empty');
    }

    final directory = await getTemporaryDirectory();

    final extension = _getExtension(imageUrl);

    final fileName =
        'share_${DateTime.now().millisecondsSinceEpoch}$extension';

    final filePath = path.join(
      directory.path,
      fileName,
    );

    await _dio.download(
      imageUrl,
      filePath,
    );

    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('Failed to download image');
    }

    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out this image!',
        files: [
          XFile(filePath),
        ],
      ),
    );
  }

  String _getExtension(String url) {
    final cleanUrl = url.split('?').first;
    final extension = path.extension(cleanUrl);

    return extension.isEmpty ? '.jpg' : extension;
  }
}