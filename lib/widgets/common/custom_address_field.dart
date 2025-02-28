import 'package:flutter/material.dart';
import 'package:kpostal_web/model/kakao_address.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';

class CustomAddressField extends StatefulWidget {
  final String label;
  String? zipCode;
  String? address;
  String? jibunAddress;
  final Function(String?, String?, String?)? onChanged; // 추가
  CustomAddressField({super.key,
      required this.label,
      required this.zipCode,
      required this.address,
      required this.jibunAddress,
      this.onChanged,
  });

  @override
  State<CustomAddressField> createState() => _CustomAddressFieldState();
}

class _CustomAddressFieldState extends State<CustomAddressField> {
  late TextEditingController controller;

  @override
  void didUpdateWidget(covariant CustomAddressField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.zipCode != widget.zipCode || oldWidget.address != widget.address) {
      controller.text = _buildAddressText(widget.zipCode, widget.address);
    }
  }

  String _buildAddressText(String? zipCode, String? address) {
    if ((zipCode == null || zipCode.isEmpty) && (address == null || address.isEmpty)) {
      return ""; // zipCode와 address가 모두 비어있으면 빈 문자열 반환
    } else if (zipCode != null && zipCode.isNotEmpty) {
      return "($zipCode) ${address ?? ""}";
    } else {
      return address ?? "";
    }
  }


  @override
  void initState() {
    controller = TextEditingController(
      text: widget.zipCode != null
          ? "(${widget.zipCode}) ${widget.address ?? ""}"
          : widget.address ?? "",
    );
    super.initState();
  }

  void _selectAddress() async {
    KakaoAddress? result = await DialogUtils.showAddressSearchDialog(context: context);
    if (result != null) {
      print('선택된 도로명 주소: ${result.address}');
      print('선택된 지번 주소: ${result.jibunAddress}');
      print('우편번호: ${result.postCode}');

      setState(() {
        widget.zipCode = result.postCode;
        widget.address = result.address;
        widget.jibunAddress = result.jibunAddress; // ✅ 지번 주소 업데이트
        controller.text = "(${widget.zipCode}) ${widget.address}  (지번: ${result.jibunAddress ?? "없음"})";
        widget.onChanged?.call(widget.zipCode, widget.address, widget.jibunAddress);
      });
    } else {
      print('주소 선택이 취소되었습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectAddress(),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: widget.label,
          // 기본 테두리 (unfocused)
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFD1D5DB), // 초록색 강조
              width: 2.0, // 포커스 없을 때 테두리 두께 2.0
            ),
          ),
          suffixIcon: InkWell(
            onTap: _selectAddress,
            child: Icon(Icons.search),
          ),
          // 포커스 테두리 (focused)
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 3.0, // 포커스 상태 경계선 두께 3.0
            ),
          ),
          labelStyle: TextStyle(
            color: Color(0xFFD1D5DB), // 초록색 강조
          ),
        ),
      ),
    );
  }
}
