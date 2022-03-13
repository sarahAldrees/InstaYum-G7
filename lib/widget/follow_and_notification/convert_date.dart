import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConvertDate {
  /// get Time Difference From Now
  static String getTimeDifferenceFromNow(Timestamp? timestamp) {
    if (timestamp == null) return "";

    DateTime now = DateTime.now();
    DateTime dateTime = timestamp.toDate();
    Duration difference = now.difference(dateTime);
    if (difference.inSeconds < 5) {
      return "now";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds}s";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d";
    } else if (difference.inDays >= 7 && difference.inDays < 30) {
      return "${difference.inDays ~/ 7}w";
    } else {
      return "${DateFormat("dd/MM/yy").format(dateTime)}";
    }
  }

  /// Convert and Format Date from TimeStamp
  static String? formatDate(DateTime? date, {String format = 'yMMMd'}) {
    if (date == null) return null;

    // DateTime? _dateTime = date.toDate();
    DateFormat formatter = DateFormat(format);
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  /// Format date to time
  static String? formatTime(String? time) {
    DateTime? _datetime = convertToDateTime(time);
    if (_datetime == null) return null;
    DateFormat formatter = DateFormat('HH:mm');
    String formattedTime = formatter.format(_datetime);
    return formattedTime;
  }

  /// Convert string to date time
  static DateTime? convertToDateTime(String? date) {
    if (date == null) return null;
    DateTime dateTime = DateTime.parse(date);
    return dateTime;
  }
}
