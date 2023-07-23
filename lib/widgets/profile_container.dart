import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:book_store/widgets/MainInput.dart';

class ProfileContainer extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final Key? keys;
  const ProfileContainer(
      {Key? key, required this.title, required this.onPressed, this.keys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keys,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 10),
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:(Theme.of(context)
            .brightness ==
            Brightness.dark
            ? Colors.white24
            : Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            IconButton(
              icon: const Icon(Icons.edit,color:Colors.green),
              onPressed: onPressed,
            )
          ],
        ));
  }
}
class DialogProfile extends StatelessWidget {
  const DialogProfile(
      {Key? key,
        this.initialValue,
        this.profileType,
        this.onPressed,
        this.onChanged,
        this.keys,
        this.validator})
      : super(key: key);
  final String? initialValue;
  final String? profileType;
  final void Function()? onPressed;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Key? keys;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: keys,
      child: SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.black54,
          children: [
            Text("Change your $profileType",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SecondaryInput(
              obscureText: false,
              initialValue: initialValue,
              onChanged: onChanged,
              validator: validator,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(onPressed: onPressed, child: const Text("Save"))
            ])
          ]),
    );
  }
}

class DialogLoading extends StatelessWidget {
  const DialogLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.black54,
        children: const [
          Center(
              child: SpinKitFadingCube(
                color: Colors.pink,
                size: 30.0,
              ))
        ]);
  }
}