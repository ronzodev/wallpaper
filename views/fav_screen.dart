import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/favaurite.dart';
import '../views/image_view.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (favoritesController.favoriteWallpapers.isEmpty) {
          return const Center(
            child: Text('No favorite wallpapers.'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: favoritesController.favoriteWallpapers.length,
          itemBuilder: (context, index) {
            var wallpaper = favoritesController.favoriteWallpapers[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(ImageView(wallpaper: wallpaper, url: wallpaper.srcModel.portrait,));
                  },
                  child: Hero(
                    tag: wallpaper.srcModel.portrait,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                        child: CachedNetworkImage(
                          imageUrl: wallpaper.srcModel.portrait,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'remove') {
                        favoritesController.removeFavorite(wallpaper);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove from favorites'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
