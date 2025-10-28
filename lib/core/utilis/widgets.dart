import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:empire/core/utilis/fonts.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SizedBox10 extends StatelessWidget {
  const SizedBox10({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}

class SizedBox20 extends StatelessWidget {
  const SizedBox20({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

class SizedBox30 extends StatelessWidget {
  const SizedBox30({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 30);
  }
}

class Titles extends StatelessWidget {
  final String? nametitle;
  const Titles({required this.nametitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      nametitle!,
      style: const TextStyle(
        fontSize: 17,
        fontFamily: Fonts.raleway,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Color? colors;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.colors = const Color.fromARGB(255, 229, 234, 236),
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: colors,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 30, color: Colors.black),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class GreenElevatedButton extends StatefulWidget {
  final Color color;
  final String text;
  final Function() onTap;
  final double width;
  final double height;
  final double padding;
  const GreenElevatedButton({
    super.key,
    this.width = 0.90,
    this.padding = 0,
    required this.text,
    this.height = .05,
    required this.onTap,
    this.color = const Color(0xFF4BB04F),
  });

  @override
  State<GreenElevatedButton> createState() => _GreenElevatedButtonState();
}

class _GreenElevatedButtonState extends State<GreenElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: SizedBox(
        height: 40,
        width: responsiveWidth(context, widget.width),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: widget.onTap,
          label: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: Fonts.raleway,
            ),
          ),
        ),
      ),
    );
  }
}

class Fields extends StatefulWidget {
  const Fields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    return InputField(
      controller: widget.controller,
      hintText: widget.hintText,
      validator: widget.validator,
    );
  }
}

Future<String?> uploadImageToCloudinary(File imageFile) async {
  final cloudName = 'dfpsfhmwu';
  final uploadPreset = 'category';

  final url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final res = await http.Response.fromStream(response);
    final data = jsonDecode(res.body);
    return data['secure_url'];
  } else {
    return null;
  }
}

class OptimizedNetworkImage extends StatelessWidget {
  final String? imageUrl;

  final double borderRadius;

  final BoxFit fit;

  final String widthQueryParam;
  final double height;
  final double width;

  final Widget? placeholder;

  final Widget? errorWidget;

  const OptimizedNetworkImage({
    super.key,
    this.height = 0,
    this.width = 0,
    required this.imageUrl,
    this.borderRadius = 0.0,
    this.fit = BoxFit.cover,
    this.widthQueryParam = 'w',
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pixelRatio = MediaQuery.devicePixelRatioOf(context);

        final int physicalWidth = (constraints.hasBoundedWidth)
            ? (constraints.maxWidth * pixelRatio).toInt()
            : 512;

        String finalImageUrl = '';
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          try {
            final uri = Uri.parse(imageUrl!);
            final newUri = uri.replace(queryParameters: {
              ...uri.queryParameters,
              widthQueryParam: physicalWidth.toString(),
            });
            finalImageUrl = newUri.toString();
          } catch (e) {
            print('OptimizedNetworkImage: Error parsing URL ($imageUrl): $e');
          }
        }

        Widget imageContent;
        if (finalImageUrl.isEmpty) {
          imageContent = errorWidget ??
              Container(
                color: Colors.grey[200],
                child:
                    const Icon(Icons.image_not_supported, color: Colors.grey),
              );
        } else {
          imageContent = CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: finalImageUrl,
            fit: fit,
            placeholder: (context, url) =>
                placeholder ??
                Container(
                  color: Colors.grey[200],
                ),
            errorWidget: (context, url, error) =>
                errorWidget ??
                Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
          );
        }

        if (borderRadius > 0) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageContent,
          );
        }

        return imageContent;
      },
    );
  }
}
