import 'package:get/get.dart';
import 'package:intl/intl.dart';

//lớp cung cấp các phương thức tiện ích cho việc định dạng và chuyê đổi giữa các định dạng ngày giờ
class DateConverter {
  static DateFormat dateIso8601Format =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static DateFormat dateIso8601Format2 =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
  static DateFormat dateTimeFormat = DateFormat("HH:mm:ss");
  static DateFormat dateTimeHourFormat = DateFormat("HH:mm");
  static DateFormat dateDayFormat = DateFormat("EEE dd/MM/yy");
  static DateFormat dateDay2Format = DateFormat("EEE dd/MM");
  static DateFormat dateDay3Format = DateFormat("HH:mm - dd/MM");
  static DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  static DateFormat dateMonthFormat = DateFormat("MMM yyyy");
  static DateFormat dateDayTimeFormat = DateFormat("EEE dd/MM/yy\nHH:mm:ss");

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(dateTime);
  }

  static String getFormattedTime() {
    DateTime now = DateTime.now();
    return DateFormat("yyyy-MM-dd HH_mm_ss.SSSSSS").format(now);
  }

  static String dateToTimeOnly(DateTime dateTime) {
    return DateFormat(_timeFormatter()).format(dateTime);
  }

  static String dateToDateAndTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String dateToDateAndTimeAm(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd ${_timeFormatter()}').format(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String isoStringToDateTimeString(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}')
        .format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('HH:mm').parse(time));
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static DateTime convertStringToDate(String dateString, DateFormat format) {
    return format.parse(dateString);
  }

  static bool isAvailable(String start, String end, {required DateTime time}) {
    DateTime currentTime;
    currentTime = time;
    DateTime start0 = start != null
        ? DateFormat('HH:mm').parse(start)
        : DateTime(currentTime.year);
    DateTime end0 = end != null
        ? DateFormat('HH:mm').parse(end)
        : DateTime(
            currentTime.year, currentTime.month, currentTime.day, 23, 59, 59);
    DateTime startTime = DateTime(currentTime.year, currentTime.month,
        currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month,
        currentTime.day, end0.hour, end0.minute, end0.second);
    if (endTime.isBefore(startTime)) {
      if (currentTime.isBefore(startTime) && currentTime.isBefore(endTime)) {
        startTime = startTime.add(const Duration(days: -1));
      } else {
        endTime = endTime.add(const Duration(days: 1));
      }
    }
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String _timeFormatter() {
    return
        // Get.find<SplashController>().configModel.timeformat == '24' ? 'HH:mm' :
        'hh:mm a';
  }

  static String convertFromMinute(int minMinute, int maxMinute) {
    int firstValue = minMinute;
    int secondValue = maxMinute;
    String type = 'min';
    if (minMinute >= 525600) {
      firstValue = (minMinute / 525600).floor();
      secondValue = (maxMinute / 525600).floor();
      type = 'year';
    } else if (minMinute >= 43200) {
      firstValue = (minMinute / 43200).floor();
      secondValue = (maxMinute / 43200).floor();
      type = 'month';
    } else if (minMinute >= 10080) {
      firstValue = (minMinute / 10080).floor();
      secondValue = (maxMinute / 10080).floor();
      type = 'week';
    } else if (minMinute >= 1440) {
      firstValue = (minMinute / 1440).floor();
      secondValue = (maxMinute / 1440).floor();
      type = 'day';
    } else if (minMinute >= 60) {
      firstValue = (minMinute / 60).floor();
      secondValue = (maxMinute / 60).floor();
      type = 'hour';
    }
    return '$firstValue-$secondValue ${type.tr}';
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('h:mm a | d-MMM-yyyy ').format(dateTime.toLocal());
  }
}
