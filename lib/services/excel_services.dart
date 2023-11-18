import 'dart:math';

import 'package:excel/excel.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:tomflutter_catatan/models/task.dart';

Future<void> exportTasksToExcel(List<Task> tasks) async {
  List<String> colors = ["primaryColor", "red", "yellow", "black"];
  List<String> isComplete = ["Pending", "Completed"];

  // Create a new Excel file
  var excel = Excel.createExcel();

  // Access the 'Sheet1'
  Sheet sheet = excel['Sheet1'];

  // Column headers
  List<String> headers = [
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
  ];
  sheet.appendRow(headers);

  // If you have a list of tasks, convert each task to a list and add it to the rows
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
    sheet.appendRow(row);
  }

  // Save the Excel file
  final directory = await getTemporaryDirectory();
  final path = directory.path;
  final file = File('$path/tasks.xlsx');
  await file.writeAsBytes(excel.save() ?? <int>[]);

  var rand = Random();
  int randomNumber = rand.nextInt(50);

  final params = SaveFileDialogParams(
    sourceFilePath: file.path,
    localOnly: true,
    fileName: "Tasks$randomNumber.xlsx",
  );

  await FlutterFileDialog.saveFile(params: params);
}
