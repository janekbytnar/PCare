import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:perfect_childcare/screens/session/blocs/activity_management_bloc/activity_management_bloc.dart';

import 'package:perfect_childcare/screens/session/views/activity.dart';
import 'package:perfect_childcare/screens/session/views/meals.dart';
import 'package:perfect_childcare/screens/session/views/notes.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:session_repository/session_repository.dart';

class PersistentTabScreen extends StatefulWidget {
  final Session? session;
  const PersistentTabScreen({super.key, this.session});

  @override
  State<PersistentTabScreen> createState() => _PersistentTabScreenState();
}

class _PersistentTabScreenState extends State<PersistentTabScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  late Color dynamicColor;

  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (context) => ActivityManagementBloc(
          sessionRepository: context.read<SessionRepository>(),
        )..add(LoadActivities(widget.session!.sessionId)),
        child: ActivityScreen(
            activity: widget.session?.activities,
            sessionId: widget.session!.sessionId),
      ),
      const MealsScreen(),
      const NotesScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.local_activity),
        title: ("Activity"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end, // align to right
          children: [
            Row(
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(widget.session!.startDate),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(width: 10),
                Text(
                    '${DateFormat('HH:mm').format(widget.session!.startDate)} - ${DateFormat('HH:mm').format(widget.session!.endDate)}'),
              ],
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context)
            .colorScheme
            .background, // Default is Colors.white.
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
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
