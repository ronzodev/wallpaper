import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper/views/image_view.dart';
import '../controller/category_controller.dart';
import '../model/model.dart';
import '../widget/widget.dart';

class Catergory extends StatefulWidget {
  final String catergoryName;
  const Catergory({Key? key, required this.catergoryName}) : super(key: key);

  @override
  _CatergoryState createState() => _CatergoryState();
}

class _CatergoryState extends State<Catergory> {
  late CategoryController categoryController;
  final ScrollController scrollController = ScrollController();
  bool newImagesFetched = false;
  bool showMoreButton = false;

  @override
  void initState() {
    super.initState();
    categoryController = Get.put(CategoryController(widget.catergoryName));
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.atEdge) {
      bool isBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
      if (isBottom) {
        setState(() {
          showMoreButton = true;
        });
      }
    } else {
      if (showMoreButton) {
        setState(() {
          showMoreButton = false;
        });
      }
      if (newImagesFetched) {
        setState(() {
          newImagesFetched = false;
        });
      }
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    ).then((_) {
      setState(() {
        newImagesFetched = false;
      });
    });
  }

  //liqiud refresh
    Future<void> handleRefresh() async {
  await Future.delayed(Duration(seconds: 2));
  // Call your controller's getWallpapers function here
  categoryController.getCategoryWallpapers(); // Assuming controller is an instance of your controller class
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: title(),
        centerTitle: true,
      ),
      body: LiquidPullToRefresh(
        color: Colors.grey,
        backgroundColor: Colors.orange,
        onRefresh: handleRefresh,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        child: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    wallpaperList(categoryController.wallpapers),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (newImagesFetched)
               Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) ),
                      backgroundColor: Colors.orange,
                      onPressed: scrollToBottom,
                      child: Lottie.asset('images/down.json', height: 60,width: 50),
                    ),
               )),
              if (showMoreButton)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.orange,
                    onPressed: () async {
                      await categoryController.getCategoryWallpapers();
                      setState(() {
                        newImagesFetched = true;
                      });
                    },
                
                    child: Lottie.asset('images/mo.json',height: 100,width: 100 ),
                  ),
                ),
              if (categoryController.isLoading.value)
                const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingIndicator(
                       indicatorType: Indicator.orbit, colors: [ Colors.orange],
                       strokeWidth: 4, 
                    ),
                  )
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget wallpaperList(List<WallpaperModel> wallpapers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        children: wallpapers.map((wallpaper) {
          return GridTile(
            child: GestureDetector(
              onTap: () {
                Get.to(() => ImageView(url: wallpaper.srcModel.portrait, wallpaper: wallpaper));
              },
              child: Hero(
                tag: wallpaper.srcModel,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: wallpaper.srcModel.portrait,
                    placeholder: (context, url) => const Center(child: SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingIndicator(indicatorType: Indicator.ballTrianglePath, colors: [ Colors.orange]))),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
