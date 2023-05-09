import 'package:flutter/material.dart';
import 'package:todoapp/models/Task.dart';
import 'package:todoapp/utils/styles.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/widgets/no_glow_scroll.dart';

class EditTask extends StatefulWidget {
  final Task task;

  const EditTask({Key? key, required this.task}) : super(key: key);
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TaskProvider _taskProvider;
  final TextEditingController myControllerTitle = TextEditingController();
  final TextEditingController myControllerDate = TextEditingController();
  final TextEditingController myControllerTime = TextEditingController();
  final TextEditingController myControllerDetails = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DraggableScrollableController _bottomSheetController =
      DraggableScrollableController();

  @override
  void initState() {
    myControllerTitle.text = widget.task.taskTitle;
    myControllerDetails.text = widget.task.taskDetails;
    myControllerDate.text = widget.task.taskDate;
    myControllerTime.text = widget.task.taskTime;

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerDetails.dispose();
    myControllerDate.dispose();
    myControllerTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of(context);

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: -10,
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)),
              )),
          AnimatedPadding(
            padding: const EdgeInsets.all(20),
            duration: const Duration(milliseconds: 5),
            curve: Curves.easeInOut,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.65,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              controller: _bottomSheetController,
              builder: (context, scrollController) =>
                  editTaskForm(scrollController),
            ),
          ),
        ]);
  }

  Widget editTaskForm(ScrollController scrollController) {
    return Form(
      key: _formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TASK TITLE
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (titleValue) {
                              if (titleValue!.isEmpty) {
                                return "Cannot be empty";
                              }
                              return null;
                            },
                            controller: myControllerTitle,
                            cursorColor: Styles.secondaryColor,
                            decoration: Styles.inputTextFieldStyle("Title"),
                            style: Styles.userInputText),
                        const SizedBox(height: 20),
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
                                myControllerDate.text = formattedDate;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
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
                              initialTime:
                                  const TimeOfDay(hour: 00, minute: 00),
                            );
                            if (pickedTime != null) {
                              final localizations =
                                  MaterialLocalizations.of(context);
                              final formattedTime =
                                  localizations.formatTimeOfDay(pickedTime);
                              // DateTime parsedTime = DateFormat.jm()
                              //     .parse(pickedTime.format(context).toString());
                              // String formattedTime = DateFormat('HH:mm').format(parsedTime);
                              setState(() {
                                myControllerTime.text = formattedTime;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 25),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 50,
            width: Styles.kScreenWidth(context) * 0.9,
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
                        duration: Duration(seconds: 1, milliseconds: 5)));
                  }
                });
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
          )
        ],
      ),
    );
  }
}
