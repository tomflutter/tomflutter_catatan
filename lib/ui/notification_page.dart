import 'package:flutter/material.dart';

// Assuming you have a Notification model like this
class Notification {
  final String title;
  final String body;

  Notification({required this.title, required this.body});
}

class NotificationPage extends StatelessWidget {
  final List<Notification> notifications;

  NotificationPage({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notifications[index].title),
          subtitle: Text(notifications[index].body),
        );
      },
    );
  }
}
