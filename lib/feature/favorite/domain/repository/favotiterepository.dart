abstract class FavoritesRepository {
  Stream<Set<String>> getFavoritesStream();
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
}