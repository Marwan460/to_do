import 'package:intl/intl.dart';

extension TimeExtention on DateTime {
  String get toFormattedDate{
    DateFormat formatter = DateFormat("dd/MM/yyyy");
    return formatter.format(this);
  }

  String get dayName {
    List<String> days = ["Mon","Tue","Wed","Thurs","Fri","Sat","Sun"];
    return days[weekday - 1];
  }
}