import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TileActivity extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool done;

  const TileActivity({
    super.key,
    required this.title,
    required this.done,
    this.subtitle,
  });

  @override
  State<TileActivity> createState() => _TileActivityState();
}

class _TileActivityState extends State<TileActivity> {
  late bool done;

  @override
  void initState() {
    super.initState();
    done = widget.done;
  }

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
      color: done ? Colors.green : Colors.red,
      margin: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0),
      child: ListTile(
        title: Center(
          child: AutoSizeText(
            widget.title,
            style: const TextStyle(fontSize: 24),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: widget.subtitle != null && widget.subtitle!.isNotEmpty
            ? Center(child: Text(widget.subtitle!))
            : null,
        onTap: () {
          setState(() {
            done = !done;
          });
        },
      ),
    );
  }
}
