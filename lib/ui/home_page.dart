// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tomflutter_catatan/controllers/device_info.dart';
import 'package:tomflutter_catatan/controllers/task.controller.dart';
import 'package:tomflutter_catatan/models/task.dart';
import 'package:tomflutter_catatan/services/csv_services.dart';
import 'package:tomflutter_catatan/services/excel_services.dart';
import 'package:tomflutter_catatan/services/notification_services.dart';
import 'package:tomflutter_catatan/services/pdf_services.dart';
import 'package:tomflutter_catatan/services/theme_services.dart';
import 'package:tomflutter_catatan/theme/theme.dart';
import 'package:tomflutter_catatan/ui/add_task_bar.dart';
import 'package:tomflutter_catatan/ui/widgets/button.dart';
import 'package:tomflutter_catatan/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> filterTaskList = [];

  var notifyHelper;
  String? deviceName;
  bool shorted = false;

  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();

    filterTaskList = _taskController.taskList;
    DeviceInfo deviceInfo = DeviceInfo();
    deviceInfo.getDeviceName().then((value) {
      setState(() {
        deviceName = value;
      });
    });

    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestAndroidPermissions();
  }

  // Sorting function
  List<Task> _shortNotesByModifiedDate(List<Task> taskList) {
    taskList.sort((a, b) => a.updatedAt!.compareTo(b.updatedAt!));

    if (shorted) {
      taskList = List.from(taskList.reversed);
    } else {
      taskList = List.from(taskList.reversed);
    }

    shorted = !shorted;

    return taskList;
  }

  @override
  Widget build(BuildContext context) {
    // print(filterTaskList[0].updatedAt);
    return GetBuilder<ThemeServices>(
      init: ThemeServices(),
      builder: (themeServices) => Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _appBar(themeServices),
        body: Column(
          children: [
            _addTaskBar(),
            _dateBar(),
            const SizedBox(height: 10),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("EEE, d MMM yyyy").format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
            MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              },
            )
          ],
        ));
  }

  AppBar _appBar(ThemeServices themeServices) {
    return AppBar(
      systemOverlayStyle: Get.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          themeServices.switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Light Theme Activated"
                  : "Dark Theme Activated");
          // notifyHelper.scheduledNotification();
        },
        child: themeServices.icon,
      ),
      actions: [
        // const CircleAvatar(
        //   backgroundImage: AssetImage("images/avatar.png"),
        // ),
        InputChip(
          padding: const EdgeInsets.all(0),
          label: Text(
            deviceName ?? "Unknown",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          onPressed: () {},
        ),
        IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              // Sort the taskList when the sort button is pressed
              filterTaskList = _shortNotesByModifiedDate(filterTaskList);
            });
          },
          icon: Container(
            // padding: const EdgeInsets.all(10),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode
                  ? Colors.grey.shade800.withOpacity(.8)
                  : Colors.grey[300],
            ),
            child: Icon(
              shorted ? Icons.filter_alt : Icons.filter_alt_off_sharp,
              size: 26,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        PopupMenuButton<String>(
          offset: const Offset(0, 25),
          // color: Get.isDarkMode ? darkGreyColor : Colors.white,
          onSelected: (value) async {
            if (value == "Export to CSV") {
              // Export the taskList to CSV
              await exportTasksToCSV(filterTaskList);
            } else if (value == "Export to Excel") {
              // Export the taskList to Excel
              await exportTasksToExcel(filterTaskList);
            } else if (value == "Save as PDF") {
              // Export the taskList to PDF
              await exportTasksToPDF(filterTaskList);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "Export to CSV",
                child: Text("Export to CSV"),
              ),
              const PopupMenuItem(
                value: "Export to Excel",
                child: Text("Export to Excel"),
              ),
              const PopupMenuItem(
                value: "Save as PDF",
                child: Text("Save as PDF"),
              ),
            ];
          },
        ),
      ],
    );
  }

  _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          // New date selected

          setState(() {
            _selectedDate = date;
          });
        },
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: filterTaskList.length,
          itemBuilder: (_, index) {
            Task task = filterTaskList[index];

            // Schedule notification only if the task is not already scheduled
            print(task.remind);

            DateTime date = _parseDateTime(task.startTime.toString());
            var myTime = DateFormat.Hm().format(date);
            if (task.repeat == "Daily") {
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), //hour
                int.parse(myTime.toString().split(":")[1]), //minute
                task,
              );

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          onLongPress: () {
                            HapticFeedback.mediumImpact();
                            Get.to(
                              AddTaskPage(
                                task: task,
                              ),
                            );
                          },
                          child: TaskTile(
                            task,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.date ==
                DateFormat('MM/dd/yyyy').format(_selectedDate)) {
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]), //hour
                int.parse(myTime.toString().split(":")[1]), //minute
                task,
              );
              // Update the task to mark the notification as scheduled
              // _taskController.markNotificationAsScheduled(task.id!);

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(
                            task,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.repeat == "Weekly" &&
                DateFormat('EEEE').format(_selectedDate) ==
                    DateFormat('EEEE').format(DateTime.now())) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(
                            task,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (task.repeat == "Monthly" &&
                DateFormat('dd').format(_selectedDate) ==
                    DateFormat('dd').format(DateTime.now())) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(
                            task,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  DateTime _parseDateTime(String timeString) {
    // Split the timeString into components (hour, minute, period)
    List<String> components = timeString.split(' ');

    // Extract and parse the hour and minute
    List<String> timeComponents = components[0].split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Determine the period (AM or PM)
    String period = components[1];

    // Adjust hour for 12-hour format
    if (period.toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.28
            : MediaQuery.of(context).size.height * 0.35,
        color: Get.isDarkMode ? darkGreyColor : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          const Spacer(),
          _bottomSheetButton(
            label: " Update Task",
            color: Colors.green[400]!,
            onTap: () {
              Get.back();
              Get.to(AddTaskPage(
                task: task,
              ));
            },
            context: context,
            icon: Icons.update,
          ),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  color: primaryColor,
                  onTap: () {
                    Get.back();
                    _taskController.markTaskAsCompleted(task.id!);
                    _taskController.getTasks();
                  },
                  context: context,
                  icon: Icons.check,
                ),
          _bottomSheetButton(
            label: "Delete Task",
            color: Colors.red[400]!,
            onTap: () {
              Get.back();
              showDialog(
                  context: context,
                  builder: (_) => _alertDialogBox(context, task));
              // _taskController.deleteTask(task.id!);
            },
            context: context,
            icon: Icons.delete,
          ),
          const SizedBox(height: 15),
          _bottomSheetButton(
            label: "Close",
            color: Colors.red[400]!.withOpacity(0.5),
            isClose: true,
            onTap: () {
              Get.back();
            },
            context: context,
            icon: Icons.close,
          ),
        ]),
      ),
    );
  }

  _alertDialogBox(BuildContext context, Task task) {
    return AlertDialog(
      backgroundColor: context.theme.colorScheme.background,
      icon: const Icon(Icons.warning, color: Colors.red),
      title: const Text("Are you sure you want to delete?"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Get.back();
              _taskController.deleteTask(task.id!);
            },
            child: const SizedBox(
              width: 60,
              child: Text(
                "Yes",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Get.back();
            },
            child: const SizedBox(
              width: 60,
              child: Text(
                "No",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required BuildContext context,
      required Color color,
      required Function()? onTap,
      IconData? icon,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 7),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,

        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[700]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: isClose
                        ? Get.isDarkMode
                            ? Colors.white
                            : Colors.black
                        : Colors.white,
                    size: 30,
                  )
                : const SizedBox(),
            Text(
              label,
              style: titleStyle.copyWith(
                fontSize: 18,
                color: isClose
                    ? Get.isDarkMode
                        ? Colors.white
                        : Colors.black
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
