import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoapp/pages/task_details_page.dart';
import 'package:todoapp/utils/styles.dart';
import 'package:todoapp/models/Task.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/widgets/no_glow_scroll.dart';

class CompletedTaskPage extends StatefulWidget {
  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  late TaskProvider _taskProvider;

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    var _listOfCompletedTask = _taskProvider.listOfCompletedTasks;

    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: AppBar(
          title: Text("Completed", style: Styles.headerText),
          elevation: 1,
          centerTitle: true,
          backgroundColor: Styles.primaryBaseColor,
        ),
        body: _listOfCompletedTask.isNotEmpty
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: StretchingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _listOfCompletedTask.length,
                        itemBuilder: (context, index) {
                          return listItems(_listOfCompletedTask[index], index);
                        }),
                  ),
                ))
            : Center(
                child: Text("No completed tasks", style: Styles.hintText)));
  }

  Widget listItems(Task curCompletedTask, int taskIndex) {
    return Dismissible(
      key: Key(curCompletedTask.hashCode.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) async {
        await _taskProvider.undoTask(curCompletedTask);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Undo completed'),
            duration: Duration(seconds: 1, milliseconds: 5)));
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
              Icon(Icons.undo_rounded, color: Styles.secondaryColor),
              const SizedBox(width: 5),
              Text(
                "Undo",
                style: TextStyle(color: Styles.secondaryColor, fontSize: 20),
              )
            ]),
      ),
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          // margin: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: ListTile(
            tileColor: Styles.cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            title: Text(
              curCompletedTask.taskTitle,
              style: Styles.titleText,
            ),
            subtitle: Text(
                "${curCompletedTask.taskDate} | ${curCompletedTask.taskTime}",
                style: Styles.subTitleText),
            trailing: Container(
              padding: const EdgeInsets.only(left: 2.0),
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(width: .5, color: Colors.white))),
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
                            task: curCompletedTask,
                            isCompletedPage: true,
                          ),
                        ));
                  },
                ),
              ),
            ),
          )),
    );
  }
}
