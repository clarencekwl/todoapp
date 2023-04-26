import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/Task.dart';
import 'package:todoapp/pages/create_task_page.dart';
import 'package:todoapp/pages/task_details_page.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/utils/styles.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _isSelectionMode = false;
  late TaskProvider _taskProvider;
  bool _sortTitle = false;

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: topAppBar(),
        body: _taskProvider.listOfTasks.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                    itemCount: _taskProvider.listOfTasks.length,
                    itemBuilder: (context, index) {
                      return listItems(_taskProvider.listOfTasks[index], index);
                    }))
            : Center(child: Text("No ongoing tasks", style: Styles.hintText)));
  }

  Widget deletePopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure? "),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.report_gmailerrorred_rounded,
              size: 60,
              color: Colors.redAccent,
            ),
            SizedBox(height: 10),
            Text("Action cannot be undone")
          ]),
      actions: [
        TextButton(
          onPressed: () {
            _taskProvider.removeTasks();
            Navigator.of(context).pop();
          },
          child: const Text(
            "DELETE",
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "CANCEL",
          ),
        )
      ],
    );
  }

  AppBar topAppBar() {
    return AppBar(
        title: Text("Tasks", style: Styles.headerText),
        leading: _isSelectionMode && _taskProvider.listOfTasks.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    _taskProvider.resetSelected();
                    _isSelectionMode = false;
                  });
                },
              )
            : null,
        actions: <Widget>[
          Row(
            children: [
              !_isSelectionMode || _taskProvider.listOfTasks.isEmpty
                  ? Row(
                      children: [
                        // if (_taskProvider.listOfTasks.length > 1)
                        //   TextButton(
                        //     onPressed: () {
                        //       showModalBottomSheet(
                        //           backgroundColor: Styles.cardColor,
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(20)),
                        //           context: context,
                        //           builder: (BuildContext context) {
                        //             return Container(
                        //                 padding: const EdgeInsets.all(10),
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   mainAxisSize: MainAxisSize.max,
                        //                   children: <Widget>[
                        //                     const ListTile(
                        //                         title: Text("Sort by:",
                        //                             style: TextStyle(
                        //                                 color: Colors.grey,
                        //                                 fontWeight:
                        //                                     FontWeight.bold))),
                        //                     InkWell(
                        //                       onTap: () {
                        //                         setState(() {
                        //                           _sortDate = false;
                        //                           _sortTitle = true;
                        //                         });
                        //                       },
                        //                       child: ListTile(
                        //                           title: Text("Title",
                        //                               style: TextStyle(
                        //                                   color: Styles
                        //                                       .secondaryColor,
                        //                                   fontWeight:
                        //                                       FontWeight.bold)),
                        //                           trailing: _sortTitle
                        //                               ? Icon(
                        //                                   Icons.check_rounded,
                        //                                   color:
                        //                                       Styles.blueColor,
                        //                                 )
                        //                               : null),
                        //                     ),
                        //                     InkWell(
                        //                       onTap: () {
                        //                         setState(() {
                        //                           _sortTitle = false;
                        //                           _sortDate = true;
                        //                         });
                        //                       },
                        //                       child: ListTile(
                        //                           title: Text("Date",
                        //                               style: TextStyle(
                        //                                   color: Styles
                        //                                       .secondaryColor,
                        //                                   fontWeight: FontWeight
                        //                                       .bold))),
                        //                     ),
                        //                   ],
                        //                 ));
                        //           });
                        //     },
                        //     child: Text(
                        //       "Sort",
                        //       style: Styles.titleText,
                        //     ),
                        //     // child: DropdownButtonHideUnderline(
                        //     //   child: DropdownButton(
                        //     //       dropdownColor: Styles.cardColor,
                        //     //       style: Styles.titleText,
                        //     //       items: _sortItems,
                        //     //       hint: Text(
                        //     //         "Sort",
                        //     //         style: Styles.titleText,
                        //     //       ),
                        //     //       icon: Icon(
                        //     //         Icons.arrow_drop_down_rounded,
                        //     //         color: Styles.secondaryColor,
                        //     //       ),
                        //     //       onChanged: (String? newSelected) {
                        //     //         setState(() {
                        //     //           _selectedValue != newSelected
                        //     //               ? _selectedValue = newSelected!
                        //     //               : _selectedValue = "";
                        //     //           switch (_selectedValue) {
                        //     //             case "Title":
                        //     //               _taskProvider.sortByTitle();
                        //     //               break;
                        //     //             case "Date":
                        //     //               _taskProvider.sortByDate();
                        //     //               break;
                        //     //             default:
                        //     //               break;
                        //     //           }
                        //     //         });
                        //     //       }),
                        //     // ),
                        //   ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateTask()));
                            },
                            icon: const Icon(Icons.add_rounded),
                            iconSize: 40),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                deletePopupDialog(context));
                      },
                      icon: const Icon(Icons.delete_outlined),
                      iconSize: 35,
                    ),
              const SizedBox(width: 10)
            ],
          )
        ],
        elevation: 1,
        backgroundColor: Styles.primaryBaseColor);
  }

  Widget listItems(Task curTask, int taskIndex) {
    return Dismissible(
      key: Key(curTask.taskTitle),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          _taskProvider.addTaskComplete(curTask);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task marked as complete'),
              duration: Duration(seconds: 2)));
        });
      },
      background: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 31, 138, 81),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_rounded, color: Styles.secondaryColor),
              const SizedBox(width: 5),
              Text(
                "Complete",
                style: TextStyle(color: Styles.secondaryColor, fontSize: 20),
              )
            ]),
      ),
      child: Card(
        elevation: 5,
        child: ListTile(
            tileColor: Styles.cardColor,
            shape: curTask.selected
                ? const BeveledRectangleBorder(
                    side: BorderSide(
                        color: Color.fromARGB(122, 34, 185, 250), width: 2))
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              curTask.taskTitle,
              style: Styles.titleText,
            ),
            onLongPress: () {
              _taskProvider.setSelection(true, curTask);
              setState(() {
                _isSelectionMode = true;
              });
            },
            subtitle: Text("${curTask.taskDate} | ${curTask.taskTime}",
                style: Styles.subTitleText),
            trailing: !_isSelectionMode
                ? Container(
                    padding: const EdgeInsets.only(left: 2.0),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                width: .5, color: Styles.buttonColor))),
                    child: SizedBox(
                        width: 30,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.keyboard_arrow_right_rounded),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetails(
                                    task: curTask,
                                    isTaskPage: true,
                                  ),
                                ));
                          },
                        )))
                : Checkbox(
                    activeColor: Styles.blueColor,
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    value: curTask.selected,
                    onChanged: (value) {
                      _taskProvider.setSelection(value!, curTask);
                    })),
      ),
    );
  }
}
