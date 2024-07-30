import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper/data/onboard.dart';
import 'package:wallpaper/helpers/help.dart';
import 'package:wallpaper/views/home.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {

  final PageController controller = PageController();
  final Lis = [
    Onboard(
        title: 'Welcome',
        subtitle:
            'vgvv fjhbukcf cjhgvfcfc v vytd gtdccfcctfcvcfctexdnv  xdxdxs vcrexghdgxdh fxxgs xsxxr',
        lottie: 's1'),
        Onboard(
        title: 'Awesome',
        subtitle:
            'vgvv fjhbukcf cjhgvfcfc v vytd gtdccfcctfcvcfctexdnv  xdxdxs vcrexghdgxdh fxxgs xsxxr',
        lottie: 's2')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(controller: controller,

      
         itemCount: Lis.length,
         itemBuilder: (context , index){
          
          final isLast =  index == Lis.length -1 ;

        return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              isLast ? const SizedBox() : Align(
                alignment: Alignment.topRight,
                child: TextButton(onPressed: (){
                  Get.offAll(Home());
                }, child: const Text('skip') ),
              ),
             const SizedBox(height: 50,),
              Lottie.asset(
                'images/${Lis[index].lottie}.json',
                height: mq.height * .3,
              ),
              const Spacer(),
               Text(
                Lis[index].title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5),
              ),
            Text( Lis[index].subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13.4, letterSpacing: .5, color: Colors.black54),
              ),
        
              const Spacer(flex: 2,),
              // dots
        
              Wrap(
                spacing: 10,
                children: List.generate(
                    Lis.length,
                    (i) => Container(
                          height: i==index ? 15 :  10,
                          width: 18,
                          decoration: BoxDecoration(
                              color: i == index ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                        )),
              ),
                const Spacer(flex: 2,),
              // oprational button
        
              ElevatedButton(
                onPressed: () {
                  if(isLast){
                 Get.offAll(Home());
                  } else{
                    controller.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.ease);
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    backgroundColor: Colors.blue),
                child: Text(
               isLast  ? 'Finish' : 
                  'next',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
      })
    );
  }
}
