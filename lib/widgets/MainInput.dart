import 'package:flutter/material.dart';
import 'package:book_store/constants/Size_of_screen.dart';

class MainInput extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final String? hintText;
  final Text? label;
  final String? obscure;
  final String? initialValue;
  final bool obscureText;
  final bool? enabled;

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  const MainInput({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.label,
    this.keyboardType,
    this.obscure,
    required this.obscureText,
    this.controller,
    this.hintText,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return TextFormField(
      enabled: enabled,
      onChanged: onChanged,
      autofocus: false,
      initialValue: initialValue,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscuringCharacter: '•',
      obscureText: obscureText,
      cursorColor: Colors.black54,
      decoration: InputDecoration(
          iconColor: Colors.green,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.green, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          label: label,
          labelStyle: const TextStyle(color: Colors.green),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.black54, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20))
          // ) RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(5),
          // )
          ),
    );
  }
}

class SecondaryInput extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final String? hintText;
  final Text? label;
  final String? obscure;
  final String? initialValue;
  final bool obscureText;

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  const SecondaryInput({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.label,
    this.keyboardType,
    this.obscure,
    required this.obscureText,
    this.controller,
    this.hintText,
    this.validator,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      onChanged: onChanged,
      //autofocus: true,
      textAlignVertical: const TextAlignVertical(y: 1),
      textInputAction: TextInputAction.send,
      initialValue: initialValue,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscuringCharacter: '•',
      obscureText: obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        iconColor: Colors.green,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
//         enabledBorder: UnderlineInputBorder(
//
//         ),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green, width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),

        // ) RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5),
        // )
      ),
    );
  }
}
