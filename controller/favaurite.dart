import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model.dart';

class FavoritesController extends GetxController {
  var favoriteWallpapers = <WallpaperModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void addFavorite(WallpaperModel wallpaper) async {
    favoriteWallpapers.add(wallpaper);
    await saveFavorites();
  }

  void removeFavorite(WallpaperModel wallpaper) async {
    favoriteWallpapers.remove(wallpaper);
    await saveFavorites();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedWallpapers = favoriteWallpapers.map((wallpaper) => jsonEncode(wallpaper.toJson())).toList();
    await prefs.setStringList('favorites', encodedWallpapers);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encodedWallpapers = prefs.getStringList('favorites');
    if (encodedWallpapers != null) {
      favoriteWallpapers.value = encodedWallpapers.map((encodedWallpaper) => WallpaperModel.fromJson(jsonDecode(encodedWallpaper))).toList();
    }
  }
}
