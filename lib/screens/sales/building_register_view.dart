import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_service_web_ver2/core/utils/dialog_utils.dart';
import 'package:property_service_web_ver2/models/property/building_register_model.dart';
import 'package:property_service_web_ver2/service/property_service.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../core/enums/screen_type.dart';
import '../../core/utils/toast_manager.dart';
import '../../models/common/file_upload_model.dart';
import '../../models/common/image_file_list_model.dart';
import '../../widgets/common/custom_address_field.dart';
import '../../widgets/common/custom_radio_group.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/photo_upload.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class BuildingRegister extends StatefulWidget {
  const BuildingRegister({super.key});

  @override
  State<BuildingRegister> createState() => _BuildingRegisterState();
}

class _BuildingRegisterState extends State<BuildingRegister> {
  late LoadingState loadingState;
  final PropertyService propertyService = PropertyService();

  // 컨트롤러 정의
  final TextEditingController buildingName = TextEditingController();

  String? buildingZoneCode;
  String? buildingAddress;
  String? buildingJibunAddress;
  final TextEditingController buildingCompletedYear = TextEditingController();
  String? buildingType;

  final TextEditingController buildingFloorCount = TextEditingController();
  final TextEditingController buildingParkingAreaCount = TextEditingController();
  final TextEditingController buildingElevatorCount = TextEditingController();
  final TextEditingController buildingMainDoorDirection = TextEditingController();
  final TextEditingController buildingCommonPassword = TextEditingController();

  String? buildingHasIllegal;

  final TextEditingController buildingRemark = TextEditingController();

  ImageFileListModel buildingImageList = ImageFileListModel(imageFileModelList: []);

  // 📌 [Clear 기능] 전체 입력 필드 초기화
  void _clearForm() {
    setState(() {
      buildingName.clear();
      buildingCompletedYear.clear();
      buildingFloorCount.clear();
      buildingParkingAreaCount.clear();
      buildingElevatorCount.clear();
      buildingMainDoorDirection.clear();
      buildingCommonPassword.clear();
      buildingRemark.clear();

      buildingZoneCode = null;
      buildingAddress = null;
      buildingJibunAddress = null;
      buildingType = null;
      buildingHasIllegal = null;

      buildingImageList = ImageFileListModel(imageFileModelList: []);
    });
  }

  int _parseToInt(String? value) {
    try {
      return int.parse(value ?? "0");
    } catch (e) {
      print("🚨 숫자로 변환 실패: $e");
      return 0;
    }
  }

