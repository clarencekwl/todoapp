import 'package:flutter/material.dart';
import 'package:todoapp/utils/styles.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/widgets/no_glow_scroll.dart';

class CreateTask extends StatefulWidget {
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late TaskProvider _taskProvider;
  final TextEditingController _myControllerTitle = TextEditingController();
  final TextEditingController _myControllerDate = TextEditingController();
  final TextEditingController _myControllerTime = TextEditingController();
  final TextEditingController _myControllerDetails = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myControllerTitle.dispose();
    _myControllerDate.dispose();
    _myControllerTime.dispose();
    _myControllerDetails.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);
    return Scaffold(
        backgroundColor: Styles.primaryBaseColor,
        appBar: AppBar(
            title: Text("New Task", style: Styles.headerText),
            elevation: 1,
            backgroundColor: Styles.primaryBaseColor),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: createTaskForm(),
        ));
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

  Widget createTaskForm() {
    return Form(
      key: _formKey,
      onChanged: () {
        if (_myControllerTitle.text.isNotEmpty &&
            _myControllerDate.text.isNotEmpty &&
            _myControllerTime.text.isNotEmpty) {
          _isFormValid = true;
        } else {
          _isFormValid = false;
        }
        setState(() {});
      },
      child: Column(
        children: [
          // TASK TITLE
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (titleValue) {
                            if (titleValue!.isEmpty) {
                              return "Cannot be empty";
                            }
                            return null;
                          },
                          controller: _myControllerTitle,
                          cursorColor: Styles.secondaryColor,
                          decoration: Styles.inputTextFieldStyle("Title"),
                          style: Styles.userInputText),
                      const SizedBox(height: 40),
                      // TASK DATE
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: Styles.userInputText,
                        controller: _myControllerDate,
                        validator: (dateValue) {
                          if (dateValue!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: Styles.inputTextFieldStyle("Date"),
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
                                            foregroundColor:
                                                Styles.primaryBaseColor)),
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
                              _myControllerDate.text = formattedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      // TASK TIME
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: Styles.userInputText,
                        controller: _myControllerTime,
                        validator: (timeValue) {
                          if (timeValue!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: Styles.inputTextFieldStyle("Time"),
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
                                          foregroundColor:
                                              Styles.primaryBaseColor)),
                                ),
                                child: child!,
                              );
                            },
                            initialTime: const TimeOfDay(hour: 00, minute: 00),
                          );
                          if (pickedTime != null) {
                            final localizations =
                                MaterialLocalizations.of(context);
                            final formattedTimeOfDay =
                                localizations.formatTimeOfDay(pickedTime);
                            // DateTime parsedTime = DateFormat.jm()
                            //     .parse(pickedTime.format(context).toString());
                            // String formattedTime = DateFormat('HH:mm').format(parsedTime);
                            setState(() {
                              _myControllerTime.text = formattedTimeOfDay;
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
                            controller: _myControllerDetails,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            height: 50,
            width: Styles.kScreenWidth(context) * 0.9,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _taskProvider.addTask(
                      _myControllerTitle.text,
                      _myControllerDate.text,
                      _myControllerTime.text,
                      _myControllerDetails.text);
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  backgroundColor: _isFormValid
                      ? const Color.fromARGB(255, 31, 138, 81)
                      : Colors.grey,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(
                "Create",
                style: TextStyle(color: Styles.secondaryColor, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
