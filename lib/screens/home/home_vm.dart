import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_image_gallery_app/base/base_vm.dart';
import 'package:infinite_image_gallery_app/core/network/api_helper.dart';
import 'package:infinite_image_gallery_app/core/router/app_router.dart';
import 'package:infinite_image_gallery_app/screens/favourite/favourite_vm.dart';

import '../../core/app_snack.dart';
import '../../core/network/api_exception.dart';
import '../../model/gallery_base_model.dart';
import '../details/details_screen.dart';

class HomeVm extends BaseVm {
  int currentPage = 0;
  String _pixaBayKey = '57909108-ad5249082c406bfda9d0acc8b';
  List<Hits> imageList = [];
  bool isPaginationLoading = false;
 FavouriteViewModel favouriteViewModel = FavouriteViewModel();

  Future<void> onInitHome({String? search}) async {
    imageList.clear();
    currentPage = 0;
    await fetchImages(search: search);
  }

  Future<void> fetchImages({String? search}) async {
    try {
      isPaginationLoading = true;
      notifyListeners();
      currentPage++;
      final data = await ApiHelper.get(
        '',
        queryParameters: {
          'key': _pixaBayKey,
          'image_type': 'photo',
          'orientation': 'vertical',
          'page': currentPage,
          'per_page': 20,
          if(search?.isNotEmpty == true)
            'q': search
        },
      );
      if (data != null && data is Map<String, dynamic>) {
        final galleryBaseModel = GalleryBaseModel.fromJson(data);
        imageList.addAll(galleryBaseModel.hits ?? []);
        debugPrint('data: $data');
        imageList.forEach((element) {
         element.isFavourite = favouriteViewModel.isFavourite(element.id!);
        });
      }
    } on ApiException catch (e) {
      AppSnackBar.error(
        e.message.isNotEmpty
            ? e.message
            : 'Something went wrong',
      );

      debugPrint('ApiException: ${e.message}');
    } catch (e, stackTrace) {
      AppSnackBar.error(
        'Something went wrong',
      );

      debugPrint('Unexpected error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isPaginationLoading = false;
      notifyListeners();
    }
  }



  void moveToImageDetails(BuildContext context,
      Hits hit,) {
    context.pushNamed(AppRoutes.imageDetails,extra: hit);
  }
}
