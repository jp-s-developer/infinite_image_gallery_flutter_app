import 'package:hive/hive.dart';

import '../../model/gallery_base_model.dart';

class FavouriteLocalStorage {
  static const String boxName = 'favouriteHitsBox';

  Future<Box> get _box async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    return Hive.openBox(boxName);
  }


  Future<void> addFavourite(Hits hit) async {
    if (hit.id == null) {
      throw Exception('Hit ID is required');
    }

    final box = await _box;

    await box.put(
      hit.id,
      hit.toJson(),
    );
  }


  Future<void> removeFavourite(int hitId) async {
    final box = await _box;

    await box.delete(hitId);
  }


  Future<bool> isFavourite(int hitId) async {
    final box = await _box;

    return box.containsKey(hitId);
  }


  Future<List<Hits>> getFavourites() async {
    final box = await _box;

    return box.values
        .map(
          (value) => Hits.fromJson(
        Map<String, dynamic>.from(value),
      ),
    )
        .toList();
  }


  Future<void> clearFavourites() async {
    final box = await _box;

    await box.clear();
  }
}