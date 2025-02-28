import 'dart:typed_data';

class ImageFileModel {
  final Uint8List imageBytes;
  final String imageName;
  final int imageSize;
  final String? filePath; // 🔹 파일 경로 추가

  ImageFileModel({
    required this.imageBytes,
    required this.imageName,
    required this.imageSize,
    this.filePath, // 선택적으로 설정 가능
  });
}
