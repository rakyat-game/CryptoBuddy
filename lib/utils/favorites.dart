import 'package:coingecko_api/data/market.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static Future<void> addToFavorites(String favorite) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (!favorites.contains(favorite)) {
      favorites.add(favorite);
      await prefs.setStringList('favorites', favorites);
    }
  }

  static Future<bool> isFavorite(Market coin) async {
    List<String> favorites = await FavoritesService.getFavorites();

    try {
      favorites.firstWhere((element) => element == coin.id);
      return true;
    } on Error {
      return false;
    }
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  static Future<void> removeFromFavorites(String coin) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(coin);
    await prefs.setStringList('favorites', favorites);
  }
}
