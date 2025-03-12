import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:timesheet/utils/color_resources.dart';

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget({super.key, required this.valueGender});
  final Rx<String?> valueGender;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              border: Border.all(color: ColorResources.ssColor[4], width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButton2<String>(
              isExpanded: true,
              barrierLabel: "gender".tr,
              hint: Text('select_your_gender'.tr),
              value: valueGender.value, // Đảm bảo giá trị hợp lệ
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 36,
              ),
              underline: SizedBox(),
              items: [
                DropdownMenuItem(
                  value: "M",
                  child: Text("male".tr),
                ),
                DropdownMenuItem(
                  value: "N",
                  child: Text("female".tr),
                ),
                DropdownMenuItem(
                  value: "O",
                  child: Text("other".tr),
                ),
              ],
              onChanged: (value) {
                valueGender.value = value ?? ""; // Cập nhật giá trị
              },
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ));
  }
}
