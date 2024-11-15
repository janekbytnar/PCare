import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? done;
  final VoidCallback? onToggleDone;
  final VoidCallback? onDelete;

  const CustomTile({
    super.key,
    required this.title,
    this.done = true,
    this.subtitle,
    this.onToggleDone,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      color: done! ? Colors.green : Colors.red,
      margin: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0),
      child: ListTile(
        title: Center(
          child: AutoSizeText(
            title,
            style: const TextStyle(fontSize: 24),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: subtitle != null && subtitle!.isNotEmpty
            ? Center(child: Text(subtitle!))
            : null,
        trailing: onDelete == null
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              )
            : null,
        onTap: onToggleDone,
      ),
    );
  }
}
