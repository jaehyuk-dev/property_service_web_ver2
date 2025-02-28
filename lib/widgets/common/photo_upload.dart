import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/common/image_file_list_model.dart';
import '../../models/common/image_file_model.dart';

class PhotoUpload extends StatefulWidget {
  final String label;
  final ImageFileListModel imageFileListModel;
  final int maxUploadCount;
  final String? toolTipMessage;

  const PhotoUpload({
    super.key,
    required this.label,
    required this.imageFileListModel,
    required this.maxUploadCount,
    this.toolTipMessage,
  });

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {

  Future<void> _pickImages() async {
    if (widget.imageFileListModel.imageFileModelList.length >= widget.maxUploadCount) {
      DialogUtils.showAlertDialog(context: context, title: "업로드 제한", content: "최대 ${widget.maxUploadCount}장의 사진만 업로드 할 수 있습니다.");
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      final selectedFiles = result.files;

      setState(() {
        for (var file in selectedFiles) {
          if (widget.imageFileListModel.imageFileModelList.length >= widget.maxUploadCount) {
            DialogUtils.showAlertDialog(context: context, title: "업로드 제한", content: "최대 ${widget.maxUploadCount}장의 사진만 업로드 할 수 있습니다.");
            break;
          }
          widget.imageFileListModel.imageFileModelList.add(
              ImageFileModel(imageBytes: file.bytes!, imageName: file.name, imageSize: file.size)
          );
        }
        if (widget.imageFileListModel.imageFileModelList.isNotEmpty &&
            widget.imageFileListModel.representativeImageIndex == -1) {
          widget.imageFileListModel.representativeImageIndex = 0;
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      widget.imageFileListModel.imageFileModelList.removeAt(index);

      if (widget.imageFileListModel.imageFileModelList.isEmpty) {
        widget.imageFileListModel.representativeImageIndex = -1;
      } else {
        widget.imageFileListModel.representativeImageIndex = 0;
      }
    });
  }

  void _setRepresentativeImage(int index) {
    setState(() {
      widget.imageFileListModel.representativeImageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if(widget.toolTipMessage != null)
                      Tooltip(
                        message: widget.toolTipMessage,
                        child: Icon(
                          Icons.info_outline, // 툴팁 아이콘
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                  ],
                ),
                _PhotoAddButton(onPressed: _pickImages),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 이미지 미리보기 영역
        Container(
          height: 208,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: widget.imageFileListModel.imageFileModelList.isEmpty
              ? const Center(
            child: Text(
              "사진을 업로드하세요.",
              style: TextStyle(color: Colors.grey),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageFileListModel.imageFileModelList.length,
            itemBuilder: (context, index) {
              final ImageFileModel image = widget.imageFileListModel.imageFileModelList[index];
              final fileName = image.imageName;
              final fileSize = (image.imageSize / (1024 * 1024)).toStringAsFixed(2); // MB로 변환
              final isRepresentative = widget.imageFileListModel.representativeImageIndex == index;

              return GestureDetector(
                onTap: () => _setRepresentativeImage(index),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              image.imageBytes,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (isRepresentative)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.color4,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "대표 이미지",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            Text(
                              fileName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              "$fileSize MB",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PhotoAddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _PhotoAddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 40, // 정사각형 버튼 크기
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 72,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade800,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "업로드",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
