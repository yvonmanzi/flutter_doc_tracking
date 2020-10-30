import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfirebaselogin/src/blocs/login/blocs/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      icon: Icon(
        FontAwesomeIcons.google,
        color: Colors.white,
      ),
      onPressed: () {
        BlocProvider.of<LoginBloc>(context).add(LoginWithGooglePressed());
      },
      label: Text('Sign in with google',
          style: TextStyle(
            color: Colors.white,
          )),
      color: Colors.redAccent,
    );
  }
}
