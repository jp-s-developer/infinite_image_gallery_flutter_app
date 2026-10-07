import 'package:flutter/cupertino.dart';
import 'package:infinite_image_gallery_app/base/base_vm.dart';
import 'package:infinite_image_gallery_app/model/gallery_base_model.dart';

import '../../core/app_snack.dart';
import '../../core/network/image_download_service.dart';
import '../../core/network/image_share_service.dart';
import '../favourite/favourite_vm.dart';

class DetailsVm extends BaseVm {
  final shareService = ImageShareService();
  final downloadService = ImageDownloadService();
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? downloadError;
  FavouriteViewModel favouriteViewModel = FavouriteViewModel();

  void onTapShare(Hits hit, BuildContext context) async {
    try {
      await shareService.shareImage(
        hit.largeImageURL ?? hit.webformatURL ?? '',
      );
    } catch (e) {
      debugPrint('Share error: $e');

      if (!context.mounted) return;

      AppSnackBar.error('Unable to share image');
    }
  }



  Future<void> downloadImage(String imageUrl) async {
    if (isDownloading) {
      return;
    }

    isDownloading = true;
    downloadProgress = 0.0;
    downloadError = null;

    notifyListeners();

    try {
      await downloadService.downloadAndSave(
        imageUrl: imageUrl,
        onProgress: (progress) {
          downloadProgress = progress;
          notifyListeners();
        },
      );
    } catch (e) {
      downloadError = e.toString();
      debugPrint('Download error: $e');
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  String dimensions(Hits hit) {
    if (hit.imageWidth == null || hit.imageHeight == null) {
      return '-';
    }

    return '${hit.imageWidth} × ${hit.imageHeight} px';
  }

  String fileSize(Hits hit) {
    if (hit.imageSize == null) {
      return '-';
    }

    final bytes = hit.imageSize!;

    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String formatNumber(int? value) {
    if (value == null) {
      return '0';
    }

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toString();
  }
}
