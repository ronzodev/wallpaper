import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/model.dart';
import 'network_controller.dart'; // Import the NetworkController

class WallpaperController extends GetxController {
  var wallpapers = <WallpaperModel>[].obs;
  var isLoading = false.obs;
  var page = 1;
  final NetworkController networkController = Get.find(); // Get instance of NetworkController

  @override
  void onInit() {
    super.onInit();
    getWallpapers();

    // Listen for network changes
    ever(networkController.isConnected, (isConnected) {
      if (isConnected) {
        getWallpapers(); // Fetch wallpapers when network is available
      } else {
        Get.snackbar('Error', 'something went wrong  try to check your network settings..');
      }
    });
  }

  Future<void> getWallpapers() async {
    if (!networkController.isConnected.value) {
      networkController.showNoNetworkDialogForApp();
      return;
    }

    try {
      isLoading(true);

      final url = Uri.parse("https://api.pexels.com/v1/curated?per_page=16&page=$page");
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
      }
    } catch (e) {
      // Handle exception if necessary
    } finally {
      isLoading(false);
    }
  }
}
