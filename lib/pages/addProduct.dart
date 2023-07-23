import 'dart:io';
import 'dart:typed_data';


import 'package:book_store/widgets/bottom.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_store/constants/Size_of_screen.dart';
import 'package:book_store/constants/strings.dart';
import 'package:book_store/databases/firebase_services.dart';
import 'package:book_store/models/user.dart';
import 'package:book_store/userProvider.dart';
import 'package:book_store/widgets/MainButton.dart';
import 'package:book_store/widgets/MainInput.dart';
import 'package:book_store/widgets/snackbars.dart';
import 'package:provider/provider.dart';


class AddBook extends StatefulWidget {

  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  File? _image;
   String? imagePath;
   Uint8List? fileByte;
   String sizePath="";
   String extPath="";
   String filePath="";
  String URL="";
  String documentUrl="";

  CustomerProvider? customerProvider;
  BookProvider? productProvider;
  TextEditingController bookNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
 bool isLoading=false;
 bool fileGotten=false;
GlobalKey<FormState> addProductForm=GlobalKey<FormState>();
 @override
  void initState(){
   super.initState();
   customerProvider=context.read<CustomerProvider>();
 }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        bottomNavigationBar: BottomNavBar(idx:1),
        appBar: AppBar(
        title:const Text("Add Book")
      ),
      body: Container(
        color: const Color.fromRGBO(245, 245, 245, 0.6),
        padding: const EdgeInsets.all(10),
        child:Form(
          key:addProductForm,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: ListView(children: [
    const SizedBox(height: 20),
    MainInput(
      validator: checkValidator,
    hintText: "Book Name",
    label: const Text("Add Book Name"),
    controller: bookNameController,
    obscureText: false,
    ),
    const SizedBox(height: 20),
    MainInput(
      validator: checkValidator,
    hintText: "Enter description here",
    label: const Text("Description"),
    controller: productDescriptionController,
    //keyboardType: TextInputType.number,
    obscureText: false,
    ),
      const SizedBox(height: 20),
      MainInput(
        validator: checkValidator,
        hintText: "Enter price here",
        label: const Text("Price"),
        controller: priceController,
        keyboardType: TextInputType.number,
        obscureText: false,
      ),
      const SizedBox(height: 20),
      MainInput(
        validator: checkValidator,
        hintText: "Enter Category here",
        label: const Text("Category"),
        controller: categoryController,
        //keyboardType: TextInputType.number,
        obscureText: false,
      ),
      const SizedBox(height: 20),
      const Text("Add Book"),
      InkWell(
        onTap:(){
          getBook();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: SvgPicture.asset(
              "./assets/svgs/book.svg",
              width: 70,height: 70,color: Colors.green,
            ),
          ),
        ),
      ),
      Visibility(
        visible:fileGotten,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           // File("$filePath")
            Text(filePath.length>=30?
            "${filePath.substring(0,30)}...":filePath),
            Icon(Icons.book_outlined,color:Colors.red)
          ],
        ),
      ),
      Visibility(
        visible:fileGotten,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // File("$filePath")
            Text("${sizePath} B"),
            Text(extPath),
          ],
        ),
        // ListTile(
        //   leading:Text(datePath.length>=30?
        //   "${datePath.substring(0,30)}...":datePath),
        //   title:Text(sizePath),
        //   trailing: Text(extPath),
        // ),
      ),
      SizedBox(height:20),
      const Text("Add Book Picture"),
    InkWell(
      onTap:(){
        uploadPic();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: SvgPicture.asset(
            "./assets/svgs/camera.svg",
            width: 70,height: 70,color: Colors.green,
          ),
        ),
      ),
    ),
      const SizedBox(height: 10),
    Container(
      margin: const EdgeInsets.only(left:50,right:50),
      width: 200,height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
           image: Image.file(File("$imagePath"),
             fit: BoxFit.fitWidth,).image,
          // onError: ("",StackTrace.current){
          //
          // }
          ),
        //color: Colors.white70
      ),
    ),


    //const SizedBox(height: 7),
    ]),
    ),
    SizedBox(
      width: double.infinity,
    child: MainButton(
      backgroundColor: Colors.green,
    onPressed:
    isLoading
    ? null
        :
    () async {
      if(addProductForm.currentState?.validate()==true ) {
        if (imagePath == null || filePath.isEmpty) {
          return PrimarySnackBar(context).displaySnackBar(
              message: "Please select the image and picture");
        }
        else {
          setState(() {
            isLoading = true;
          });
         await uploadFile();

        }
      }
    },
    color: Colors.green,
    child: Visibility(
    visible:!isLoading,
    replacement: const CircularProgressIndicator(),
    child: const Text("Submit")),
    ),
    ),
      const SizedBox(height: 10),
    ],
    ),
      ),
    ));
  }
  String? checkValidator(String? value) {
   if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }
    return null;
  }
  Future<String?> uploadFile() async{
   Uint8List fileB=fileByte!;
   // print(fileB.toString());
    File file = File(imagePath!);
   final storageMain= FirebaseStorage.instance.
    ref(customerProvider?.appUser?.email)
        .child("file")
        .child(filePath);
    final storageReference = FirebaseStorage.instance
        .ref(customerProvider?.appUser?.email)
        .child("image")
        .child(imagePath!);
    final upLoadBook=storageMain.putData(fileB);
    final uploadTask = storageReference.putFile(file);
    String? returnURL;
    await  upLoadBook.whenComplete(() =>
    uploadTask.whenComplete(() {
      // print('File Uploaded');
      storageMain.getDownloadURL().then((documentURL) async{

        storageReference.getDownloadURL().then((fileURL) async {
          returnURL = fileURL;
          setState(() {
            URL = fileURL;
          });
          var product = Book(
              bookName: bookNameController.text,
              description: productDescriptionController.text,
              id: productProvider?.typeOf?.id,
              picture: fileURL,
              price: double.parse(priceController.text),
              file :documentURL,
              category: categoryController.text

          );
          await ProductServices().saveUser(
              product: product, id: customerProvider?.appUser?.id)
              ?.whenComplete(() =>
          {
            setState(() {
              isLoading = false;
              imagePath = null;
              fileGotten=false;
            }),
            PrimarySnackBar(context).displaySnackBar(
                message: "Book uploaded"),
            bookNameController.clear(),
            productDescriptionController.clear(),
            priceController.clear(),
            categoryController.clear()
          });
        });
      });
      return URL;
    } ));
    return URL;
 }
  void uploadPic() {
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              width: SizeConfig.W,
              height: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width:double.infinity,height: 50,
                      child: IconLabelButton(
                          color: Colors.yellow,
                          backgroundColor: Colors.green,
                          icon: const Icon(Icons.camera_alt),
                          label: 'Camera',
                 onPressed:(){
                   Navigator.pop(context);
                   getCameraImage();
                   },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width:double.infinity,height: 50,
                      child: IconLabelButton(
                          onPressed:(){
                            Navigator.pop(context);
                            getFileImage();
                          },
                          color: Colors.yellow,
                        backgroundColor: Colors.yellow,
                        icon: const Icon(Icons.file_copy),
                        label: 'File Manager',),
                    ),
                  ]),
            );
          });
        });
  }
