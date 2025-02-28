class FileUploadModel{
  final List<String> fileNames;
  final List<String> fileUrls;

  FileUploadModel({required this.fileNames, required this.fileUrls});

  // JSON을 객체로 변환하는 factory 메서드
  factory FileUploadModel.fromJson(Map<String, dynamic> json) {
    return FileUploadModel(
      fileNames: List<String>.from(json['fileNames'] ?? []),
      fileUrls: List<String>.from(json['fileUrls'] ?? []),
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      "fileNames": fileNames,
      "fileUrls": fileUrls,
    };
  }
}