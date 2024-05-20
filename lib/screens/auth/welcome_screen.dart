import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/register_bloc/register_bloc.dart';
import 'package:perfect_childcare/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:perfect_childcare/screens/auth/register_screen.dart';
import 'package:perfect_childcare/screens/auth/sing_in_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  Widget _tabButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TabBar(
        controller: tabController,
        tabs: [
          _tabButton('Sign in'),
          _tabButton('Register'),
        ],
      ),
    );
  }

  Widget _tabBarsViews() {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
            child: const SignInScreen(),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
            child: const RegisterScreen(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Column(
                    children: [
                      _tabs(),
                      _tabBarsViews(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
