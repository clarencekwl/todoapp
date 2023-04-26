import 'package:flutter/material.dart';

class Task {
  String taskTitle;
  String taskDate;
  String taskTime;
  String taskDetails;
  bool selected;

  Task(
      {required this.taskTitle,
      required this.taskDate,
      required this.taskTime,
      required this.taskDetails,
      required this.selected});
}
