import 'package:get/get.dart';
import 'package:wallpaper/model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/data.dart';

class CategoryController extends GetxController {
  var wallpapers = <WallpaperModel>[].obs;
  var isLoading = false.obs;
  var page = 1;

  final String categoryName;

  CategoryController(this.categoryName);

  @override
  void onInit() {
    super.onInit();
    getCategoryWallpapers();
  }

  Future<void> getCategoryWallpapers() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final url = Uri.parse("https://api.pexels.com/v1/search?query=$categoryName&per_page=16&page=$page");
      var response = await http.get(url, headers: {"Authorization": apiKey});

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<WallpaperModel> newWallpapers = [];
        jsonData['photos'].forEach((element) {
          WallpaperModel wallpaperModel = WallpaperModel.fromMap(element);
          newWallpapers.add(wallpaperModel);
        });

        wallpapers.addAll(newWallpapers);
        page++;
      } else {
        Get.snackbar('Error', 'Failed to load wallpapers. Please check your internet connection.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallpapers. Please check your internet connection.');
    } finally {
      isLoading.value = false;
    }
  }
}
