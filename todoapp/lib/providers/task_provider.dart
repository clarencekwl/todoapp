import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoapp/models/Task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _listOfTasks = [];
  List<Task> get listOfTasks => _listOfTasks;
  set listOfTasks(List<Task> listOfTasks) {
    _listOfTasks = listOfTasks;
  }

  List<Task> _listOfCompletedTasks = [];
  List<Task> get listOfCompletedTasks => _listOfCompletedTasks;
  set listOfCompletedTasks(List<Task> listOfCompletedTasks) {
    _listOfCompletedTasks = listOfCompletedTasks;
  }

  int _numberOfSelected = 0;
  int get numberOfSelected => _numberOfSelected;
  set numberOfSelected(int numberOfSelected) {
    _numberOfSelected = numberOfSelected;
    notifyListeners();
  }

  bool _selectionMode = false;
  bool get selectionMode => _selectionMode;
  set selectionMode(bool selectionMode) {
    _selectionMode = selectionMode;
    notifyListeners();
  }

  void addTask(String title, String date, String time, String details) {
    _listOfTasks.add(Task(
        taskTitle: title,
        taskDate: date,
        taskTime: time,
        taskDetails: details,
        selected: false));
    notifyListeners();
  }

  Future<void> removeTasks() async {
    _listOfTasks.removeWhere((task) => task.selected);
    notifyListeners();
  }

  void setSelection(bool value, Task task) {
    _listOfTasks[_listOfTasks.indexOf(task)].selected = value;
    if (false == value) {
      _numberOfSelected--;
      if (_numberOfSelected == 0) {
        _selectionMode = false;
      }
    } else {
      _selectionMode = true;
      _numberOfSelected++;
    }
    notifyListeners();
  }

  void resetSelected() {
    for (Task task in _listOfTasks) {
      task.selected = false;
    }
    _selectionMode = false;
    _numberOfSelected = 0;
    notifyListeners();
  }

  Future<void> undoTask(Task task) async {
    _listOfTasks.add(task);
    await _listOfCompletedTasks.remove(task);
    notifyListeners();
  }

  Future<void> addTaskComplete(Task completedTask) async {
    if (_listOfTasks.contains(completedTask)) {
      _listOfCompletedTasks.add(completedTask);
      await _listOfTasks.remove(completedTask);
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
