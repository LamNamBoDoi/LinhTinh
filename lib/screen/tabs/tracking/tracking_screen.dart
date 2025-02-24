import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/helper/route_helper.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

// ignore: must_be_immutable
class TrackingScreen extends StatefulWidget {
  TrackingScreen({super.key, this.update, this.tracking});
  bool? update;
  Tracking? tracking;
  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  DateTime _timeSelect = DateTime.now();
  final _contentController = TextEditingController();
  RxBool change = false.obs;
  TrackingController trackingController = Get.find<TrackingController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.update == true) {
      _contentController.text = widget.tracking!.content!;
      _timeSelect = DateTime.fromMillisecondsSinceEpoch(widget.tracking!.date!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.update == null
              ? "${"create_tracking".tr}"
              : "${"update_tracking".tr}",
          style: TextStyle(
            fontSize: Dimensions.FONT_SIZE_EXTRA_OVER_LARGE,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.update == true
                        ? GestureDetector(
                            onTap: () {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text: 'Do you want to delete',
                                  confirmBtnText: 'Yes',
                                  cancelBtnText: 'No',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () {
                                    trackingController
                                        .deleteTracking(widget.tracking!)
                                        .then((value) {
                                      if (value == 200 || value == 201) {
                                        showCustomSnackBar("success".tr,
                                            isError: false);
                                      } else {
                                        showCustomSnackBar("fail".tr,
                                            isError: true);
                                      }
                                    });
                                    Get.offAllNamed(RouteHelper.home);
                                  });
                            },
                            child: Icon(
                              Icons.delete,
                              color: ColorResources.gradientColor,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "days".tr,
                            style: TextStyle(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.gradientColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              picker.DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                locale: Get.find<LocalizationController>()
                                            .locale
                                            .toString() ==
                                        "vi_VN"
                                    ? picker.LocaleType.vi
                                    : picker.LocaleType.en,
                                minTime: DateTime(2023, 1, 1),
                                maxTime: DateTime(2026, 12, 31),
                                theme: const picker.DatePickerTheme(
                                    headerColor: Color(0xFF5D7B6F),
                                    backgroundColor: Color(0xFF2D99AE),
                                    itemStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                onConfirm: (date) {
                                  setState(() {
                                    _timeSelect = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _timeSelect.hour,
                                      _timeSelect.minute,
                                    );
                                  });
                                },
                                currentTime: DateTime.now(),
                              );
                            },
                            child: Container(
                              width: width / 2 - 20,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.ssColor[4],
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  DateConverter.dateFormat.format(_timeSelect),
                                  style: TextStyle(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      fontWeight: FontWeight.w500,
                                      color: ColorResources.ssColor[4]),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "time".tr,
                            style: TextStyle(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.gradientColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              picker.DatePicker.showTimePicker(
                                context,
                                showTitleActions: true,
                                locale: LocaleType.vi,
                                onConfirm: (time) {
                                  setState(() {
                                    _timeSelect = DateTime(
                                      _timeSelect.year,
                                      _timeSelect.month,
                                      _timeSelect.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: width / 2 - 20,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.ssColor[4],
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  DateConverter.dateTimeFormat
                                      .format(_timeSelect),
                                  style: TextStyle(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      fontWeight: FontWeight.w500,
                                      color: ColorResources.ssColor[4]),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Tracking",
                  style: TextStyle(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                      fontWeight: FontWeight.w500,
                      color: ColorResources.gradientColor),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _contentController,
                  radius: Radius.circular(15),
                  hintText: "Tracking",
                  onChange: (text) {
                    change.value = true;
                  },
                  colorHint: ColorResources.ssColor[4],
                  colorText: ColorResources.ssColor[4],
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      buttonText:
                          widget.update == true ? "save".tr : "create".tr,
                      onPressed: () {
                        print("update: " + widget.update.toString());
                        if (widget.update == null || widget.update == false) {
                          if (_contentController.text != "") {
                            trackingController
                                .addTracking(
                                    _contentController.text, _timeSelect)
                                .then((value) {
                              if (value == 200 || value == 201) {
                                showCustomSnackBar("success".tr,
                                    isError: false);
                                _contentController.text = '';
                              } else {
                                showCustomSnackBar("fail".tr, isError: false);
                              }
                              print(value);
                            });
                          } else {
                            // showCustomSnackBar("fail".tr, isError: false);

                            showCustomFlash("fail".tr, context, isError: true);
                          }
                        } else {
                          if (change.value == true) {
                            if (_contentController.text != '') {
                              trackingController
                                  .updateTracking(widget.tracking!,
                                      _contentController.text, _timeSelect)
                                  .then((value) {
                                if (value == 200 || value == 201) {
                                  showCustomSnackBar("success".tr,
                                      isError: false);
                                } else {
                                  // showCustomSnackBar("fail".tr,
                                  //     isError: false);

                                  showCustomFlash("fail".tr, context,
                                      isError: true);
                                }
                              });
                            } else {
                              showCustomFlash("fail".tr, context,
                                  isError: true);
                            }
                          }
                          Get.offAllNamed(RouteHelper.home);
                        }
                      },
                    )
                  ],
                ))
              ],
            ),
          ),
          Obx(() {
            return Center(
              child: Visibility(
                visible: Get.find<TrackingController>().isLoading.value,
                child: const CircularProgressIndicator(),
              ),
            );
          })
        ],
      ),
    );
  }
}
