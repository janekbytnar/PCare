import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/components/my_button.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'dart:io';
import 'dart:core';

import 'package:user_repository/user_repository.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({
    super.key,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  late TextEditingController firstNameController;
  late TextEditingController surnameController;
  final _formKey = GlobalKey<FormState>();
  String newPhoto = '';
  bool loading = false;
  String error = '';
  MyUser? user;

  Future<void> _loadUserData() async {
    user = await context.read<UserRepository>().getCurrentUserData();
    if (user != null) {
      firstNameController = TextEditingController(text: user!.firstName);
      surnameController = TextEditingController(text: user!.surname);
      setState(() {}); // Trigger a rebuild with loaded data
    }
  }

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    surnameController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  Widget _photoButton() {
    return InkWell(
      onTap: () => _showModalBottomSheet(context),
      child: CircleAvatar(
          radius: 150,
          backgroundImage: newPhoto.isNotEmpty
              ? FileImage(File(newPhoto)) as ImageProvider<Object>
              : const AssetImage('assets/face.png')),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Add photo from gallery'),
              onTap: () async {
                final XFile? image = await _pickImage(ImageSource.gallery);
                if (image != null) {
                  final CroppedFile? croppedFile = await _cropImage(image.path);
                  if (croppedFile != null && mounted) {
                    setState(() {
                      newPhoto = croppedFile.path;

                      Navigator.pop(context);
                    });
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                final XFile? image = await _pickImage(ImageSource.camera);
                if (image != null) {
                  final CroppedFile? croppedFile = await _cropImage(image.path);
                  if (croppedFile != null && mounted) {
                    setState(() {
                      newPhoto = croppedFile.path;

                      Navigator.pop(context);
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    return await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
  }

  Future<CroppedFile?> _cropImage(String imagePath) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your photo',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop your photo',
          rectX: 1,
          rectY: 1,
        )
      ],
    );
  }

  Widget _firsNameField() {
    return MyTextField(
      obscureText: false,
      controller: firstNameController,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.person),
      hintText: 'Enter first name',
      validator: (value) => (value == null || value.isEmpty)
          ? 'Please provide your surname'
          : null,
    );
  }

  Widget _surnameField() {
    return MyTextField(
      obscureText: false,
      controller: surnameController,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.person),
      hintText: 'Enter surname',
      validator: (value) => (value == null || value.isEmpty)
          ? 'Please provide your surname'
          : null,
    );
  }

  Widget _button() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: MyTextButton(
        text: 'Update',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final updatedUser = user!.copyWith(
              firstName: firstNameController.text,
              surname: surnameController.text,
            );
            try {
              await context.read<UserRepository>().setUserData(updatedUser);

              if (!mounted) return; // Check if the widget is still mounted
              context
                  .read<AuthenticationBloc>()
                  .add(const AuthenticationUserDataChanged());
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: $e'),
                ));
              }
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal information'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _photoButton(),
              const SizedBox(height: 30),
              _firsNameField(),
              const SizedBox(height: 30),
              _surnameField(),
              const SizedBox(height: 30),
              _button(),
              Text(error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0)),
            ],
          ),
        ),
      )),
    );
  }
}
