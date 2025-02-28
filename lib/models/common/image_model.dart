class ImageModel{
  final int imageId;
  final bool main;
  final String imageUrl;


  ImageModel({
    required this.imageId,
    required this.main,
    required this.imageUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json['imageId'],
      main: json['main'],
      imageUrl: json['imageUrl'],
    );
  }
}