import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/model/model.dart';
import '../data/data.dart';
import '../views/splash_screen.dart';

class NetworkController extends GetxController {
  var isConnected = true.obs;
  var wallpapers = <WallpaperModel>[].obs;
  var isLoading = false.obs;
  var page = 1;
  

  Timer? _networkCheckTimer;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      isConnected.value = results.any((result) => result != ConnectivityResult.none);
      if (!isConnected.value) {
         if (Get.currentRoute == '/SplashScreen') {
          showNoNetworkDialogForSplash();
        } else if (Get.currentRoute != '/SplashScreen'){
          showNoNetworkDialogForApp();
        } // Call splash-specific dialog on initial check
       } else {
        _networkCheckTimer?.cancel(); // Cancel timer if network is back
        Get.back(); // Close any open dialog

        if(Get.currentRoute == '/SplashScreen'){
          Get.offAll( const SplashScreen());
        } else{
          getWallpapers();
        }
         
         
      } 
    });
  }

  Future<void> getWallpapers() async {
    if (!isConnected.value) {
      return; // No need to call network if not connected
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
      print("Error fetching wallpapers: $e"); // Log the error
      // Show a generic error message to the user if needed
    } finally {
      isLoading(false);
    }
  }

  void showNoNetworkDialogForSplash() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Network Issue',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('images/network.svg', height: 100, width: 100),
          const SizedBox(height: 16),
         const  Text('No network connection. Please check your internet settings.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Exit the app (for splash screen)
              if (GetPlatform.isAndroid) {
                SystemNavigator.pop();
              } else if (GetPlatform.isIOS) {
                exit(0);
              } else if(GetPlatform.isWeb){
                SystemNavigator.pop();
              }
            },
            child: const Text('okey'),
          ),
        ],
      ),
    );
  }

  void showNoNetworkDialogForApp() async {
    var result = await Get.defaultDialog(
      barrierDismissible: false,
      title: 'Network Issue',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('images/network.svg', height: 100, width: 100),
         const SizedBox(height: 16),
          const Text('No network connection. Please check your internet settings.'),
         const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _startNetworkCheckTimer();
              
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _startNetworkCheckTimer() {
    _networkCheckTimer?.cancel(); // Cancel any existing timer
    _networkCheckTimer = Timer(const Duration(seconds: 5), () {
      checkNetworkStatus();
    });
  }


  void checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isConnected.value = true;
      _networkCheckTimer?.cancel(); // Cancel timer if network is back
      // Retry any network operation here (e.g., call getWallpapers())
    } else {
      _startNetworkCheckTimer(); // Restart timer if network is still down
    }
  }
}
