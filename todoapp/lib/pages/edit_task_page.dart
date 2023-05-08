import 'package:flutter/material.dart';
import 'package:todoapp/models/Task.dart';
import 'package:todoapp/utils/styles.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final Task task;

  const EditPage({Key? key, required this.task}) : super(key: key);
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TaskProvider _taskProvider;
  final TextEditingController myControllerTitle = TextEditingController();
  final TextEditingController myControllerDate = TextEditingController();
  final TextEditingController myControllerTime = TextEditingController();
  final TextEditingController myControllerDetails = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerDate.dispose();
    myControllerTime.dispose();
    myControllerDetails.dispose();
    super.dispose();
  }

  @override
  void initState() {
    myControllerTitle.text = widget.task.taskTitle;
    myControllerDetails.text = widget.task.taskDetails;
    myControllerDate.text = widget.task.taskDate;
    myControllerTime.text = widget.task.taskTime;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var _taskProvider = context.watch<TaskProvider>();
    _taskProvider = Provider.of(context);
    // final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    // myControllerTitle.text = args.getTask.getTaskTitle;
    // myControllerDate.text = args.getTask.getTaskDate;
    // myControllerTime.text = args.getTask.getTaskTime;
    // myControllerDetails.text = args.getTask.getTaskDetail;

    final AppBar topAppBar = AppBar(
        title: Text("Edit", style: Styles.headerText),
        elevation: 1,
        backgroundColor: Styles.primaryBaseColor);

    Widget mainPage = Form(
      key: _formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TASK TITLE
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (titleValue) {
                if (titleValue!.isEmpty) {
                  return "Cannot be empty";
                }
                return null;
              },
              controller: myControllerTitle,
              cursorColor: Styles.secondaryColor,
              decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: Styles.titleText,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Styles.secondaryColor))),
              style: Styles.userInputText),
          const SizedBox(height: 40),
          // TASK DATE
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: Styles.userInputText,
            controller: myControllerDate,
            validator: (dateValue) {
              if (dateValue!.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Date",
                labelStyle: Styles.titleText,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Styles.secondaryColor))),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                            primary: Styles.primaryBaseColor,
                            onPrimary: Styles.secondaryColor,
                            onSurface: Colors.black),
                        textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                                foregroundColor: Styles.primaryBaseColor)),
                      ),
                      child: child!,
                    );
                  },
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat.yMMMMd('en_US').format(pickedDate);
                setState(() {
                  myControllerDate.text = formattedDate;
                });
              }
            },
          ),
          const SizedBox(height: 40),
          // TASK TIME
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: Styles.userInputText,
            controller: myControllerTime,
            validator: (timeValue) {
              if (timeValue!.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Time",
                labelStyle: Styles.titleText,
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                          primary: Styles.primaryBaseColor,
                          onPrimary: Styles.secondaryColor,
                          onSurface: Colors.black),
                      textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                              foregroundColor: Styles.primaryBaseColor)),
                    ),
                    child: child!,
                  );
                },
                initialTime: const TimeOfDay(hour: 00, minute: 00),
              );
              if (pickedTime != null) {
                final localizations = MaterialLocalizations.of(context);
                final formattedTime = localizations.formatTimeOfDay(pickedTime);
                // DateTime parsedTime = DateFormat.jm()
                //     .parse(pickedTime.format(context).toString());
                // String formattedTime = DateFormat('HH:mm').format(parsedTime);
                setState(() {
                  myControllerTime.text = formattedTime;
                });
              }
            },
          ),
          const SizedBox(height: 40),
          // TASK DETAILS
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Styles.cardColor,
              ),
              child: TextFormField(
                minLines: 10,
                maxLines: null,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: 'Enter task details',
                    hintStyle: Styles.hintText,
                    border: InputBorder.none),
                style: Styles.userInputText,
                controller: myControllerDetails,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      _taskProvider.editTask(
                          widget.task,
                          myControllerTitle.text,
                          myControllerDate.text,
                          myControllerTime.text,
                          myControllerDetails.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Successfully edited!'),
                          duration: Duration(seconds: 2)));
                    }
                  });

                  // _errorText() == ""
                  //     ? {
                  //         _taskProvider.addTask(
                  //             myControllerTitle.text,
                  //             myControllerDate.text,
                  //             myControllerTime.text,
                  //             myControllerDetails.text),
                  //         Navigator.popUntil(context,
                  //             ModalRoute.withName(Navigator.defaultRouteName)),
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //             const SnackBar(
                  //                 content: Text('Successfully added!')))
                  //       }
                  //     : showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) =>
                  //             errorPopupDialog(context));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    backgroundColor: const Color.fromARGB(255, 31, 138, 81),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                icon: Icon(
                  Icons.edit_rounded,
                  color: Styles.secondaryColor,
                  size: 20,
                ),
                label: Text(
                  "Edit",
                  style: TextStyle(color: Styles.secondaryColor, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: topAppBar,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20), child: mainPage));
  }
}
