import 'image_file_model.dart';

class ImageFileListModel {
  final List<ImageFileModel> imageFileModelList;
  int? representativeImageIndex;

  ImageFileListModel({
    required this.imageFileModelList,
    this.representativeImageIndex = -1,
  });
}
