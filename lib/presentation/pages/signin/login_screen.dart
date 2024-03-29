import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:softwaretutorials/domain/models/models.dart';
import 'package:softwaretutorials/presentation/pages/signin/bloc/signin_bloc.dart';
import 'package:softwaretutorials/presentation/routes/bloc/navigation_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    BlocProvider.of<SigninBloc>(context).add(NormalEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _signinBloc = BlocProvider.of<SigninBloc>(context);
    final _navigationBloc = BlocProvider.of<NavigationBloc>(context); 
        return SafeArea(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/background.svg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 100,
                    left: MediaQuery.of(context).size.width / 2 - 64,
                    child: SvgPicture.asset("assets/images/brain.svg"),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 35, right: 35),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 450),
                                        child: TextFormField(
                                            controller: _usernameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 5) {
                                                return "Username is required and must be at least 5 characters";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                fillColor: Colors.grey.shade100,
                                                filled: true,
                                                hintText: "Username",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)))),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 450),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.length < 5) {
                                              return "Password is required and must be at least 8 characters";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              hintText: "Password",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          style: TextStyle(),
                                          obscureText: true,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(
                                          height: 50,
                                          width: 450,
                                          child: BlocBuilder<SigninBloc,
                                              SigninState>(
                                            builder: (context, state) {
                                              return ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed))
                                                        return Colors.blue;
                                                      return Colors
                                                          .teal; // Use the component's default.
                                                    },
                                                  ),
                                                ),
                                                child: BlocBuilder<SigninBloc,
                                                    SigninState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is SigninSuccess) {
                                                      _navigationBloc.add(
                                                          GotoAllTutorials());
                                                    }
                                                    if (state is Loading)
                                                      return Text(
                                                          "Logging in ...");
                                                    return const Text("Login");
                                                  },
                                                ),
                                                onPressed: state is! Loading
                                                    ? () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          _signinBloc.add(AttemptLoginEvent(
                                                              _usernameController
                                                                  .text,
                                                              _passwordController
                                                                  .text,
                                                              _navigationBloc));

                                                          // context
                                                          //     .go("/tutorials/all");

                                                        }
                                                      }
                                                    : null,
                                              );
                                            },
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Not registered yet?"),
                                            TextButton(
                                              child: Text("Create Account"),
                                              onPressed: () {
                                                //context.go("/signup");
                                                //_navigationBloc
                                                //    .add(GotoSignup());
												_navigationBloc.add(NavigationInitialEvent());
												//BlocProvider.of<NavigationBloc>(context).add(GotoSignup());
                                              },
                                            )
                                          ])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                ],
              )),
        );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
