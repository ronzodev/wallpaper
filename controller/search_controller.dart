import 'package:get/get.dart';
import '../data/data.dart';
import '../model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class SearchControll extends GetxController {
  var isLoading = false.obs;
  var wallpapers = <WallpaperModel>[].obs;
  int page = 1;

  Future<void> getSearchWallpapers(String query) async {
    try {
      isLoading(true);
      final url = Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=16&page=$page");
      var response = await http.get(url, headers: {"Authorization": apiKey});

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        List<WallpaperModel> newWallpapers = [];
        jsonData['photos'].forEach((element) {
          WallpaperModel wallpaperModel = WallpaperModel.fromMap(element);
          newWallpapers.add(wallpaperModel);
        });

        if (newWallpapers.isEmpty) {
          print('No wallpapers found'); // Debug print
          _showNoResultsDialog();
        } else {
          wallpapers.addAll(newWallpapers);
        }
      } else {
        Get.snackbar('Error', 'Failed to load wallpapers. Please check your internet connection.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallpapers. Please check your internet connection.');
    } finally {
      isLoading(false);
    }
  }

  void loadMoreWallpapers(String query) {
    page++;
    getSearchWallpapers(query);
  }

  void _showNoResultsDialog() {
    Get.defaultDialog(
      title: 'No Results',
      middleText: 'No wallpapers found for your search query. Please try a different keyword.',
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text('OK'),
      ),
    );
  }
}
