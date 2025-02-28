import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_service_web_ver2/core/utils/foramt_utils.dart';

import '../../core/utils/comma_text_input_formatter.dart';
import 'custom_radio_group.dart';
import 'custom_text_field.dart';

class PropertySellType extends StatefulWidget {
  final TextEditingController monthlyDepositAmountController;
  final TextEditingController monthlyAmountController;
  final TextEditingController jeonseAmountController;
  final TextEditingController shortTermDepositAmountController;
  final TextEditingController shortTermMonthlyAmountController;

  const PropertySellType({
    super.key,
    required this.monthlyDepositAmountController,
    required this.monthlyAmountController,
    required this.jeonseAmountController,
    required this.shortTermDepositAmountController,
    required this.shortTermMonthlyAmountController,
  });

  @override
  State<PropertySellType> createState() => _PropertySellTypeState();
}

class _PropertySellTypeState extends State<PropertySellType> {
  String? selectedSellType;

  @override
  void initState() {
    super.initState();

    // TextEditingController의 리스너 추가
    widget.monthlyDepositAmountController.addListener(_changeInput);
    widget.monthlyAmountController.addListener(_changeInput);
    widget.jeonseAmountController.addListener(_changeInput);
    widget.shortTermDepositAmountController.addListener(_changeInput);
    widget.shortTermMonthlyAmountController.addListener(_changeInput);
  }

  @override
  void dispose() {
    // 리스너 제거
    widget.monthlyDepositAmountController.removeListener(_changeInput);
    widget.monthlyAmountController.removeListener(_changeInput);
    widget.jeonseAmountController.removeListener(_changeInput);
    widget.shortTermDepositAmountController.removeListener(_changeInput);
    widget.shortTermMonthlyAmountController.removeListener(_changeInput);
    super.dispose();
  }

  void _changeInput() {
    setState(() {}); // 상태 변경으로 UI 갱신
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        "월세",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: widget.monthlyDepositAmountController.text.isNotEmpty && widget.monthlyAmountController.text.isNotEmpty ? Colors.grey[800] : Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.monthlyDepositAmountController.text.isNotEmpty && widget.monthlyAmountController.text.isNotEmpty
                            ? "${FormatUtils.formatCurrency(int.tryParse(widget.monthlyDepositAmountController.text.replaceAll(',', '')) ?? 0)}/${FormatUtils.formatCurrency(int.tryParse(widget.monthlyAmountController.text.replaceAll(',', '')) ?? 0)}"
                            : "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        "전세",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: widget.jeonseAmountController.text.isNotEmpty ? Colors.grey[800] : Colors.grey[400]
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.jeonseAmountController.text.isNotEmpty
                          ? "${FormatUtils.formatCurrency(int.tryParse(widget.jeonseAmountController.text.replaceAll(',', '')) ?? 0)} 원"
                          : "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                //   child: Row(
                //     children: [
                //       Text(
                //         "매매",
                //         style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.w700,
                //           color: widget.saleAmountController.text.isNotEmpty ? Colors.grey[800] : Colors.grey[400],
                //         ),
                //       ),
                //       SizedBox(width: 8),
                //       Text(
                //         widget.saleAmountController.text.isNotEmpty
                //         ? "${widget.saleAmountController.text} 원"
                //         : "",
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        "단기",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: widget.shortTermDepositAmountController.text.isNotEmpty && widget.shortTermMonthlyAmountController.text.isNotEmpty ? Colors.grey[800] : Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.shortTermDepositAmountController.text.isNotEmpty && widget.shortTermMonthlyAmountController.text.isNotEmpty
                            ? "${FormatUtils.formatCurrency(int.tryParse(widget.shortTermDepositAmountController.text.replaceAll(',', '')) ?? 0)}/${FormatUtils.formatCurrency(int.tryParse(widget.shortTermMonthlyAmountController.text.replaceAll(',', '')) ?? 0)}"
                            : "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 40),
        SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRadioGroup(
                title: "거래 유형",
                options: ["월세", "전세", "단기"],
                groupValue: selectedSellType,
                onChanged: (value) {
                  setState(() {
                    selectedSellType = value;
                  });
                },
              ),
              if (selectedSellType == "월세")
                SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      Flexible(child: CustomTextField(label: "보증금", controller: widget.monthlyDepositAmountController, suffixText: "원",    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()],)),
                      const SizedBox(height: 8),
                      Flexible(child: CustomTextField(label: "월세", controller: widget.monthlyAmountController, suffixText: "원",    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()],)),
                    ],
                  ),
                ),
              if (selectedSellType == "전세")
                SizedBox(
                  width: 200,
                  child: CustomTextField(label: "전세금", controller: widget.jeonseAmountController, suffixText: "원",    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()]
                ),),
              // if (selectedSellType == "매매")
              //   SizedBox(
              //     width: 200,
              //     child: CustomTextField(label: "매매금", controller: widget.saleAmountController),
              //   ),
              if(selectedSellType == "단기")
                SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      Flexible(child: CustomTextField(label: "보증금", controller: widget.shortTermDepositAmountController, suffixText: "원",    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()]))
                      ,const SizedBox(height: 8),
                      Flexible(child: CustomTextField(label: "월세", controller: widget.shortTermMonthlyAmountController, suffixText: "원",    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()])),
                    ],
                  ),
                ),
              if(selectedSellType == null)
                SizedBox(height: 64)
            ],
          ),
        ),
      ],
    );
  }
}