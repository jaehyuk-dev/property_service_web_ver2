import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/models/common/transaction_type_model.dart';
import 'package:property_service_web_ver2/models/property/building_detail_model.dart';
import 'package:property_service_web_ver2/models/property/building_summary_model.dart';
import 'package:property_service_web_ver2/models/property/property_register_model.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/enums/datepicker_type.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/foramt_utils.dart';
import '../../core/utils/toast_manager.dart';
import '../../models/common/file_upload_model.dart';
import '../../models/common/image_file_list_model.dart';
import '../../models/common/maintenance_form.dart';
import '../../models/common/remark_model.dart';
import '../../service/property_service.dart';
import '../../widgets/common/custom_date_picker.dart';
import '../../widgets/common/custom_options_checkbox_group.dart';
import '../../widgets/common/custom_radio_group.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/maintenance_cost_form.dart';
import '../../widgets/common/photo_upload.dart';
import '../../widgets/common/property_sell_type.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class PropertyRegister extends StatefulWidget {
  const PropertyRegister({super.key});

  @override
  State<PropertyRegister> createState() => _PropertyRegisterState();
}

class _PropertyRegisterState extends State<PropertyRegister> {
  late LoadingState loadingState;
  final PropertyService _propertyService = PropertyService();

  /// ###############################################################################

  TextEditingController searchWordController = TextEditingController();

  int? selectedBuildingId;
  List<BuildingSummaryModel> buildingSummaryList = [];
  BuildingDetailModel? buildingDetail;

  bool isBuildingDetailCollapse = false;

