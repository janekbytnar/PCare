import 'package:flutter/material.dart';
import 'package:perfect_childcare/components/my_text_field.dart';

class AddDialog extends StatefulWidget {
  final Function(String name, String? description) onAdd;
  const AddDialog({super.key, required this.onAdd});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget _activity() {
    return Column(
      children: [
        const Text(
          'Activity name',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 6),
        MyTextField(
          controller: nameController,
          hintText: '',
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Activity name can\'t be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 6),
        MyTextField(
          controller: descriptionController,
          hintText: '',
          obscureText: false,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 3,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Activity description can\'t be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _button() {
    return TextButton(
      onPressed: _submit,
      child: const Text(
        'Add',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(
          nameController.text.trim(), descriptionController.text.trim());
      const snackBar = SnackBar(
        content: Text('Activity added'),
        showCloseIcon: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }

  Widget _cancelButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text(
        'Cancel',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Add activity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 12),
              _activity(),
              const SizedBox(height: 12),
              _description(),
              const SizedBox(height: 12),
              Row(
                children: [
                  _cancelButton(),
                  const Spacer(),
                  _button(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
