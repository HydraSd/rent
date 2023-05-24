import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CalendarWid extends StatefulWidget {
  final Function(String?, String?) onDateRangeSelected;
  final Function navigateToUserDetailsScreen;

  const CalendarWid(
      {Key? key,
      required this.onDateRangeSelected,
      required this.navigateToUserDetailsScreen})
      : super(key: key);

  @override
  State<CalendarWid> createState() => _CalendarWidState();
}

class _CalendarWidState extends State<CalendarWid> {
  String? startDateF;
  String? endDateF;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  void handleDateRangeSelected() {
    widget.onDateRangeSelected(startDateF, endDateF);
    widget.navigateToUserDetailsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
      onPressed: () async {
        final DateTimeRange? dateTimeRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(3000),
        );
        if (dateTimeRange != null) {
          DateTime startDate = dateTimeRange.start;
          DateTime endDate = dateTimeRange.end;
          setState(() {
            startDateF = _dateFormat.format(startDate);
            endDateF = _dateFormat.format(endDate);
          });
          handleDateRangeSelected();
        }
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.calendar_month_outlined),
        const SizedBox(width: 10),
        Text(startDateF != null && endDateF != null
            ? "$startDateF - $endDateF"
            : "Choose a date"),
      ]),
    ));
  }
}
