import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/my_button.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:perfect_childcare/screens/session/blocs/session_management_bloc/session_management_bloc.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

class AddSessionScreen extends StatefulWidget {
  final DateTime selectedDate;
  const AddSessionScreen({
    super.key,
    required this.selectedDate,
  });

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  late DateTime selectedDate;
  late UserRepository userRepository;
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  final timeControllerStart = TextEditingController();
  final timeControllerEnd = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;

    userRepository = context.read<UserRepository>();
  }

  Widget _timeFieldStart() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: timeControllerStart,
        hintText: 'Start time',
        obscureText: false,
        onTap: () => _timePicker(timeControllerStart, true),
        readOnly: true,
        keyboardType: TextInputType.datetime,
        prefixIcon: const Icon(CupertinoIcons.time),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select a start time';
          }
          return null;
        },
      ),
    );
  }

  Widget _timeFieldEnd() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: timeControllerEnd,
        hintText: 'Finish time',
        obscureText: false,
        onTap: () => _timePicker(timeControllerEnd, false),
        readOnly: true,
        keyboardType: TextInputType.datetime,
        prefixIcon: const Icon(CupertinoIcons.time),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select a finish time';
          }
          return null;
        },
      ),
    );
  }

  void _timePicker(
      TextEditingController timeController, bool isStartTime) async {
    TimeOfDay initialTime;

    if (isStartTime && _selectedStartTime != null) {
      initialTime = TimeOfDay.fromDateTime(_selectedStartTime!);
    } else if (!isStartTime && _selectedEndTime != null) {
      initialTime = TimeOfDay.fromDateTime(_selectedEndTime!);
    } else {
      initialTime = _getInitialTime();
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      int roundedMinute = (pickedTime.minute / 15).round() * 15;
      if (roundedMinute == 60) {
        roundedMinute = 0;
        pickedTime.replacing(hour: (pickedTime.hour + 1) % 24);
      }
      TimeOfDay finalTime = pickedTime.replacing(minute: roundedMinute);

      DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        finalTime.hour,
        finalTime.minute,
      );

      // Format and display the selected time
      if (isStartTime) {
        _selectedStartTime = selectedDateTime;
      } else {
        _selectedEndTime = selectedDateTime;
      }

      // ignore: use_build_context_synchronously
      timeController.text = finalTime.format(context);
    }
  }

  TimeOfDay _getInitialTime() {
    bool isToday = DateTime.now().year == selectedDate.year &&
        DateTime.now().month == selectedDate.month &&
        DateTime.now().day == selectedDate.day;
    DateTime now = DateTime.now();

    int remainder = (15 - now.minute % 15) % 15;
    DateTime roundedTime = now.add(Duration(minutes: remainder));

    return isToday
        ? TimeOfDay(hour: roundedTime.hour, minute: roundedTime.minute)
        : const TimeOfDay(hour: 12, minute: 0);
  }

  Widget _submitButton() {
    return MyTextButton(
      onPressed: _addSession,
      text: 'Add Session',
    );
  }

  void _addSession() {
    if (_formKey.currentState!.validate()) {
      final List<String> parentsId = [];
      final List<String> childsId = [];

      _prepareSession(
              parentsId, childsId, _selectedStartTime!, _selectedEndTime!)
          .then((newSession) {
        context.read<SessionManagementBloc>().add(AddSessionEvent(newSession));
      });
    }
  }

  Future<Session> _prepareSession(List<String> parentsId, List<String> childsId,
      DateTime startDate, DateTime endDate) async {
    final user = await userRepository.getCurrentUserData();
    if (user != null) {
      final currentUserId = user.userId;
      parentsId.add(currentUserId);
      if (user.linkedPerson.isNotEmpty) {
        parentsId.add(user.linkedPerson);
      }
      if (user.children.isNotEmpty) {
        childsId.addAll(user.children);
      }
    }

    return Session(
      sessionId: UniqueKey().toString(),
      parentsId: parentsId,
      startDate: startDate,
      endDate: endDate,
      childsId: childsId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Session'),
      ),
      body: BlocListener<SessionManagementBloc, SessionManagementState>(
        listener: (context, state) {
          if (state is SessionManagementFailure) {
            // Display the error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is SessionManagementSuccess) {
            // Optionally navigate back or show success message
            Navigator.pop(context, true);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Start Session:'),
                  const SizedBox(height: 20),
                  _timeFieldStart(),
                  const SizedBox(height: 20),
                  const Text('End Session:'),
                  const SizedBox(height: 20),
                  _timeFieldEnd(),
                  const SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timeControllerStart.dispose();
    timeControllerEnd.dispose();
    super.dispose();
  }
}
