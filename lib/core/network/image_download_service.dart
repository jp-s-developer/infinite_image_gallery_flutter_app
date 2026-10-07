import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageDownloadService {
  final Dio _dio = Dio();

  Future<void> downloadAndSave({
    required String imageUrl,
    required void Function(double progress) onProgress,
  }) async {
    try {
      if (imageUrl.isEmpty) {
        throw Exception('Image URL is empty');
      }

      // Request gallery permission
      final hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        await Gal.requestAccess();
      }

      final directory = await getTemporaryDirectory();

      final extension = _getExtension(imageUrl);

      final fileName =
          'image_${DateTime.now().millisecondsSinceEpoch}$extension';

      final filePath = path.join(
        directory.path,
        fileName,
      );

      await _dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            return;
          }

          final progress = received / total;

          onProgress(progress);
        },
      );

      // Save to device gallery
      await Gal.putImage(filePath);
    } on DioException catch (e) {
      throw Exception(
        e.message ?? 'Failed to download image',
      );
    } catch (e) {
      rethrow;
    }
  }

  String _getExtension(String url) {
    final cleanUrl = url.split('?').first;
    final extension = path.extension(cleanUrl);

    if (extension.isEmpty) {
      return '.jpg';
    }

    return extension;
  }
}