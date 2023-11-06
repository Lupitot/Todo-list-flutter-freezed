import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/add_task_dialog.dart';
import 'package:todo_app_sqlite_freezed/models/todo_model.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mytheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 25, 55, 191),
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 27,
          color: Color.fromARGB(255, 200, 200, 200),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(223, 32, 142, 34)),
        ),
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mytheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
          child: FutureBuilder<List<Todo>>(
              future: databaseHelper.getAllTodos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                }
                return Column(
                  children: [
                    Padding(padding: EdgeInsets.all(30)),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final todo = snapshot.data![index];
                          return Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(255, 121, 121, 121),
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                                title: Text(todo.task),
                                trailing: Icon(
                                  todo.isCompleted == 1
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                ),
                                tileColor: todo.isCompleted == 1
                                    ? Color.fromARGB(170, 32, 142, 34)
                                    : Color.fromARGB(170, 178, 33, 33),
                                onTap: () async {
                                  await databaseHelper.update(
                                    todo.copyWith(
                                      isCompleted:
                                          todo.isCompleted == 1 ? 0 : 1,
                                    ),
                                  );
                                  setState(() {});
                                },
                                leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await databaseHelper.delete(todo.id!);
                                    setState(() {});
                                  },
                                )),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final String? myNewTaskName =
                              await showDialog<String?>(
                                  context: context,
                                  builder: (buildcontext) => AddTaskDialog());

                          if (myNewTaskName == null) return;
                          await databaseHelper.insert(
                            Todo(
                              task: myNewTaskName,
                              isCompleted: 0,
                            ),
                          );
                          setState(() {});
                        },
                        child: Text(
                          'Add new task',
                          style: Theme.of(context).textTheme.displayLarge,
                        )),
                    Padding(padding: EdgeInsets.all(30)),
                  ],
                );
              })),
    );
  }
}
