import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class SelectDayWidget extends StatefulWidget {
  final double width;
  final DateTime timeSelect;
  final Function(DateTime) onTimeChanged; // Thêm callback để cập nhật dữ liệu

  const SelectDayWidget({
    super.key,
    required this.width,
    required this.timeSelect,
    required this.onTimeChanged,
  });

  @override
  State<SelectDayWidget> createState() => _SelectDayWidgetState();
}

class _SelectDayWidgetState extends State<SelectDayWidget> {
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.timeSelect;
  }

  void _pickDate() {
    picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      locale: Get.find<LocalizationController>().locale.toString() == "vi_VN"
          ? picker.LocaleType.vi
          : picker.LocaleType.en,
      minTime: DateTime(2023, 1, 1),
      maxTime: DateTime(2026, 12, 31),
      theme: picker.DatePickerTheme(
        headerColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Colors.black.withOpacity(0.6),
        itemStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        doneStyle: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onConfirm: (date) {
        setState(() {
          selectedTime = DateTime(date.year, date.month, date.day,
              selectedTime.hour, selectedTime.minute);
        });
        widget.onTimeChanged(selectedTime);
      },
      currentTime: selectedTime,
    );
  }

  void _pickTime() {
    picker.DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      locale: picker.LocaleType.vi,
      theme: picker.DatePickerTheme(
        headerColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Colors.black.withOpacity(0.6),
        itemStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        doneStyle: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      currentTime: selectedTime,
      onConfirm: (time) {
        setState(() {
          selectedTime = DateTime(selectedTime.year, selectedTime.month,
              selectedTime.day, time.hour, time.minute);
        });
        widget.onTimeChanged(selectedTime);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateTimeSelector(
          label: "days",
          value: DateConverter.dateFormat.format(selectedTime),
          onTap: _pickDate,
        ),
        _buildDateTimeSelector(
          label: "time",
          value: DateConverter.dateTimeFormat.format(selectedTime),
          onTap: _pickTime,
        ),
      ],
    );
  }

  Widget _buildDateTimeSelector(
      {required String label,
      required String value,
      required VoidCallback onTap}) {
    return SizedBox(
      width: widget.width / 2 - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.tr,
              style: const TextStyle(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: ColorResources.ssColor[4], width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                  child: Text(value,
                      style: const TextStyle(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        fontWeight: FontWeight.w500,
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