Future getBook() async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc'],
  );

  if (result != null) {
    PlatformFile file = result.files.single;
    Uint8List? fileBytes = result.files.single.bytes;
    print(fileBytes.toString());
    setState((){
    fileByte=file.bytes;
    print(fileBytes.toString());
    print(file.size.toString());
      filePath=file.name;

      sizePath=file.size.toString();
      extPath=file.extension!;
      // datePath=file.;
      fileGotten=true;

    });
  } else {

    // User canceled the picker
  }
}
  Future getCameraImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = (await picker.pickImage(
      source: ImageSource.camera,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path);
        setState(() {
          imagePath=pickedFile?.path;
        });
        // Use if you only need a single picture
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DisplayPictureScreen(
        //     // Pass the automatically generated path to
        //     // the DisplayPictureScreen widget.
        //     imagePath: pickedFile!.path,
        //   ),
        // ));
      } else {
        PrimarySnackBar(context).displaySnackBar(
            message: "No image selected");
      }
    });
  }

  Future getFileImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = (await picker.pickImage(
      source: ImageSource.gallery,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
        setState(() {
          imagePath=pickedFile?.path;
        });
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DisplayPictureScreen(
        //     // Pass the automatically generated path to
        //     // the DisplayPictureScreen widget.
        //     imagePath: pickedFile!.path,
        //   ),
        // ));
      }else{
        PrimarySnackBar(context).displaySnackBar(
            message: "No image selected");
      }
    });
  }
}
