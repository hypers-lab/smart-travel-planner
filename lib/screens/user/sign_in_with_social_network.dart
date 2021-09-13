import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_in_with_google.dart';
import 'sign_in_with_apple.dart';

class SocialNetwork extends StatelessWidget {
  const SocialNetwork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.10,
      width: width - 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //google account button
          SizedBox(
            width: width * 0.40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white, elevation: 10),

              //On Pressed
              onPressed: () {
                signInWithGoogle(context);
                //print("User ${credential.user }");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/googleIcon.png'),
                    width: width * 0.12,
                    height: height * 0.07,
                  ),
                ],
              ),
            ),
          ),

          //Mac account button
          SizedBox(
            width: width * 0.40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white, elevation: 10),
              onPressed: signInWithApple,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/appleIcon.png'),
                    width: width * 0.12,
                    height: height * 0.07,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
