import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controller/navigation_contrllor.dart';

import '../controller/ad_controller.dart'; // Make sure to import the AdController
import 'fav_screen.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());
  final AdController adController = Get.put(AdController());

  final List<Widget> pages = [
    Home(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: navigationController.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 235, 229, 229),
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.black,
              elevation: 0,
              currentIndex: navigationController.selectedIndex.value,
              onTap: navigationController.changeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Lottie.asset('images/home.json', height: 35, width: 35),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Lottie.asset('images/favourite.json', height: 35, width: 35),
                  label: 'Favorites',
                ),
              ],
            ),
          ),
        ),
        bottomSheet: adController.buildBannerAd(), // Add this line to include the banner ad at the bottom
      );
    });
  }
}
