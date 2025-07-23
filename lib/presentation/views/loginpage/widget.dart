// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:empire/core/utilis/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:empire/core/utilis/fonts.dart';

class LoginField extends StatelessWidget {
  const LoginField(
      {super.key,
      required this.issmallScreen,
      required this.maxwidth,
      required this.prefixican,
      required this.label,
      required this.validator,
      required this.controller,
      this.obscureText = false});

  final bool issmallScreen;
  final double maxwidth;
  final TextEditingController? controller;
  final IconData prefixican;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 60,
          maxWidth: issmallScreen ? maxwidth * 0.9 : 400,
          minWidth: issmallScreen ? maxwidth * 0.9 : 200),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                fontFamily: Fonts.raleway),
            filled: true,
            prefixIcon: Icon(
              color: Colors.black,
              prefixican,
              size: issmallScreen ? 28 : 30,
            ),
            fillColor: const Color.fromARGB(255, 229, 234, 236),
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline({
    super.key,
    required this.headlind,
  });
  final String headlind;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        headlind,
        style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: Fonts.ralewaySemibold,
            fontSize: 33),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.maxHeight,
  });

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight / 5,
      child: const Center(
        child: CircleAvatar(
          backgroundColor: ColoRs.fieldcolor,
          radius: 50,
          child: Icon(
            Icons.person,
            size: 80,
          ),
        ),
      ),
    );
  }
}


class Authbutton extends StatelessWidget {
  const Authbutton({
    super.key,
    required this.issmallScreen,
    required this.maxwidth,
    required this.formKey,
    required this.name,
    this.onPressed,
  });

  final bool issmallScreen;
  final double maxwidth;
  final GlobalKey<FormState> formKey;
  final String name;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: issmallScreen ? maxwidth * 0.8 : 400,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              backgroundColor: ColoRs.buttoncolor),
          onPressed: onPressed,
          child: Text(
            name,
            style: const TextStyle(
                fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600),
          )),
    );
  }
}

class Responsiveclass extends StatelessWidget {
  const Responsiveclass({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxwidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final issmallScreen = constraints.maxWidth < 600;
        return child;
      },
    );
  }
}
