import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../controller/ad_controller.dart';
import '../controller/favaurite.dart';

import '../model/model.dart';

class ImageView extends StatefulWidget {
  final WallpaperModel wallpaper;

  const ImageView({Key? key, required this.wallpaper, required String url})
      : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isDownloading = false;
  bool _isDisposed = false;
  final FavoritesController favoritesController = Get.find();

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> downloadImage() async {
    await requestPermission();

    if (_isDisposed) return;

    setState(() {
      isDownloading = true;
    });

    try {
      var response =
          await http.get(Uri.parse(widget.wallpaper.srcModel.portrait));
      Uint8List bytes = response.bodyBytes;

      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 60, name: "downloaded_image");

      if (_isDisposed) return;

      setState(() {
        isDownloading = false;
      });

      if (result['isSuccess']) {
        Fluttertoast.showToast(msg: 'Image downloaded successfully!');
      } else {
        Fluttertoast.showToast(msg: 'Failed to download image.');
      }
    } catch (error) {
      if (_isDisposed) return;

      setState(() {
        isDownloading = false;
      });
      Fluttertoast.showToast(msg: 'Something went wrong please check your internet settings');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite =
        favoritesController.favoriteWallpapers.contains(widget.wallpaper);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.wallpaper.srcModel.portrait,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SvgPicture.asset('images/image.svg');
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.3),
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isDownloading)
                    const SizedBox(
                        height: 50,
                        width: 50,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,
                        ))
                  else
                    // IconButton(
                    //   onPressed: downloadImage,
                    //   icon:  const Icon(IconsaxPlusBold.arrow_down_1, size: 35) ,color: Colors.white ,
                    // ),
                    GestureDetector(
                        onTap: () {
                          downloadImage();
                        },
                        child: Lottie.asset('images/download.json',
                            height: 64, width: 64)),
                  const SizedBox(width: 200),
                  AnimatedFavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: () {
                      if (isFavorite) {
                        favoritesController.removeFavorite(widget.wallpaper);
                      } else {
                        favoritesController.addFavorite(widget.wallpaper);
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final ad = Get.find<AdController>();
                        ad.showInterstitialAd();
                      },
                      child:
                          Lottie.asset('images/x.json', width: 35, height: 35)),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}

// anorther class

class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const AnimatedFavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    _colorAnimation = ColorTween(
            begin: widget.isFavorite ? Colors.white : Colors.red,
            end: widget.isFavorite ? Colors.red : Colors.white)
        .animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: IconButton(
          icon: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 35,
            color: _colorAnimation.value,
          ),
          onPressed: () {
            widget.onPressed();
            _controller.forward();
          },
        ),
      ),
    );
  }
}
