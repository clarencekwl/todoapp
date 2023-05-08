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
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _isSelectionMode = false;
  late TaskProvider _taskProvider;

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: Styles.primaryBaseColor,
      appBar: AppBar(
          title: Text("Tasks", style: Styles.headerText),
          centerTitle: true,
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
                if (_isSelectionMode && _taskProvider.listOfTasks.isNotEmpty)
                  IconButton(
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
          backgroundColor: Styles.primaryBaseColor),
      body: _taskProvider.listOfTasks.isNotEmpty
          ? GestureDetector(
              onTap: () {
                _taskProvider.resetSelected();
                _isSelectionMode = false;
                setState(() {});
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: ListView.builder(
                      itemCount: _taskProvider.listOfTasks.length,
                      itemBuilder: (context, index) {
                        return listItems(
                            _taskProvider.listOfTasks[index], index);
                      })),
            )
          : Center(child: Text("No ongoing tasks", style: Styles.hintText)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.blueColor,
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTask()));
        },
      ),
    );
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
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        // margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 31, 138, 81),
            borderRadius: BorderRadius.all(Radius.circular(15))),
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
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        // margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: ListTile(
            tileColor: Styles.cardColor,
            shape: curTask.selected
                ? RoundedRectangleBorder(
                    side: BorderSide(color: Styles.blueColor, width: 2),
                    borderRadius: BorderRadius.circular(15))
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetails(
                      task: curTask,
                      isTaskPage: true,
                    ),
                  ));
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
                    child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        width: 30,
                        child: const Icon(
                          (Icons.keyboard_arrow_right_rounded),
                          size: 30,
                          color: Colors.white,
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
