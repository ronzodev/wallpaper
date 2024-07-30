import 'package:flutter/material.dart';
import 'package:wallpaper/model/model.dart'; // Update the import to match your project structure
import '../views/image_view.dart'; // Update the import to match your project structure

Widget title() {
  return const Row(
    
    children: [
      Text(
        'Explore',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
     
    ],
  );
}

Widget wallpaperList(List<WallpaperModel> wallpapers, context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      physics: const ClampingScrollPhysics(),
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(url: wallpaper.srcModel.portrait, wallpaper: wallpaper,),
                ),
              );
            },
            child: Hero(
              tag: wallpaper.srcModel.portrait,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.network(
                  wallpaper.srcModel.portrait,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

class ImageListScreen extends StatelessWidget {
  final List<WallpaperModel> wallpapers;

  const ImageListScreen({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
        centerTitle: true,
      ),
      body: wallpaperList(wallpapers, context),
    );
  }
}