  // 건물 목록 검색 API 호출
  Future<void> _searchBuilding() async {
    try {
      loadingState.setLoading(true);

      List<BuildingSummaryModel> response = await _propertyService.searchBuildingSummaryList(searchWordController.text);
      // API 호출
      setState(() {
        buildingSummaryList = response;
      });

    } catch (e) {
      print("🚨 검색 중 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 건물 상세 정보 가져오기
  Future<void> _fetchBuildingDetail() async {
    try {
      loadingState.setLoading(true);
      final BuildingDetailModel? detail = await _propertyService.searchBuildingDetail(selectedBuildingId!);

      if (mounted) {
        setState(() {
          buildingDetail = detail;
        });
      }
    } catch (e) {
      print("🚨 검색 중 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 건물 특이사항 등록
  void registerBuildingtRemark({required int buildingId}) async {
    TextEditingController buildingRemark = TextEditingController();

    await DialogUtils.showCustomDialog<void>(
        context: context,
        title: "특이사항 등록",
        child: CustomTextField(label: "특이사항", controller: buildingRemark, maxLines: 2),
        onConfirm: () async {
          if (buildingRemark.text.isEmpty) {
            await DialogUtils.showAlertDialog(context: context, title: "경고", content: "모든 항목을 입력해 주세요");
          } else {
            Navigator.pop(context, true);
          }
        }
    );

    if(buildingRemark.text.isNotEmpty){
      try {
        loadingState.setLoading(true);
        await _propertyService.registerBuildingRemark(buildingId, buildingRemark.text);
        ToastManager().showToast(context, "특이사항이 등록 되었습니다.");
        await _fetchBuildingDetail();
      } catch (e) {
        print("❌ 오류 발생: $e");
      } finally {
        loadingState.setLoading(false);
      }
    }
  }

  // 건물 특이사항 삭제
  void deleteBuildingRemark({required int clientRemarkId}) async {
    try {
      loadingState.setLoading(true);
      await _propertyService.deleteBuildingRemark(clientRemarkId);
      ToastManager().showToast(context, "특이사항이 제거되었습니다.");
      await _fetchBuildingDetail();
    } catch (e) {
      print("❌ 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  void _clearPropertyForm() async {
    setState(() {
      // 임대인 정보 초기화
      ownerName.clear();
      ownerPhoneNumber.clear();
      ownerRelation = null;
      ownerRelationOther.clear();

      // 매물 정보 초기화
      roomNumber.clear();
      propertyType = null;
      propertyTypeOther.clear();
      propertyStatus = null;
      propertyFloor.clear();
      roomBathCount.clear();
      mainRoomDirection.clear();
      exclusiveArea.clear();
      supplyArea.clear();

      approvalDate = null;
      moveInDate = null;
      moveOutDate = null;
      availableMoveInDate = null;

      // 거래 정보 초기화
      monthlyDepositAmountController.clear();
      monthlyAmountController.clear();
      jeonseAmountController.clear();
      shortTermDepositAmountController.clear();
      shortTermMonthlyAmountController.clear();

      // 관리비 및 옵션 초기화
      maintenanceFormModel = MaintenanceFormModel(
        maintenanceFee: 0,
        isWaterSelected: false,
        isElectricitySelected: false,
        isInternetSelected: false,
        isHeatingSelected: false,
        others: "",
      );

      selectedOptions = [false, false, false, false, false, false];

      heatingType = null;
      remark.clear();

      // 이미지 초기화
      propertyImageList.imageFileModelList.clear();
    });
  }

  /// ###############################################################################

  // 컨트롤러 정의
  final TextEditingController ownerName = TextEditingController();
  final TextEditingController ownerPhoneNumber = TextEditingController();
  String? ownerRelation;
  final TextEditingController ownerRelationOther = TextEditingController();

  final TextEditingController roomNumber = TextEditingController();
  String? propertyType;
  final TextEditingController propertyTypeOther = TextEditingController();
  String? propertyStatus;
  final TextEditingController propertyFloor = TextEditingController();
  final TextEditingController roomBathCount = TextEditingController();
  final TextEditingController mainRoomDirection = TextEditingController();

  final TextEditingController exclusiveArea = TextEditingController();
  final TextEditingController supplyArea = TextEditingController();

  DateTime? approvalDate;
  DateTime? moveInDate;
  DateTime? moveOutDate;
  DateTime? availableMoveInDate;

  final TextEditingController monthlyDepositAmountController = TextEditingController();
  final TextEditingController monthlyAmountController = TextEditingController();
  final TextEditingController jeonseAmountController = TextEditingController();
  final TextEditingController shortTermDepositAmountController = TextEditingController();
  final TextEditingController shortTermMonthlyAmountController = TextEditingController();

  MaintenanceFormModel maintenanceFormModel = MaintenanceFormModel(maintenanceFee: 0, isWaterSelected: false, isElectricitySelected: false, isInternetSelected: false, isHeatingSelected: false, others: "");

  List<String> optionItemCodeList = [];
  List<bool> selectedOptions = [false, false, false, false, false, false];

  String? heatingType;
  final TextEditingController remark = TextEditingController();

  ImageFileListModel propertyImageList = ImageFileListModel(imageFileModelList: []);

  // 매물 등록
  Future<void> _registerProperty() async {
    if(selectedBuildingId == null){
      DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "등록할 매물이 속한 건물을 먼저 선택해 주세요");
      return;
    }

    // 날짜 필드 검증
    if(propertyStatus == "공실" && availableMoveInDate == null){
      DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "매물 상태가 '공실'인 경우 입주 가능일을 선택해 주세요");
      return;
    }
    
    if(propertyStatus != null && propertyStatus != "공실"){
      if(moveInDate == null){
        DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "매물 상태가 '계약 중' 또는 '거주 중'인 경우 입실 일을 선택해 주세요");
        return;
      }
      if(moveOutDate == null){
        DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "매물 상태가 '계약 중' 또는 '거주 중'인 경우 퇴실 일을 선택해 주세요");
        return;
      }
    }

    // 필수 필드 검증
    if(propertyType == null || propertyType!.isEmpty){
      DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "매물 형태를 선택해 주세요");
      return;
    }
    
    if(ownerName.text.isEmpty){
      DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "임대인 이름을 입력해 주세요");
      return;
    }
    
    if(ownerPhoneNumber.text.isEmpty){
      DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "임대인 전화번호를 입력해 주세요");
      return;
    }
    
    if(roomNumber.text.isEmpty){
      DialogUtils.showAlertDialog(context: context, title: "매물 등록 경고", content: "호수를 입력해 주세요");
      return;
    }

    loadingState.setLoading(true);
    FileUploadModel? fileUploadResponse;

    // 1. 이미지 업로드 (선택사항)
    List<String> photoUrls = []; // 빈 리스트로 초기화
    
    try {
      if (propertyImageList.imageFileModelList.isNotEmpty) {
        fileUploadResponse = await _propertyService.uploadPropertyImages(propertyImageList.imageFileModelList);

        if (fileUploadResponse != null && fileUploadResponse.fileUrls.isNotEmpty) {
          photoUrls = fileUploadResponse.fileUrls;
          print("✅ 업로드된 파일 URL 리스트: ${fileUploadResponse.fileUrls}");
        } else {
          ToastManager().showToast(context, "매물 이미지 업로드 실패");
          return;
        }
      }
      // 이미지가 없는 경우는 그냥 빈 리스트로 진행

    } catch (e) {
      print("🚨 이미지 업로드 실패: $e");
      await DialogUtils.showAlertDialog(
          context: context,
          title: "매물 등록 실패",
          content: "매물 이미지 등록에 실패했습니다."
      );
      return;
    }

    int _convertPropertyStatusToCode(String? status) {
      switch (status) {
        case "공실":
          return 101;
        case "계약 중":
          return 102;
        case "거주 중":
          return 103;
        default:
          return 0; // 기본값 (예: 미선택 상태)
      }
    }
    List<int> _getSelectedMaintenanceItems(MaintenanceFormModel model) {
      List<int> selectedCodes = [];

      if (model.isWaterSelected) selectedCodes.add(71);
      if (model.isElectricitySelected) selectedCodes.add(72);
      if (model.isInternetSelected) selectedCodes.add(73);
      if (model.isHeatingSelected) selectedCodes.add(74);

      return selectedCodes;
    }

    List<int> _getSelectedOptions(List<bool> selections) {
      List<int> selectedCodes = [];

      if (selections[0]) selectedCodes.add(91); // 에어컨
      if (selections[1]) selectedCodes.add(92); // 세탁기
      if (selections[2]) selectedCodes.add(93); // 냉장고
      if (selections[3]) selectedCodes.add(94); // 가스레인지

      return selectedCodes; // 🚀 반드시 반환
    }


    int _getHeatingTypeCode(String? heatingType) {
      switch (heatingType) {
        case "개별":
          return 81;
        case "중앙":
          return 82;
        case "심야":
          return 83;
        default:
          return 0; // 선택되지 않았을 경우 기본값 (필요하면 수정)
      }
    }

    List<TransactionTypeModel> _getTransactionTypeList() {
      List<TransactionTypeModel> list = [];

      // 월세 선택 시
      if (monthlyDepositAmountController.text.isNotEmpty && monthlyAmountController.text.isNotEmpty) {
        list.add(TransactionTypeModel(
          transactionCode: 61, // 61 = 월세
          price1: int.tryParse(monthlyDepositAmountController.text.replaceAll(',', '')) ?? 0,
          price2: int.tryParse(monthlyAmountController.text.replaceAll(',', '')) ?? 0,
        ));
      }

      // 전세 선택 시
      if (jeonseAmountController.text.isNotEmpty) {
        list.add(TransactionTypeModel(
          transactionCode: 62, // 62 = 전세
          price1: int.tryParse(jeonseAmountController.text.replaceAll(',', '')) ?? 0,
        ));
      }

      // 단기 임대 선택 시
      if (shortTermDepositAmountController.text.isNotEmpty && shortTermMonthlyAmountController.text.isNotEmpty) {
        list.add(TransactionTypeModel(
          transactionCode: 64, // 64 = 단기
          price1: int.tryParse(shortTermDepositAmountController.text.replaceAll(',', '')) ?? 0,
          price2: int.tryParse(shortTermMonthlyAmountController.text.replaceAll(',', '')) ?? 0,
        ));
      }

      return list;
    }




    // 2. 매물 등록 요청
    try {
      PropertyRegisterModel registerModel = PropertyRegisterModel(
        buildingId: selectedBuildingId!,
        ownerName: ownerName.text,
        ownerPhoneNumber: ownerPhoneNumber.text,
        ownerRelation: ownerRelation == "기타"
            ? (ownerRelationOther.text.isNotEmpty ? ownerRelationOther.text : "기타") // ✅ 기타 입력값이 비어있으면 "기타"로 설정
            : ownerRelation ?? "",
        roomNumber: roomNumber.text,
        propertyType: propertyType == "기타"
            ? (propertyTypeOther.text.isNotEmpty ? propertyTypeOther.text : "기타") // ✅ 기타 입력값이 비어있으면 "기타"로 설정
            : propertyType ?? "",
        propertyStatusCode: _convertPropertyStatusToCode(propertyStatus),
        propertyFloor: propertyFloor.text,
        roomBathCount: roomBathCount.text,
        mainRoomDirection: mainRoomDirection.text,
        exclusiveArea: double.tryParse(exclusiveArea.text.replaceAll(',', '')) ?? 0.0, // ✅ 숫자 변환
        supplyArea: double.tryParse(supplyArea.text.replaceAll(',', '')) ?? 0.0, // ✅ 숫자 변환
        approvalDate: approvalDate != null ? FormatUtils.formatToYYYYmmDD_forAPI(approvalDate!) : "", // ✅ 날짜 변환
        moveInDate: moveInDate != null ?  FormatUtils.formatToYYYYmmDD_forAPI(moveInDate!) : "",
        moveOutDate: moveOutDate != null ?  FormatUtils.formatToYYYYmmDD_forAPI(moveOutDate!) : "",
        availableMoveInDate: availableMoveInDate != null ?  FormatUtils.formatToYYYYmmDD_forAPI(availableMoveInDate!) : "",
        transactionTypeList: _getTransactionTypeList(),
        maintenancePrice: maintenanceFormModel.maintenanceFee,
        maintenanceItemCodeList: _getSelectedMaintenanceItems(maintenanceFormModel),
        optionItemCodeList: _getSelectedOptions(selectedOptions),
        heatingTypeCode: _getHeatingTypeCode(heatingType),
        remark: remark.text,
        propertyMainPhotoIndex: propertyImageList.representativeImageIndex ?? 0,
        photoList: photoUrls,
      );

      await _propertyService.registerProperty(registerModel);

      _clearAllForm();

      ToastManager().showToast(context, "매물이 등록 되었습니다.");
    } catch (e) {
      print("🚨 매물 등록 실패: $e");
      await DialogUtils.showAlertDialog(
          context: context,
          title: "매물 등록 실패",
          content: "매물 정보 등록에 실패했습니다."
      );
    } finally {
      loadingState.setLoading(false);
    }
  }

  void _clearAllForm() {
    setState(() {
      // 건물 정보 초기화
      selectedBuildingId = null;
      buildingDetail = null;
      searchWordController.clear();
      buildingSummaryList.clear();

      // 임대인 정보 초기화
      ownerName.clear();
      ownerPhoneNumber.clear();
      ownerRelation = null;
      ownerRelationOther.clear();

      // 매물 정보 초기화
      roomNumber.clear();
      propertyType = null;
      propertyTypeOther.clear();
      propertyStatus = null;
      propertyFloor.clear();
      roomBathCount.clear();
      mainRoomDirection.clear();
      exclusiveArea.clear();
      supplyArea.clear();

      approvalDate = null;
      moveInDate = null;
      moveOutDate = null;
      availableMoveInDate = null;

      // 거래 정보 초기화
      monthlyDepositAmountController.clear();
      monthlyAmountController.clear();
      jeonseAmountController.clear();
      shortTermDepositAmountController.clear();
      shortTermMonthlyAmountController.clear();

      // 관리비 및 옵션 초기화
      maintenanceFormModel = MaintenanceFormModel(
        maintenanceFee: 0,
        isWaterSelected: false,
        isElectricitySelected: false,
        isInternetSelected: false,
        isHeatingSelected: false,
        others: "",
      );

      selectedOptions = [false, false, false, false, false, false];

      heatingType = null;
      remark.clear();

      // 이미지 초기화
      propertyImageList.imageFileModelList.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    _searchBuilding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      screenType: ScreenType.PropertyRegister,
      buttonText: "등록",
      onTap: _registerProperty,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 480,
            height: 2200,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(32),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchWordController,
                  decoration: InputDecoration(
                    hintText: "   주소 검색...",
                    suffixIcon: IconButton(onPressed: _searchBuilding, icon: Icon(Icons.search)),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD1D5DB), // 초록색 강조
                        width: 2.0, // 포커스 없을 때 테두리 두께 2.0
                      ),
                    ),
                    // 포커스 테두리 (focused)
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 3.0, // 포커스 상태 경계선 두께 3.0
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFFD1D5DB), // 초록색 강조
                    ),
                  ),
                  onSubmitted: (_) => _searchBuilding(),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: buildingSummaryList.isEmpty
                      ? Center(child: Text("검색 결과가 없습니다."))
                      : ListView.separated(
                    itemCount: buildingSummaryList.length,
                    itemBuilder: (context, index) {
                      final building = buildingSummaryList[index];
                      return _buildBuildingSummaryInfo(building);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 24),
          Column(
            children: [
              // 건물 상세 정보
              Container(
                width: 960,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF6A8988),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(32),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  buildingDetail == null ? "" : "(${buildingDetail!.buildingZoneCode}) ${buildingDetail!.buildingAddress}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                buildingDetail == null ? "" : "${buildingDetail!.buildingId}번 건물 / ${buildingDetail!.buildingName} / ${buildingDetail!.buildingJibunAddress}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFF3F4F6),
                                ),
                              ),
                            ],
                          ),
                          buildingDetail == null
                              ? SizedBox.shrink()
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isBuildingDetailCollapse = !isBuildingDetailCollapse;
                                    });
                                  },
                                  icon: Icon(
                                    isBuildingDetailCollapse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: Colors.white,
                              ),
                          ),
                        ],
                      ),
                      if(isBuildingDetailCollapse)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 160, child: _buildBasicInfo("준공 연도", buildingDetail == null ? "" : "${buildingDetail!.buildingCompletedYear} 년", icon: Icons.foundation)),
                                  SizedBox(width: 220, child: _buildBasicInfo("건축 용도", buildingDetail == null ? "" : "${buildingDetail!.buildingTypeName}", icon: Icons.apartment)),
                                  SizedBox(width: 160, child: _buildBasicInfo("총 층수", buildingDetail == null ? "" : "${buildingDetail!.buildingFloorCount}", icon: Icons.business)),
                                  SizedBox(width: 160, child: _buildBasicInfo("주차 대수", buildingDetail == null ? "" : "${buildingDetail!.buildingParkingAreaCount} 대", icon: Icons.local_parking)),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  SizedBox(width: 160, child: _buildBasicInfo("엘레베이터 대수", buildingDetail == null ? "" : "${buildingDetail!.buildingElevatorCount} 대", icon: Icons.elevator)),
                                  SizedBox(width: 220, child: _buildBasicInfo("공동 현관문 비밀번호", buildingDetail == null ? "" : buildingDetail!.buildingCommonPassword == "" ? "없음" : buildingDetail!.buildingCommonPassword, icon: Icons.lock)),
                                  SizedBox(width: 160, child: _buildBasicInfo("위반 건축물 여부", buildingDetail == null ? "" : buildingDetail!.buildingHasIllegal ? "있음" : "없음", icon: Icons.warning)),
                                  SizedBox(width: 160, child: _buildBasicInfo("주 출입문 방향", buildingDetail == null ? "" : buildingDetail!.buildingMainDoorDirection, icon: Icons.explore)),
                                ],
                              ),
                              SizedBox(height: 24),
                              CardWidget(
                                title: "특이사항",
                                width: 960,
                                onPlusTap: buildingDetail == null
                                    ? null
                                    : () async {
                                  // 일정 추가 기능 추가 가능
                                  registerBuildingtRemark(buildingId: buildingDetail!.buildingId);
                                },
                                child: SizedBox(
                                  height: 160,
                                  child: buildingDetail == null || buildingDetail!.buildingRemarkList.isEmpty
                                      ? Center(child: Text("등록된 특이사항이 없습니다."))
                                      : ListView.separated(
                                    itemCount: buildingDetail!.buildingRemarkList.length,
                                    itemBuilder: (context, index){
                                      final remark = buildingDetail!.buildingRemarkList[index];
                                      return _buildRemarkItem(remark);
                                    },
                                    separatorBuilder: (context, index) => SizedBox(height: 12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              CardWidget(
                                title: "건물 사진",
                                width: 960,
                                child: Column(
                                  children: [
                                    SizedBox(height: 32),
                                    SizedBox(
                                      height: 160,
                                      child: buildingDetail == null || buildingDetail!.buildingImageList.isEmpty
                                          ? Center(child: Text("등록된 건물 사진이 없습니다."))
                                          : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: buildingDetail!.buildingImageList.length,
                                        itemBuilder: (context, index) {
                                          final image = buildingDetail!.buildingImageList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              DialogUtils.showImageDialog(context, "${AppConfig.fileBaseUrl}/${image.imageUrl}"); // ✅ 클릭하면 확대 팝업
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  "${AppConfig.fileBaseUrl}/${image.imageUrl}", // ✅ 실제 API 도메인으로 변경 필요
                                                  width: 160,
                                                  height: 160,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Container(
                                                      width: 160,
                                                      height: 160,
                                                      color: Colors.grey.shade300,
                                                      child: Center(child: CircularProgressIndicator()),
                                                    );
                                                  },
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      width: 160,
                                                      height: 160,
                                                      color: Colors.grey.shade300,
                                                      child: Center(
                                                        child: Text(
                                                          "Image Error",
                                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              CardWidget(
                title: "임대인 정보",
                width: 960,
                child: Column(
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
                                  "이름",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: ownerName),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomRadioGroup(
                            title: "관계",
                            options: ["사장", "사모", "기타"],
                            groupValue: ownerRelation,
                            onChanged: (value){
                              setState(() {
                                ownerRelation = value;
                              });
                            },
                            otherLabel: "",
                            otherInput: "기타",
                            otherInputTextController: ownerRelationOther,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "전화번호",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        CustomTextField(label: "",controller: ownerPhoneNumber),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              CardWidget(
                title: "매물 정보",
                width: 960,
                child: Column(
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
                                  "호 실",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: roomNumber),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomRadioGroup(
                            title: "매물 형태",
                            options: ["원룸", "투룸", "기타"],
                            groupValue: propertyType,
                            onChanged: (value){
                              setState(() {
                                propertyType = value;
                              });
                            },
                            otherLabel: "",
                            otherInput: "기타",
                            otherInputTextController: propertyTypeOther,
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
                                  "해당 층",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: propertyFloor),
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
                                  "방 / 욕실 개수",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: roomBathCount),
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
                                  "거실 기준 방향",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomTextField(label: "",controller: mainRoomDirection),
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
                                child: Row(
                                  children: [
                                    Text(
                                      "전용 면적",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Tooltip(
                                      message: "숫자만 입력 가능합니다.",
                                      child: Icon(
                                        Icons.info_outline, // 툴팁 아이콘
                                        size: 20,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomTextField(
                                label: "",
                                controller: exclusiveArea,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                                suffixText: "m²",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "공급 면적",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Tooltip(
                                      message: "숫자만 입력 가능합니다.",
                                      child: Icon(
                                        Icons.info_outline, // 툴팁 아이콘
                                        size: 20,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomTextField(
                                label: "",
                                controller: supplyArea,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                                suffixText: "m²",
                              ),
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
                                  "사용 승인 일",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              CustomDatePicker(
                                datePickerType: DatePickerType.date,
                                label: "",
                                selectedDateTime: approvalDate,
                                onChanged:  (DateTime? newDate) {
                                  setState(() {
                                    approvalDate = newDate;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      height: 96,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomRadioGroup(
                              title: "매물 상태",
                              options: ["공실", "계약 중", "거주 중"],
                              groupValue: propertyStatus,
                              onChanged: (value){
                                setState(() {
                                  propertyStatus = value;
                                });
                              },
                            ),
                          ),
                          if(propertyStatus != null && propertyStatus == "공실")
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      "입주 가능 일",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  CustomDatePicker(
                                    datePickerType: DatePickerType.date,
                                    label: "",
                                    selectedDateTime: availableMoveInDate,
                                    onChanged:  (DateTime? newDate) {
                                      setState(() {
                                        availableMoveInDate = newDate;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          if(propertyStatus != null && propertyStatus != "공실")
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      "입실 일",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  CustomDatePicker(
                                    datePickerType: DatePickerType.date,
                                    label: "",
                                    selectedDateTime: moveInDate,
                                    onChanged:  (DateTime? newDate) {
                                      setState(() {
                                        moveInDate = newDate;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          if(propertyStatus != null && propertyStatus != "공실")
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      "퇴실 일",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  CustomDatePicker(
                                    datePickerType: DatePickerType.date,
                                    label: "",
                                    selectedDateTime: moveOutDate,
                                    onChanged:  (DateTime? newDate) {
                                      setState(() {
                                        moveOutDate = newDate;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              CardWidget(
                title: "거래 정보",
                width: 960,
                child: Column(
                  children: [
                    PropertySellType(
                      monthlyDepositAmountController: monthlyDepositAmountController,
                      monthlyAmountController: monthlyAmountController,
                      jeonseAmountController: jeonseAmountController,
                      shortTermDepositAmountController: shortTermDepositAmountController,
                      shortTermMonthlyAmountController: shortTermMonthlyAmountController,
                    ),
                    SizedBox(height: 16),
                    MaintenanceCostForm(maintenanceFormModel: maintenanceFormModel),
                    SizedBox(height: 16),
                    CustomCheckboxGroup2(
                      title: "옵션",
                      options: ["풀옵션", "에어컨", "세탁기", "냉장고", "가스레인지"],
                      initialSelection: selectedOptions,
                      onChanged: (selections) {
                        setState(() {
                          selectedOptions = selections;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    CustomRadioGroup(
                      title: "난방 방식",
                      options: ["개별", "중앙", "심야"],
                      groupValue: heatingType,
                      onChanged: (value){
                        setState(() {
                          heatingType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              CardWidget(
                title: "특이사항",
                width: 960,
                child: Column(
                  children: [
                    SizedBox(height: 4),
                    CustomTextField(label: "", controller: remark, maxLines: 5),
                  ],
                ),
              ),
              SizedBox(height: 32),
              CardWidget(
                width: 960,
                child: PhotoUpload(
                  label: "건물 사진 등록",
                  imageFileListModel: propertyImageList,
                  maxUploadCount: 5,
                  toolTipMessage: "매물 사진은 최대 3개까지 등록 가능합니다.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingSummaryInfo(BuildingSummaryModel building) {
    return InkWell(
      onTap: () async {
        if(selectedBuildingId == null){
          if (selectedBuildingId != building.buildingId) {
            setState(() {
              selectedBuildingId = building.buildingId;
            });
          }
          _fetchBuildingDetail();
        } else{
          bool result = await DialogUtils.showConfirmDialog(context: context,width: 480, title: "선택 건물 변경", content: "다른 건물을 선택하시면 입력된 항목들이 초기화 됩니다.\n다른 건물을 선택하시겠습니까?");
          if(result){
            _clearPropertyForm();
            if (selectedBuildingId != building.buildingId) {
              setState(() {
                selectedBuildingId = building.buildingId;
              });
            }
            _fetchBuildingDetail();
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedBuildingId == building.buildingId ? Color(0xFFE5E7EB) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (building.buildingMainPhotoUrl != null && building.buildingMainPhotoUrl!.isNotEmpty)
                  ? Image.network(
                "${AppConfig.fileBaseUrl}/${building.buildingMainPhotoUrl}",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Text(
                        "Image Error",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              )
                  : Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade300,
                child: Center(
                  child: Text(
                    "No Image",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.buildingName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 16, color: Color(0xFF6A8988)),
                    SizedBox(
                      width: 240,
                      child: Text(
                        building.buildingAddress,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(String label, String content, {VoidCallback? onEditTap, IconData? icon}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if(icon != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(icon, size: 20, color: Colors.grey[300],),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (onEditTap != null)
              Row(
                children: [
                  SizedBox(width: 8),
                  InkWell(
                    onTap: onEditTap,
                    child: Icon(
                      Icons.credit_card_sharp,
                      size: 18,
                      color: Color(0xFF9CA3AF),
                    ),
                  )
                ],
              ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 32),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRemarkItem(RemarkModel remark) {
    ValueNotifier<bool> _isHovered = ValueNotifier(false);
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                remark.remark,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, isHovered, child) {
                  return AnimatedOpacity(
                    opacity: isHovered ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 100),
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey),
                      iconSize: 16,
                      onPressed: () => deleteBuildingRemark(clientRemarkId: remark.remarkId),
                      hoverColor: Colors.transparent,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "작성자: ${remark.createdBy}",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              Text(
                FormatUtils.formatToYYYYMMDD(remark.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
