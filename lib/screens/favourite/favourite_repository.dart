import '../../core/database/favourite_local_storage.dart';
import '../../model/gallery_base_model.dart';

class FavouriteRepository {
  final FavouriteLocalStorage localStorage= FavouriteLocalStorage();

  Future<void> addFavourite(Hits hit) {
    return localStorage.addFavourite(hit);
  }

  Future<void> removeFavourite(int hitId) {
    return localStorage.removeFavourite(hitId);
  }

  Future<bool> isFavourite(int hitId) {
    return localStorage.isFavourite(hitId);
  }

  Future<List<Hits>> getFavourites() {
    return localStorage.getFavourites();
  }

  Future<void> clearFavourites() {
    return localStorage.clearFavourites();
  }
}