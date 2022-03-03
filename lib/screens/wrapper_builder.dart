import 'package:albify/models/firebase_user.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/services/auth_service.dart';
import 'package:albify/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const WrapperBuilder({
    Key? key,
    required this.builder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<FirebaseUser?>(
      stream: _authService.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser?> snapshot) {
        _authService.snapshot = snapshot;
        final FirebaseUser? _user = snapshot.data;

        if (_user != null) {
          return MultiProvider(
            providers: [
              Provider<DatabaseService>(
                create: (_) => DatabaseService(uid: _user.uid),
                builder: (context, child) => StreamProvider<UserModel?>.value(
                  lazy: false,
                  value: Provider.of<DatabaseService>(context, listen: false).userStream(),
                  initialData: null,
                  catchError: (_, err) {
                    // When user sings in anonymously
                    print(err);
                  },
                  child: builder(context)
                ),
              )
            ]
          );
        } else {
          return builder(context);
        }
      }
    );
  }
}