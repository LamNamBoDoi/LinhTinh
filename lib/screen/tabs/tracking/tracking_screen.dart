import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/screen/tabs/tracking/widget/fill_tracking_widget.dart';
import 'package:timesheet/screen/tabs/tracking/widget/select_day_widget.dart';
import 'package:timesheet/screen/tabs/tracking/widget/select_delete_widget.dart';
import 'package:timesheet/utils/dimensions.dart';

class TrackingScreen extends StatefulWidget {
  TrackingScreen({super.key, this.update, this.tracking});
  final bool? update;
  final Tracking? tracking;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _contentController = TextEditingController();
  DateTime timeSelect = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          centerTitle: true,
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
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GetBuilder<TrackingController>(
            initState: (state) {
              _contentController.text = widget.tracking?.content ?? '';
            },
            builder: (trackController) {
              if (trackController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectDayWidget(
                        width: width,
                        timeSelect: timeSelect,
                        onTimeChanged: (newTime) {
                          setState(() {
                            timeSelect = newTime;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FillTrackingWidget(
                        formKey: _formKey,
                        contentController: _contentController,
                        timeSelect: timeSelect,
                        tracking: widget.tracking,
                        trackingController: trackController,
                        update: widget.update ?? false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.update == true
                              ? SelectDeleteWidget(
                                  trackingController: trackController,
                                  tracking: widget.tracking)
                              : const SizedBox(),
                        ],
                      ),
                    ]),
              );
            },
          ),
        ));
  }
}
