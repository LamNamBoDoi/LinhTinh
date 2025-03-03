import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/helper/route_helper.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:timesheet/view/custom_text_field.dart';

class TrackingScreen extends StatefulWidget {
  TrackingScreen({super.key, this.update, this.tracking});
  bool? update;
  Tracking? tracking;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _contentController = TextEditingController();
  DateTime timeSelect = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(
            widget.update == null
                ? "${"create_tracking".tr}"
                : "${"update_tracking".tr}",
            style: TextStyle(
                fontSize: Dimensions.FONT_SIZE_EXTRA_OVER_LARGE,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GetBuilder<TrackingController>(
            initState: (state) {
              _contentController.text = widget.tracking?.content ?? '';
            },
            builder: (trackController) {
              if (trackController.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        widget.update == true
                            ? _selectDelete(trackController)
                            : const SizedBox(),
                      ],
                    ),
                    _selectDayTime(width),
                    SizedBox(
                      height: 30,
                    ),
                    _fillTracking(trackController)
                  ]);
            },
          ),
        ));
  }

  Widget _fillTracking(TrackingController trackingController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Tracking",
            style: TextStyle(
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
              fontWeight: FontWeight.w500,
            )),
        CustomTextField(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          controller: _contentController,
          radius: Radius.circular(15),
          hintText: "Tracking",
          onChange: (text) {
            trackingController.changed(true);
          },
        ),
        SizedBox(height: 40),
        CustomButton(
          buttonText: widget.update == true ? "save".tr : "create".tr,
          onPressed: () => _createUpdateTracking(trackingController),
        ),
      ],
    );
  }

  void _createUpdateTracking(TrackingController trackingController) {
    if (widget.update == null || widget.update == false) {
      if (_contentController.text != "") {
        trackingController
            .addTracking(_contentController.text, timeSelect)
            .then((value) {
          if (value == 200 || value == 201) {
            showCustomSnackBar("success".tr, isError: false);
            _contentController.text = '';
          } else {
            showCustomSnackBar("fail".tr, isError: false);
          }
          print(value);
        });
      } else {
        showCustomSnackBar("fail".tr, isError: true);
      }
    } else {
      if (trackingController.change == true) {
        if (_contentController.text != '') {
          trackingController
              .updateTracking(widget.tracking!, _contentController.text,
                  DateTime.fromMillisecondsSinceEpoch(widget.tracking!.date!))
              .then((value) {
            if (value == 200 || value == 201) {
              showCustomSnackBar("success".tr, isError: false);
            } else {
              showCustomSnackBar("fail".tr, isError: true);
            }
          });
        } else {
          showCustomFlash("fail".tr, context, isError: true);
        }
      }
      Get.offAllNamed(RouteHelper.home);
    }
  }

  Widget _selectDelete(TrackingController trackController) {
    return GestureDetector(
        onTap: () {
          showCustomConfirm(
            context,
            'do_you_want_to_delete?'.tr,
            () {
              trackController.deleteTracking(widget.tracking!).then((value) {
                if (value == 200 || value == 201) {
                  showCustomSnackBar("success".tr, isError: false);
                } else {
                  showCustomSnackBar("fail".tr, isError: true);
                }
              });
              Get.offAllNamed(RouteHelper.home);
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(8), // Khoảng cách giữa icon và viền tròn
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withOpacity(0.15), // Màu nền nhẹ
          ),
          child: Icon(
            Icons.delete,
            color: Colors.redAccent,
            size: 28,
          ),
        ));
  }

  Widget _selectDayTime(
    double width,
  ) {
    return Row(
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  picker.DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    locale:
                        Get.find<LocalizationController>().locale.toString() ==
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
                        doneStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                    onConfirm: (date) {
                      setState(() {
                        timeSelect = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          timeSelect.hour,
                          timeSelect.minute,
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
                      DateConverter.dateFormat.format(timeSelect),
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
                ),
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
                        timeSelect = DateTime(
                          timeSelect.year,
                          timeSelect.month,
                          timeSelect.day,
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
                      DateConverter.dateTimeFormat.format(timeSelect),
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
      ],
    );
  }
}
