import 'dart:io';
import 'dart:math';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tomflutter_catatan/models/task.dart';

Future<void> exportTasksToPDF(List<Task> tasks) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      header: (context) => pw.Center(
        child: pw.Header(
          level: 0,
          child: pw.Text('ToDo List PDF',
              style:
                  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        ),
      ),
      build: (context) =>
          tasks.map((task) => _buildTaskRow(context, task)).toList(),
    ),
  );

  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/tasks.pdf');
  await file.writeAsBytes(await pdf.save());

  var rand = Random();
  int randomNumber = rand.nextInt(50);

  final params = SaveFileDialogParams(
    sourceFilePath: file.path,
    localOnly: true,
    fileName: "Tasks$randomNumber.pdf",
  );

  await FlutterFileDialog.saveFile(params: params);
}

pw.Widget _buildTaskRow(pw.Context context, Task task) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(5.0),
    child: pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Text('ID:'),
            pw.Text(task.id.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Title:'),
            pw.Text(task.title),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Note:'),
            pw.Text(task.note),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Date:'),
            pw.Text(task.date.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Start Time:'),
            pw.Text(task.startTime.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('End Time:'),
            pw.Text(task.endTime.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Remind:'),
            pw.Text(task.remind.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Repeat:'),
            pw.Text(task.repeat.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Color:'),
            pw.Text(task.color.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('isCompleted:'),
            pw.Text(task.isCompleted.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('createdAt:'),
            pw.Text(task.createdAt.toString()),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('updatedAt:'),
            pw.Text(task.updatedAt.toString()),
          ],
        ),
      ],
    ),
  );
}
