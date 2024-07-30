import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper/data/menu_button.dart';
import 'package:wallpaper/views/image_view.dart';
import 'package:wallpaper/views/search.dart';
import 'package:wallpaper/widget/widget.dart';
import '../controller/controller.dart';
import '../controller/them_controller.dart';
import '../data/data.dart';
import '../model/model.dart';
import 'catergory.dart';
import '../controller/network_controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WallpaperController wallpaperController =
      Get.put(WallpaperController());
  final TextEditingController textEditingControllerSearch =
      TextEditingController();
  final ThemeController themeController = Get.put(ThemeController());
  final NetworkController networkController = Get.put(NetworkController());
  final ScrollController scrollController = ScrollController();
  bool newImagesFetched = false;
  bool showMoreButton = false;


   //liqiud refresh
    Future<void> handleRefresh() async {
  await Future.delayed(Duration(seconds: 2));
  // Call your controller's getWallpapers function here
  wallpaperController.getWallpapers(); // Assuming controller is an instance of your controller class
}


  @override
  void initState() {
    super.initState();
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
      bool isBottom = scrollController.position.pixels ==
          scrollController.position.maxScrollExtent;
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
    scrollController
        .animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .then((_) {
      setState(() {
        newImagesFetched = false;
      });
    });
  }

  // search for
  void _performSearch(BuildContext context) {
    Get.to(Search(searchQuery: textEditingControllerSearch.text));
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
    textEditingControllerSearch.clear(); // Clear the text field

   
  }

  
  @override
  Widget build(BuildContext context) {
    final categories = getCategories();

    

    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true,
        
        title: title(),
        leading: MenuButton(),
        actions: [
          Obx(() {
            return IconButton(
              onPressed: () {
                themeController.toggleTheme();
              },
              icon: Icon(themeController.isDarkMode.value
                  ? Icons.wb_sunny
                  : Icons.nights_stay),
            );
          }),
        ],
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
                primary: false,
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 229, 229),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField( 
                              controller: textEditingControllerSearch,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.black),
                              onSubmitted: (_) {
                                _performSearch(
                                    context); // Perform the search when "OK" is pressed on the keyboard
                              },
                            ),
                          ),
                          InkWell(
                            child: Lottie.asset('images/search.json',
                                height: 35, width: 35),
                            onTap: () {
                              _performSearch(
                                  context); // Perform the search when the Lottie animation is tapped
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            url: categories[index].imgUrl,
                            title: categories[index].CategoriesName,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    wallpaperList(wallpaperController.wallpapers),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.orange,
                      onPressed: scrollToBottom,
                      child:
                          Lottie.asset('images/down.json', height: 60, width: 50),
                    ),
                  ),
                ),
              if (showMoreButton)
                Positioned(
                  bottom: 55,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.orange,
                    onPressed: () async {
                      await wallpaperController.getWallpapers();
                      setState(() {
                        newImagesFetched = true;
                      });
                    },
                    child:
                        Lottie.asset('images/mo.json', height: 100, width: 100),
                  ),
                ),
              if (wallpaperController.isLoading.value)
                const Center(
                    child: SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.orbit,
                    colors: [Colors.orange],
                    strokeWidth: 4,
                  ),
                )),
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
                Get.to(ImageView(
                    url: wallpaper.srcModel.portrait, wallpaper: wallpaper));
              },
              child: Hero(
                tag: wallpaper.srcModel, // Unique tag based on the image URL
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: wallpaper.srcModel.portrait,
                    placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballTrianglePath,
                              colors: [Colors.orange],
                            ))),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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

class CategoryTile extends StatelessWidget {
  final String url, title;
  const CategoryTile({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => Catergory(catergoryName: title.toLowerCase()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4), // Adjusted margin
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: 100,
                height: 50,
              ),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
