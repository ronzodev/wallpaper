import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper/controller/link_controller.dart';

class MenuButton extends StatelessWidget {
  
  LinkController linkController = Get.put(LinkController());

 

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case 'Share':
            linkController.shareApp();
            break;
          case 'Privacy Policy':
            linkController.privacyPolicy();
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return {'Share', 'Privacy Policy'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
