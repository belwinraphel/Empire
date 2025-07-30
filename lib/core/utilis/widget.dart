import 'package:empire/core/utilis/fonts.dart';
import 'package:flutter/material.dart';

class SizedBox10 extends StatelessWidget {
  const SizedBox10({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}

class SizedBox20 extends StatelessWidget {
  const SizedBox20({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class SizedBox30 extends StatelessWidget {
  const SizedBox30({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
    );
  }
}

class GreenElevatedButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function() onTap;
  final double width;
  final double padding;
  final double height;
  const GreenElevatedButton(
      {super.key,
      this.padding = 0,
      this.width = 0.90,
      required this.text,
      this.height = .05,
      required this.onTap,
      this.color = const Color(0xFF4BB04F)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        height: 40,
        width: responsiveWidth(context, width),
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onPressed: onTap,
            label: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: Fonts.raleway),
            )),
      ),
    );
  }
}
