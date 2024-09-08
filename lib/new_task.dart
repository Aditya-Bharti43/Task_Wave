import 'package:flutter/material.dart';

class NewTask extends StatelessWidget {
  final String sno;
  final String description;
  final String dateOfEvent;
  final String reminderDate;
  final VoidCallback onDelete;

  const NewTask(
      {super.key,
      required this.sno,
      required this.dateOfEvent,
      required this.description,
      required this.reminderDate,
      required this.onDelete
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(sno),
          Text(description),
          Text(dateOfEvent),
          Text(reminderDate),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}
