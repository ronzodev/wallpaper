class WallpaperModel {
  String photographer;
  String photographerUrl;
  int photographerId;
  SrcModel srcModel;

  WallpaperModel({
    required this.photographer,
    required this.photographerId,
    required this.photographerUrl,
    required this.srcModel,
  });

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      photographer: jsonData['photographer'],
      photographerId: jsonData['photographer_id'],
      photographerUrl: jsonData['photographer_url'],
      srcModel: SrcModel.fromMap(jsonData['src']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photographer': photographer,
      'photographer_id': photographerId,
      'photographer_url': photographerUrl,
      'src': srcModel.toJson(),
    };
  }

  factory WallpaperModel.fromJson(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      photographer: jsonData['photographer'],
      photographerId: jsonData['photographer_id'],
      photographerUrl: jsonData['photographer_url'],
      srcModel: SrcModel.fromJson(jsonData['src']),
    );
  }
}

class SrcModel {
  String origanal;
  String small;
  String portrait;

  SrcModel({
    required this.origanal,
    required this.portrait,
    required this.small,
  });

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      origanal: jsonData['original'],
      portrait: jsonData['portrait'],
      small: jsonData['small'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': origanal,
      'portrait': portrait,
      'small': small,
    };
  }

  factory SrcModel.fromJson(Map<String, dynamic> jsonData) {
    return SrcModel(
      origanal: jsonData['original'],
      portrait: jsonData['portrait'],
      small: jsonData['small'],
    );
  }
}
