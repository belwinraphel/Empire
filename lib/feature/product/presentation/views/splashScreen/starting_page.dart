import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/login_page.dart';
import 'package:empire/feature/product/presentation/views/myapp/my_app.dart';
import 'package:flutter/material.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          'assets/startingimage.png',
        ),
        fit: BoxFit.cover,
      )),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GreenElevatedButton(
              color: ColoRs.green,
              width: MediaQuery.of(context).size.width * 0.80,
              onTap: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return  Loginpage();
                }), (Route<dynamic> route) => false);
              },
              text: 'Get Started',
            )
          ],
        ),
      ),
    );
  }
}
