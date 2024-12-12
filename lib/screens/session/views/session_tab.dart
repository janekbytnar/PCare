import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:perfect_childcare/components/my_text_button.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:perfect_childcare/screens/session/blocs/activity_management_bloc/activity_management_bloc.dart';
import 'package:perfect_childcare/screens/session/blocs/meal_management_bloc/meal_management_bloc.dart';
import 'package:perfect_childcare/screens/session/blocs/nanny_management_bloc/nanny_connection_management_bloc.dart';
import 'package:perfect_childcare/screens/session/blocs/note_management_bloc/note_management_bloc.dart';
import 'package:perfect_childcare/screens/session/views/activity.dart';
import 'package:perfect_childcare/screens/session/views/meal.dart';
import 'package:perfect_childcare/screens/session/views/note.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

class SessionTabScreen extends StatefulWidget {
  final Session? session;
  const SessionTabScreen({super.key, this.session});

  @override
  State<SessionTabScreen> createState() => _SessionTabScreenState();
}

class _SessionTabScreenState extends State<SessionTabScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final _formKey = GlobalKey<FormState>();
  bool linked = false;
  final emailController = TextEditingController();
  late Color dynamicColor;

  Widget _addNannyButton() {
    return IconButton(
      onPressed: () {
        _showModalBottomSheet(context);
      },
      icon: const Icon(
        Icons.add,
        color: Colors.black,
        size: 26,
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  _emailField(),
                  const SizedBox(height: 12),
                  _linkButton(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emailField() {
    return MyTextField(
      obscureText: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(CupertinoIcons.mail_solid),
      hintText: 'Provide another person\'s email',
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please fill the field';
        } else if (!RegExp(r'^[\w=\.]+@([\w-]+\.)+[\w-]{2,3}$').hasMatch(val)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
  }

  Widget _linkButton() {
    return MyTextButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final nannyConnectionsBloc =
              context.read<NannyConnectionsManagementBloc>();
          final receiverEmail = emailController.text.trim();
          try {
            final user =
                await context.read<UserRepository>().getCurrentUserData();
            final userId = user?.userId;
            final senderEmail = user?.email;
            if (userId != null && senderEmail != null) {
              nannyConnectionsBloc.add(
                SendNannyConnectionRequest(
                  widget.session!,
                  userId,
                  senderEmail,
                  receiverEmail,
                ),
              );
              Navigator.of(context).pop();
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('User not logged in or data not available')),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          }
        }
      },
      text: 'Send request',
    );
  }

  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (context) => ActivityManagementBloc(
          sessionRepository: context.read<SessionRepository>(),
        )..add(LoadActivities(widget.session!.sessionId)),
        child: ActivityScreen(
          sessionId: widget.session!.sessionId,
          endDate: widget.session!.endDate,
        ),
      ),
      BlocProvider(
        create: (context) => MealManagementBloc(
          sessionRepository: context.read<SessionRepository>(),
        )..add(LoadMeals(widget.session!.sessionId)),
        child: MealScreen(
          sessionId: widget.session!.sessionId,
          endDate: widget.session!.endDate,
        ),
      ),
      BlocProvider(
        create: (context) => NoteManagementBloc(
          sessionRepository: context.read<SessionRepository>(),
        )..add(LoadNotes(widget.session!.sessionId)),
        child: NoteScreen(
          sessionId: widget.session!.sessionId,
          endDate: widget.session!.endDate,
        ),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.local_activity),
        title: ("Activities"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.rice_bowl),
        title: ("Meals"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.remove_red_eye),
        title: ("Notes"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  Widget _nannyInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.blueAccent, // Możesz zmienić kolor tła według potrzeb
      child: Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your nanny is ${widget.session!.nannyId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NannyConnectionsManagementBloc,
        NannyConnectionsManagementState>(
      listener: (context, state) {
        if (state is NannyConnectionRequestSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Childcare request sent!')),
          );
        } else if (state is NannyConnectionRequestAccepted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request accepted!')),
          );
          setState(() {
            linked = true;
          });
        } else if (state is NannyConnectionUnlinked) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unlinked successfully.')),
          );
          setState(() {
            linked = false;
          });
        } else if (state is NannyConnectionsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown, // scale the text to fit
                    child: Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(widget.session!.startDate),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${DateFormat('HH:mm').format(widget.session!.startDate)} - ${DateFormat('HH:mm').format(widget.session!.endDate)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              if (widget.session!.nannyId.isEmpty &&
                  widget.session!.startDate.isAfter(DateTime.now()))
                _addNannyButton()
            ],
          ),
          body: Column(children: [
            // Warunkowe wyświetlanie informacji o opiekunce
            if (widget.session!.nannyId.isNotEmpty) _nannyInformation(),
            Expanded(
              child: PersistentTabView(
                context,
                controller: _controller,
                screens: _buildScreens(),
                items: _navBarsItems(),
                confineInSafeArea: true,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surface, // Default is Colors.white.
                handleAndroidBackButtonPress: true, // Default is true.
                resizeToAvoidBottomInset:
                    true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                stateManagement: true, // Default is true.
                hideNavigationBarWhenKeyboardShows:
                    true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  colorBehindNavBar: Colors.white,
                ),
                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: const ItemAnimationProperties(
                  // Navigation Bar's items animation properties.
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: const ScreenTransitionAnimation(
                  // Screen transition animation on change of selected tab.
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle
                    .style1, // Choose the nav bar style with this property.
              ),
            ),
          ])),
    );
  }
}
