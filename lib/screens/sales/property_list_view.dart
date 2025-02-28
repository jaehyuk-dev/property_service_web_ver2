import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/models/common/search_condition.dart';
import 'package:property_service_web_ver2/models/property/property_detail_model.dart';
import 'package:property_service_web_ver2/models/property/property_summary_model.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/foramt_utils.dart';
import '../../core/utils/toast_manager.dart';
import '../../models/common/remark_model.dart';
import '../../models/property/building_detail_model.dart';
import '../../models/property/building_summary_model.dart';
import '../../models/property/property_transaction_type_model.dart';
import '../../service/property_service.dart';
import '../../widgets/common/card_widget.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class PropertyList extends StatefulWidget {
  const PropertyList({super.key});

  @override
  State<PropertyList> createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  late LoadingState loadingState;
  final PropertyService _propertyService = PropertyService();

  String searchType = "전체";
  List<String> searchTypeList = ["전체", "임대인", "임대인 전화번호", "주소"];
  final TextEditingController _keywordController = TextEditingController();

  int? selectedPropertyId;
  List<PropertySummaryModel> propertySummaryList = [];
  BuildingDetailModel? buildingDetail;
  PropertyDetailModel? propertyDetail;

  bool isBuildingDetailCollapse = false;

  // 매물 목록 검색 API 호출
  Future<void> _searchProperties() async {
    try {
      loadingState.setLoading(true);

      List<PropertySummaryModel> response = await _propertyService.searchPropertySummaryList(SearchCondition(searchType: searchType, keyword: _keywordController.text));
      // API 호출
      setState(() {
        propertySummaryList = response;
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
      final BuildingDetailModel? detail = await _propertyService.searchBuildingDetail(propertyDetail!.buildingId);

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

  // 매물 상세 정보 가져오기
  Future<void> _fetchPropertyDetail() async {
    try {
      loadingState.setLoading(true);
      final PropertyDetailModel? detail = await _propertyService.searchPropertyDetail(selectedPropertyId!);

      if (mounted) {
        setState(() {
          propertyDetail = detail;
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


  void _fetchDetails() async {
    await _fetchPropertyDetail();
    await _fetchBuildingDetail();
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    _searchProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
        screenType: ScreenType.PropertyList,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 480,
              height: 724,
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
                  Row(
                    children: [
                      Container(
                        width: 160,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: searchType,
                            dropdownColor: AppColors.color1,
                            borderRadius: BorderRadius.circular(8),
                            items: searchTypeList
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  searchType = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _keywordController,
                          decoration: InputDecoration(
                            hintText: "   $searchType 검색...",
                            suffixIcon: IconButton(onPressed: _searchProperties, icon: Icon(Icons.search)),
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
                          onSubmitted: (_) => _searchProperties(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: propertySummaryList.isEmpty
                        ? Center(child: Text("검색 결과가 없습니다."))
                        : ListView.separated(
                      itemCount: propertySummaryList.length,
                      itemBuilder: (context, index) {
                        final property = propertySummaryList[index];
                        return _buildPropertySummaryInfo(property);
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
                                  buildingDetail == null ? "" : "(${buildingDetail!.buildingZoneCode}) ${buildingDetail!.buildingAddress} ${propertyDetail!.roomNumber}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  buildingDetail == null ? "" : "${buildingDetail!.buildingId}번 건물 / ${buildingDetail!.buildingName} / ${buildingDetail!.buildingJibunAddress} ${propertyDetail!.roomNumber}",
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
                                                DialogUtils.showImageDialog(context, "http://localhost:8080/${image.imageUrl}"); // ✅ 클릭하면 확대 팝업
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    "http://localhost:8080/${image.imageUrl}", // ✅ 실제 API 도메인으로 변경 필요
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
              ],
            )
          ],
        ),
    );
  }

  Widget _buildPropertySummaryInfo(PropertySummaryModel property){
    return InkWell(
        onTap: () async {
          if (selectedPropertyId != property.propertyId) {
            setState(() {
              selectedPropertyId = property.propertyId;
            });
          }
          _fetchDetails();
        },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedPropertyId == property.propertyId ? Color(0xFFE5E7EB) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: property.propertyMainPhotoUrl.isNotEmpty
                  ? Image.network(
                "http://localhost:8080/${property.propertyMainPhotoUrl}", // todo 정적 파일이 제공되는 API 주소 변경
                width: 360,
                height: 240,
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
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Color(0xFF6A8988)),
                SizedBox(width: 8),
                SizedBox(
                  width: 400,
                  child: Text(
                    property.propertyAddress,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.price_check, size: 16, color: Color(0xFF6A8988)), // 가격 아이콘 추가
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _buildTransactionSummary(property.propertyTransactionList),
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ 매물 가격 정보를 여러 줄로 표시하는 함수 (₩ 기호 추가)
  String _buildTransactionSummary(List<PropertyTransactionTypeModel> transactionList) {
    if (transactionList.isEmpty) return "가격 정보 없음";

    return transactionList.map((transaction) {
      return "${transaction.transactionType}:  ${transaction.price}"; // 🚀 ₩ 추가!
    }).join("\n");
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
