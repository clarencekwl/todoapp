import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoapp/models/Task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _listOfTasks = [];

  List<Task> get listOfTasks => _listOfTasks;

  void addTask(String title, String date, String time, String details) {
    _listOfTasks.add(Task(
        taskTitle: title,
        taskDate: date,
        taskTime: time,
        taskDetails: details,
        selected: false));
    notifyListeners();
  }

  void removeTasks() {
    _listOfTasks.removeWhere((task) => task.selected);
    notifyListeners();
  }

  void setSelection(bool value, Task task) {
    _listOfTasks[_listOfTasks.indexOf(task)].selected = value;
    notifyListeners();
  }

  void undoTask(Task task) {
    _listOfTasks.add(task);
    completedtasksList.remove(task);
    notifyListeners();
  }

  void resetSelected() {
    for (Task task in _listOfTasks) {
      task.selected = false;
    }
    notifyListeners();
  }

  List<Task> completedtasksList = [];
  void addTaskComplete(Task completedTask) {
    if (_listOfTasks.contains(completedTask)) {
      completedtasksList.add(completedTask);
      _listOfTasks.remove(completedTask);
      notifyListeners();
    }
  }

  void editTask(
      Task task, String title, String date, String time, String details) {
    _listOfTasks[_listOfTasks.indexOf(task)].taskTitle = title;
    _listOfTasks[_listOfTasks.indexOf(task)].taskDate = date;
    _listOfTasks[_listOfTasks.indexOf(task)].taskTime = time;
    _listOfTasks[_listOfTasks.indexOf(task)].taskDetails = details;
    notifyListeners();
  }

  List<Task> originalTaskList = [];
  void sortByTitle() {
    originalTaskList = _listOfTasks;
    _listOfTasks.sort(((a, b) => a.taskTitle.compareTo(b.taskTitle)));
    log(_listOfTasks[0].taskTitle);
    notifyListeners();
  }

  void sortByDate() {
    originalTaskList = _listOfTasks;
    _listOfTasks.sort(((a, b) => a.taskDate.compareTo(b.taskDate)));
    log(_listOfTasks[0].taskTitle);
    notifyListeners();
  }

  void getOriginalList() {}
}
