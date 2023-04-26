import 'package:flutter/material.dart';
// import 'package:todoapp/pages/edit_task_page.dart';
import 'package:todoapp/models/Task.dart';
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
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late TaskProvider _taskProvider;

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    // final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final AppBar topAppBar = AppBar(
      elevation: 1,
      backgroundColor: Styles.primaryBaseColor,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => EditPage(
              //               task: widget.task,
              //             )));
            },
            icon: const Icon(Icons.edit_outlined),
            iconSize: 40),
        const SizedBox(width: 10)
      ],
    );

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
                      duration: Duration(seconds: 2)))
                }
              : {
                  _taskProvider.undoTask(widget.task),
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Undo completed'),
                      duration: Duration(seconds: 2)))
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

    Widget mainPage = Container(
      padding: const EdgeInsets.all(20),
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
          displayDetails(Icons.query_builder_rounded, widget.task.taskTime),
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
                child: widget.task.taskDetails.isEmpty
                    ? Text("No Details", style: Styles.hintText)
                    : Text(
                        widget.task.taskDetails,
                        style: Styles.detailsText,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                height: 50,
                child: widget.isCompletedPage
                    ? buildButton("Undo Complete", Icons.undo_rounded)
                    : buildButton("Complete", Icons.check_rounded)),
          )
        ],
      ),
    );

    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: widget.isTaskPage
            ? topAppBar
            : AppBar(elevation: 1, backgroundColor: Styles.primaryBaseColor),
        body: mainPage);
  }
}
