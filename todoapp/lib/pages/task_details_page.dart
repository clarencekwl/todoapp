import 'package:flutter/material.dart';
import 'package:todoapp/models/Task.dart';
import 'package:todoapp/widgets/edit_task_widget.dart';
import 'package:todoapp/utils/styles.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskDetails extends StatefulWidget {
  final Task task;
  final bool isTaskPage;
  final bool isCompletedPage;

  const TaskDetails({
    Key? key,
    required this.task,
    this.isTaskPage = false,
    this.isCompletedPage = false,
  }) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late TaskProvider _taskProvider;

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    // final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: AppBar(elevation: 1, backgroundColor: Styles.primaryBaseColor),
        body: taskDetailsColumn());
  }

  Row displayDetails(IconData icon, String details) {
    return Row(children: [
      SizedBox(
          width: 60,
          child: Icon(
            icon,
            color: Styles.buttonColor,
          )),
      Flexible(child: Text(details, style: Styles.detailsText))
    ]);
  }

  ElevatedButton buildButton(String buttonText, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        widget.isTaskPage
            ? {
                _taskProvider.addTaskComplete(widget.task),
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Task marked as complete!'),
                    duration: Duration(seconds: 1, milliseconds: 5)))
              }
            : {
                _taskProvider.undoTask(widget.task),
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Undo completed'),
                    duration: Duration(seconds: 1, milliseconds: 5)))
              };
        Navigator.popUntil(
          context,
          ModalRoute.withName(Navigator.defaultRouteName),
        );
      },
      style: Styles.buttonStyle,
      icon: Icon(icon, size: 30, color: Styles.buttonTextColor),
      label: Text(
        buttonText,
        style: TextStyle(color: Styles.buttonTextColor, fontSize: 20),
      ),
    );
  }

  Widget taskDetailsColumn() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.task.taskTitle,
                    style: TextStyle(
                        fontFamily: "Inter",
                        color: Styles.secondaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(color: Styles.secondaryColor),
                const SizedBox(height: 20),
                displayDetails(Icons.date_range_rounded, widget.task.taskDate),
                const SizedBox(height: 20),
                displayDetails(
                    Icons.query_builder_rounded, widget.task.taskTime),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Styles.cardColor,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: widget.task.taskDetails.isEmpty
                          ? Text("No Details", style: Styles.hintText)
                          : Text(
                              widget.task.taskDetails,
                              style: Styles.detailsText,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              height: 50,
              width: Styles.kScreenWidth(context) * 0.2,
              child: widget.isCompletedPage
                  ? null
                  : ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor:
                                Styles.primaryBaseColor.withOpacity(1),
                            isScrollControlled: true,
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            builder: (context) => EditTask(task: widget.task));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.blueColor,
                        padding: EdgeInsets.zero,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child:
                              const Center(child: Icon(Icons.edit_outlined)))),
            ),
          ),
        ],
      ),
    );
  }
}
