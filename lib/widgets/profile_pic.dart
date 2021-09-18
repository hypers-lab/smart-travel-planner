import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand, 
          clipBehavior: Clip.none, 
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLHvzyqlpe7Aw_qH5ZR5fvjErwjzNuqIlc6A&usqp=CAU')),
            Positioned(
                right: -16,
                bottom: 0,
                child: SizedBox(
                    height: 50,
                    width: 50,
                    child: buildEditIcon(
                      color: Colors.grey,
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                              ),
                              backgroundColor: Colors.grey[350],
                              elevation: 16,
                              child: Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(20),
                                        primary: Colors.grey[800],
                                      ),
                                      onPressed: (){
                                        
                                      }, 
                                      child: Text(
                                        'Choose from gallery',
                                        style: TextStyle(
                                          fontSize: 17
                                        ),)
                                    ),
                                    SizedBox(height: 5),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(20),
                                        primary: Colors.grey[800],
                                        
                                      ),
                                      onPressed: (){}, 
                                      child: Text(
                                        'Use your camera',
                                        style: TextStyle(
                                          fontSize: 17
                                        ),)
                                    ),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    ))
            )
          ]
        ));
    }

  Widget buildEditIcon({
    required Color color,
    required VoidCallback onPressed,
  })=>
      buildCircle(
        color: Colors.white,
        all: 1,
        child: buildCircle(
          color: color,
          all: 0.01,
          child: IconButton(
              splashColor: Colors.grey,
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onPressed
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          height: 30,
          width: 30,
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
