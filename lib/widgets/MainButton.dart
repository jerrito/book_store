import 'package:flutter/material.dart';
import 'package:book_store/constants/Size_of_screen.dart';
import 'package:book_store/main.dart';

class MainButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color color;

  final Widget child;
  final void Function()? onPressed;

  const MainButton(
      {super.key,
      this.backgroundColor,
      this.foregroundColor,
      required this.child,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: SizedBox(
        width: w / 2.3,
        height: hS * 6.25,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              //padding: EdgeInsets.symmetric(vertical:0,horizontal:5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      width: 2, color: color, style: BorderStyle.solid))),
          child: child,
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color color;
  //final Widget child;
  final String text;
  final void Function()? onPressed;
  const SecondaryButton(
      {super.key,
      this.backgroundColor,
      this.foregroundColor,
      //required this.child,
      required this.onPressed,
      required this.color,
     required this.text});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: double.infinity,
      height: hS * 6.25,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            //padding: EdgeInsets.symmetric(vertical:0,horizontal:5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    width: 1, color: color, style: BorderStyle.solid))),
        child: Text(text,style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class IconLabelButton extends StatelessWidget {
  final Color backgroundColor;
  final Color? foregroundColor;
  final Color color;
  final Widget icon;
  final String label;
  final void Function()? onPressed;
  const IconLabelButton(
      {super.key,
      required this.backgroundColor,
      this.foregroundColor,
      required this.onPressed,
      required this.color,
      required this.icon,
      required this.label});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: hS * 5,
      width: wS * 55.56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            //padding: EdgeInsets.symmetric(vertical:0,horizontal:5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    width: 1,
                    color: backgroundColor,
                    style: BorderStyle.solid))),
        icon: icon,
        label: Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

class RawMaterialButtons extends StatelessWidget {
  final void Function()? onPressed;
  final String? string;
  final Color backgroundColor;
  final Color? foregroundColor;
  final Color color;
  final Widget icon;
  const RawMaterialButtons(
      {Key? key,
      this.onPressed,
      this.string,
      required this.backgroundColor,
      this.foregroundColor,
      required this.color,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Text('$string'),
    );
  }
}
