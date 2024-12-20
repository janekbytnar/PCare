import 'package:child_repository/child_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/components/my_text_button.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_bloc.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_event.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddChildScreen extends StatefulWidget {
  final Child? child;
  const AddChildScreen({super.key, this.child});

  @override
  // ignore: library_private_types_in_public_api
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? _selectedDate;
  DateTime currentDate = DateTime.now();
  String? _errorMsg;

  @override
  void initState() {
    super.initState();

    if (widget.child != null) {
      // We are in edit mode
      nameController.text = widget.child!.name;
      _selectedDate = widget.child!.dateOfBirth;
      dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  String _capitalizeName(String text) {
    if (text.isEmpty) {
      return text;
    }

    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  void _addChild() {
    if (_formKey.currentState!.validate()) {
      final childName = _capitalizeName(nameController.text.trim());

      final currentUserId = context.read<AuthenticationBloc>().state.user!.uid;

      final newChild = Child(
          id: UniqueKey().toString(),
          name: childName,
          parentIds: [currentUserId],
          dateOfBirth: _selectedDate!,
          sessionIds: const []);

      context.read<ChildrenManagementBloc>().add(AddChildEvent(
            newChild,
            currentUserId,
          ));
      Navigator.pop(context);
    }
  }

  void _updateChild() {
    if (_formKey.currentState!.validate()) {
      final childName = _capitalizeName(nameController.text.trim());

      final updatedChild = widget.child!.copyWith(
        name: childName,
        dateOfBirth: _selectedDate!,
      );

      context
          .read<ChildrenManagementBloc>()
          .add(UpdateChildEvent(updatedChild));

      Navigator.pop(context);
    }
  }

  void _deleteChild() {
    context
        .read<ChildrenManagementBloc>()
        .add(RemoveChildEvent(widget.child!.id));
    Navigator.pop(context);
  }

  Widget _nameField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: nameController,
        hintText: 'Child\'s Name',
        obscureText: false,
        keyboardType: TextInputType.name,
        prefixIcon: const Icon(CupertinoIcons.person),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill the field';
          }
          return null;
        },
      ),
    );
  }

  Widget _dateField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: dateController,
        hintText: 'Child\'s Date of Birth',
        obscureText: false,
        onTap: _dataPicker,
        readOnly: true,
        keyboardType: TextInputType.datetime,
        prefixIcon: const Icon(CupertinoIcons.calendar),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
      ),
    );
  }

  void _dataPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        currentDate.year - 18,
        currentDate.month,
        currentDate.day,
      ),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setState(() {
          _selectedDate = date;
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(_selectedDate!);
          dateController.text = formattedDate;
        });
      }
    });
  }

  Widget _submitButton() {
    return MyTextButton(
      onPressed: widget.child != null ? _updateChild : _addChild,
      text: widget.child != null ? 'Update Child' : 'Add Child',
    );
  }

  Widget _deleteButton() {
    return widget.child != null
        ? MyTextButton(
            onPressed: _deleteChild,
            text: 'Delete Child',
            backgroundColor: Colors.red,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Child'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _nameField(),
                const SizedBox(height: 20),
                _dateField(),
                const SizedBox(height: 20),
                _submitButton(),
                const SizedBox(height: 10),
                _deleteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
