import 'package:flutter/material.dart';
import 'package:flutterfirebaselogin/src/blocs/register/ui/register_screen.dart';
import 'package:flutterfirebaselogin/src/repository/repository.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create an account'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterScreen(userRepository: _userRepository);
        }));
      },
    );
  }
}
