import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper/views/splash_screen.dart';

import 'controller/ad_controller.dart';
import 'controller/favaurite.dart';
import 'controller/network_controller.dart';
import 'controller/openAd_controller.dart';


void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    MobileAds.instance.initialize();
    Get.put(AppOpenController());
    Get.put(FavoritesController());
    Get.put(NetworkController());
    Get.put(NetworkController());
    Get.put(AdController());
    return   GetMaterialApp(
      initialRoute: '/SplashScreen',
    routes: {
        '/SplashScreen': (context) => const SplashScreen(),
        
        // Add more routes as needed
      },
    
      
      debugShowCheckedModeBanner: false,
     
   home: const SplashScreen(), );
  }
}