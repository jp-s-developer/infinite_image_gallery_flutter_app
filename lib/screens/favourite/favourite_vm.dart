import 'package:flutter/foundation.dart';
import 'package:infinite_image_gallery_app/base/base_vm.dart';

import '../../model/gallery_base_model.dart';
import 'favourite_repository.dart';

import 'package:infinite_image_gallery_app/core/app_snack.dart';

class FavouriteViewModel extends BaseVm {
  FavouriteViewModel._();

  static final FavouriteViewModel _instance = FavouriteViewModel._();


  factory FavouriteViewModel() {
    return _instance;
  }


  final FavouriteRepository repository = FavouriteRepository();
  final Set<int> _favouriteIds = {};
  Set<int> get favouriteIds => _favouriteIds;
  List<Hits> favouriteList = [];

  bool isFavourite(int id) {
    return _favouriteIds.contains(id);
  }

  Future<void> loadFavourites() async {
    try {
      favouriteList = await repository.getFavourites();

      _favouriteIds
        ..clear()
        ..addAll(
          favouriteList.where((hit) => hit.id != null).map((hit) => hit.id!),
        );

      notifyListeners();
    } catch (e) {
      debugPrint('Load favourites error: $e');
    }
  }

  Future<void> toggleFavourite(Hits hit) async {
    if (hit.id == null) return;

    final id = hit.id!;

    try {
      if (_favouriteIds.contains(id)) {
        await repository.removeFavourite(id);
        _favouriteIds.remove(id);
        AppSnackBar.success('Removed from favourites');
      } else {
        await repository.addFavourite(hit);
        _favouriteIds.add(id);
        AppSnackBar.success('Added to favourites');
      }

      favouriteList = await repository.getFavourites();

      notifyListeners();
    } catch (e) {
      debugPrint('Favourite error: $e');
    }
  }

  Future<void> removeFavourite(int id) async {
    try {
      await repository.removeFavourite(id);

      _favouriteIds.remove(id);
      AppSnackBar.success('Removed from favourites');
      favouriteList = await repository.getFavourites();

      notifyListeners();
    } catch (e) {
      debugPrint('Remove favourite error: $e');
    }
  }
}
