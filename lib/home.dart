import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:softwaretutorials/infrastructure/repositories/local_repository/tutorial_local_repository.dart';
import 'package:softwaretutorials/infrastructure/repositories/local_repository/user_local_repository.dart';
import 'package:softwaretutorials/infrastructure/repositories/profile_service.dart';
import 'package:softwaretutorials/infrastructure/repositories/tutorial_service.dart';
import 'package:softwaretutorials/presentation/core/authentication/bloc/authentication_bloc.dart';
import 'package:softwaretutorials/presentation/pages/signin/bloc/signin_bloc.dart';
import 'package:softwaretutorials/presentation/routes/app_router.dart';
import 'package:softwaretutorials/presentation/routes/bloc/navigation_bloc.dart';
import 'presentation/core/theme_info.dart';

class Home extends StatelessWidget {
  Home({Key? key, this.sharedPreferences}) : super(key: key);
  late final NavigationBloc _navigationBloc;
  late final AuthenticationBloc _authenticationBloc;
  late final GoRouter _goRouter;
  late final SigninBloc _signinBloc;
  final sharedPreferences;

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = AuthenticationBloc(this.sharedPreferences);
    _authenticationBloc.add(AuthenticationInitialEvent());
    _navigationBloc = NavigationBloc(_authenticationBloc);
	_navigationBloc.add(NavigationInitialEvent());
    _signinBloc = SigninBloc(_authenticationBloc);
    _goRouter = TutorialGoRouter.get(_navigationBloc);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TutorialLocalRepository()),
        RepositoryProvider(create: (context) => UserLocalRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => TutorialRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => _authenticationBloc,
          ),
          BlocProvider<SigninBloc>(
            create: (context) => _signinBloc,
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(_authenticationBloc),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Ethio Software Tutorials',
          theme: lightTheme(),
          routeInformationParser: _goRouter.routeInformationParser,
          routerDelegate: _goRouter.routerDelegate,
        ),
      ),
    );
  }
}
