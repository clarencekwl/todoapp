import 'package:flutter/material.dart';
import 'package:todoapp/utils/styles.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late TaskProvider _taskProvider;
  final TextEditingController myControllerTitle = TextEditingController();
  final TextEditingController myControllerDate = TextEditingController();
  final TextEditingController myControllerTime = TextEditingController();
  final TextEditingController myControllerDetails = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AppBar _topAppBar = AppBar(
      title: Text("New Task", style: Styles.headerText),
      elevation: 1,
      backgroundColor: Styles.primaryBaseColor);

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
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: _topAppBar,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20), child: mainPage()));
  }

  // String _errorText() {
  //   final fieldTitle = myControllerTitle.text;
  //   final fieldDate = myControllerDate.text;
  //   final fieldTime = myControllerTime.text;
  //   var message = "";
  //   if (fieldTitle.isEmpty) {
  //     message = "$message Title\n";
  //   }
  //   if (fieldDate.isEmpty) {
  //     message = "$message Date\n";
  //   }
  //   if (fieldTime.isEmpty) {
  //     message = "$message Time\n";
  //   }
  //   return message;
  // }

  // POPUP DIAGLOG
  // Widget errorPopupDialog(BuildContext context) {
  //   return AlertDialog(
  //     title: const Text("Please fill in required fields: "),
  //     content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [Text(_errorText())]),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         child: const Text(
  //           "OK",
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget mainPage() {
    return Form(
      key: _formKey,
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
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
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
                final formattedTimeOfDay =
                    localizations.formatTimeOfDay(pickedTime);
                // DateTime parsedTime = DateFormat.jm()
                //     .parse(pickedTime.format(context).toString());
                // String formattedTime = DateFormat('HH:mm').format(parsedTime);
                setState(() {
                  myControllerTime.text = formattedTimeOfDay;
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
                  if (_formKey.currentState!.validate()) {
                    _taskProvider.addTask(
                        myControllerTitle.text,
                        myControllerDate.text,
                        myControllerTime.text,
                        myControllerDetails.text);
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Successfully added!'),
                        duration: Duration(seconds: 2)));
                  }
                  // _errorText() == ""
                  //     ? {
                  //         appState.addTask(
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
                  Icons.add_rounded,
                  color: Styles.secondaryColor,
                  size: 30,
                ),
                label: Text(
                  "Create",
                  style: TextStyle(color: Styles.secondaryColor, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
