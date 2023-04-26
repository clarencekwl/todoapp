import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/pages/task_page.dart';
import 'package:todoapp/providers/task_provider.dart';

void main() {
  runApp(
    TodoApp(),
  );
}

class TodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskPage(),
      ),
    );
  }
}
