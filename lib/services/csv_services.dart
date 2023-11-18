import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:tomflutter_catatan/models/task.dart';

Future<void> exportTasksToCSV(List<Task> tasks) async {
  List<List<dynamic>> rows = <List<dynamic>>[];

  // Column headers
  rows.add([
    "Id",
    "Title",
    "Note",
    "Date",
    "StartTime",
    "EndTime",
    "Remind",
    "Repeat",
    "Color",
    "isCompleted",
    "createdAt",
    "updatedAt"
  ]);

  // If you have a list of tasks, convert each task to a list and add it to the rows
  List<String> colors = [
    "bluishColor",
    "pinkColor",
    "yellowishColor",
    "greenColor"
  ];

  List<String> isComplete = ["Pending", "Completed"];

  for (Task task in tasks) {
    List<dynamic> row = [];
    row.add(task.id);
    row.add(task.title);
    row.add(task.note);
    row.add(task.date);
    row.add(task.startTime);
    row.add(task.endTime);
    row.add(task.remind);
    row.add(task.repeat);
    row.add(colors[task.color ?? 0]);
    row.add(isComplete[task.isCompleted ?? 0]);
    row.add(task.createdAt);
    row.add(task.updatedAt);
    rows.add(row);
  }

  // Convert rows to CSV
  String csv = const ListToCsvConverter().convert(rows);

  // Write to a temporary file
  final directory = await getTemporaryDirectory();
  final path = directory.path;
  final file = File('$path/tasks.csv');
  await file.writeAsString(csv);

  var rand = Random();
  int randomNumber = rand.nextInt(50);

  final params = SaveFileDialogParams(
    sourceFilePath: file.path,
    localOnly: true,
    fileName: 'Tasks$randomNumber.csv',
  );

  await FlutterFileDialog.saveFile(params: params);
}
