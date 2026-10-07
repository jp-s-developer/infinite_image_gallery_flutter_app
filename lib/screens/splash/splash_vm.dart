import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_image_gallery_app/base/base_vm.dart';
import 'package:infinite_image_gallery_app/core/router/app_router.dart';

class SplashVm extends BaseVm {


  Future<void> moveToHomeScreen({required BuildContext context})async {
    await Future.delayed(const Duration(seconds: 3));
    if(context.mounted){
      context.go(AppRoutes.home);
    }
  }
}
