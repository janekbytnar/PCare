import 'package:flutter/material.dart';

class NanniesScreen extends StatefulWidget {
  const NanniesScreen({super.key});

  @override
  State<NanniesScreen> createState() => _NanniesScreenState();
}

class _NanniesScreenState extends State<NanniesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Nannies'),
      ),
    );
  }
}