  Future<void> _registerBuilding() async {
    loadingState.setLoading(true);
    FileUploadModel? fileUploadResponse;
    List<String> photoUrls = []; // 빈 리스트로 초기화

    // 1. 이미지가 있는 경우만 업로드
    try {
      if (buildingImageList.imageFileModelList.isNotEmpty) {
        fileUploadResponse = await propertyService.uploadBuildingImages(buildingImageList.imageFileModelList);

        if (fileUploadResponse.fileUrls.isNotEmpty) {
          photoUrls = fileUploadResponse.fileUrls;
          print("✅ 업로드된 파일 URL 리스트: ${fileUploadResponse.fileUrls}");
        } else {
          ToastManager().showToast(context, "건물 이미지 업로드 실패");
          return;
        }
      }
      // 이미지가 없는 경우는 그냥 빈 리스트로 진행
    } catch (e) {
      print("🚨 이미지 업로드 실패: $e");
      await DialogUtils.showAlertDialog(
          context: context,
          title: "건물 등록 실패",
          content: "건물 이미지 등록에 실패했습니다."
      );
      return;
    }

    // 2. 필수 필드 체크 (이미지 제외)
    if (buildingZoneCode == null ||
        buildingAddress == null ||
        buildingJibunAddress == null ||
        buildingCompletedYear.text.isEmpty ||
        buildingParkingAreaCount.text.isEmpty ||
        buildingElevatorCount.text.isEmpty) {
      print("🚨 건물 등록 필수 정보 누락!");
      await DialogUtils.showAlertDialog(
          context: context,
          title: "건물 등록 실패",
          content: "필수 정보가 입력되지 않았습니다."
      );
      return;
    }

    // 3. 건물 등록 요청
    try {
      BuildingRegisterModel request = BuildingRegisterModel(
        buildingName: buildingName.text,
        buildingZoneCode: buildingZoneCode!,
        buildingAddress: buildingAddress!,
        buildingJibunAddress: buildingJibunAddress!,
        buildingCompletedYear: _parseToInt(buildingCompletedYear.text),
        buildingTypeCode: buildingType == "주거용" ? 51 : 52,
        buildingFloorCount: buildingFloorCount.text,
        buildingParkingAreaCount: _parseToInt(buildingParkingAreaCount.text),
        buildingElevatorCount: _parseToInt(buildingElevatorCount.text),
        buildingMainDoorDirection: buildingMainDoorDirection.text,
        buildingCommonPassword: buildingCommonPassword.text,
        buildingHasIllegal: buildingHasIllegal == "있음",
        buildingRemark: buildingRemark.text,
        buildingMainPhotoIndex: photoUrls.isNotEmpty ? (buildingImageList.representativeImageIndex ?? 0) : 0,
        photoList: photoUrls, // 빈 리스트이거나 업로드된 URL 리스트
      );

      await propertyService.registerBuilding(request);

      _clearForm();

      ToastManager().showToast(context, "건물이 등록 되었습니다.");
    } catch (e) {
      print("🚨 건물 등록 실패: $e");
      await DialogUtils.showAlertDialog(
          context: context,
          title: "건물 등록 실패",
          content: "건물 정보 등록에 실패했습니다."
      );
    } finally {
      loadingState.setLoading(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      screenType: ScreenType.BuildingRegister,
      buttonText: "등록",
      onTap: _registerBuilding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWidget(
                title: "기본 정보",
                width: 1472,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "건물 주소",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    CustomAddressField(
                      label: "",
                      zipCode: buildingZoneCode,
                      address: buildingAddress,
                      jibunAddress: buildingJibunAddress,
                      onChanged: (newZipCode, newAddress, newJibunAddress) {
                        setState(() {
                          buildingZoneCode = newZipCode;
                          buildingAddress = newAddress;
                          buildingJibunAddress = newJibunAddress;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "건물 명",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    CustomTextField(label: "",controller: buildingName),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  "준공 연도",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              CustomTextField(
                                  label: "",
                                  controller: buildingCompletedYear,
                                  keyboardType: TextInputType.number,
                                suffixText: "년",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // ✅ 숫자만 입력
                                  LengthLimitingTextInputFormatter(4),   // ✅ 4자리 제한
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: CustomRadioGroup(
                            title: "건물 유형",
                            options: ["주거용", "비 주거용",],
                            groupValue: buildingType,
                            onChanged: (value){
                              setState(() {
                                buildingType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWidget(
                title: "시설 정보",
                width: 1472,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  "주 출입문 방향",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: buildingMainDoorDirection),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  "총 층 수",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: buildingFloorCount),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  "주차 대수",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: buildingParkingAreaCount,
                                suffixText: "대",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // ✅ 숫자만 입력
                                ],),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  "엘레베이터 대수",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: buildingElevatorCount,
                                suffixText: "대",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // ✅ 숫자만 입력
                                ],),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  "공동 현관문 비밀번호",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: buildingCommonPassword),
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: CustomRadioGroup(
                            title: "위반 건축물 여부",
                            options: ["있음", "없음"],
                            groupValue: buildingHasIllegal ,
                            onChanged: (value){
                              setState(() {
                                buildingHasIllegal = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWidget(
                title: "특이사항",
                width: 1472,
                child: Column(
                  children: [
                    SizedBox(height: 4),
                    CustomTextField(label: "", controller: buildingRemark, maxLines: 5),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          CardWidget(
            width: 1472,
            child: PhotoUpload(
              label: "건물 사진 등록",
              imageFileListModel: buildingImageList,
              maxUploadCount: 3,
              toolTipMessage: "건물 사진은 최대 3개까지 등록 가능합니다.",
            ),
          ),
        ],
      ),
    );
  }
}
