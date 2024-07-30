
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper/helpers/help.dart';
import 'package:wallpaper/views/main_screen.dart';
import '../controller/network_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NetworkController networkController = Get.put(NetworkController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNetworkAndProceed();
    });
  }

  void _checkNetworkAndProceed() async {
    await Future.delayed(const Duration(seconds: 4)); // Short delay to allow network check
    if (!networkController.isConnected.value) {

     
    } else {

       navigateToHome();
    }
  }



  //deciding which screen to take
void navigateToHome() async {
  await Future.delayed(const Duration(seconds: 4)); // Maintain the delay if needed
  Get.off(MainScreen());
}

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const Spacer(flex: 2),
              Lottie.asset(
                'images/sp.json',
                height: mq.height * .35,
                width: mq.height * .35,
              ),
             const Text(
                'In a moment...',
                style: TextStyle(fontSize: 18, color: Colors.black), // Added some style
              ),
             const Spacer(),
            
            ],
          ),
        ),
      ),
    );
  }
}
