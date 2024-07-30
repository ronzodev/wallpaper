import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageViewController extends GetxController {
  var isDownloading = false.obs;

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> downloadImage(String url) async {
    await requestPermission();

    isDownloading(true);

    try {
      var response = await http.get(Uri.parse(url));
      Uint8List bytes = response.bodyBytes;

      final result = await ImageGallerySaver.saveImage(bytes, quality: 60, name: "downloaded_image");

      isDownloading(false);

      if (result['isSuccess']) {
        Fluttertoast.showToast(msg: 'Image downloaded successfully!');
      } else {
        Fluttertoast.showToast(msg: 'Failed to download image.');
      }
    } catch (error) {
      isDownloading(false);
      Fluttertoast.showToast(msg: 'Failed to download image: $error');
    }
  }
}
