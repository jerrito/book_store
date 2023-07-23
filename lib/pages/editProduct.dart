import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_store/constants/strings.dart';
import 'package:book_store/databases/firebase_services.dart';
import 'package:book_store/userProvider.dart';
import 'package:book_store/widgets/MainButton.dart';
import 'package:book_store/widgets/MainInput.dart';
import 'package:book_store/widgets/snackbars.dart';
import 'package:provider/provider.dart';

import 'package:book_store/models/user.dart';

class EditBook extends StatefulWidget {
  final String bookName;
  final String description;
  final String picture;
  final String file;
  final String id;
  final String category;
  final double price;
  const EditBook({super.key, required this.bookName, 
    required this.description, required this.picture, 
    required this.price, required this.file, 
    required this.id, required this.category});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  CustomerProvider? customerProvider;
  BookProvider? productProvider;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isLoading=false;
  File? _image;
  String sizePath="";
  String extPath="";
  String filePath="";
  String booksName="";
  String description="";
  String file="";
  String category="";
  double price=0;
  String URL="";
  String imagePath="";
  String imageLocalPath="";
  bool fileGotten=false;
  bool network_or_file=true;
  Uint8List? fileByte;

  @override
  void initState(){
    super.initState();
    booksName=widget.bookName;
    imagePath =widget.picture;
    price =widget.price;
    description =widget.description;
    file=widget.file;
    filePath=widget.bookName;
    category=widget.category;
    customerProvider=context.read<CustomerProvider>();
    productProvider=context.read<BookProvider>();
    print(widget.id);
     print(customerProvider?.appUser?.fullName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:const Text("Edit Book"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Search for a specific food',
              onPressed: () {
                deleteBook(context);
              },
            ),

          ],
        ),
        body: Container(
          color: const Color.fromRGBO(245, 245, 245, 0.6),
          padding: const EdgeInsets.all(10),
          child:Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(children: [
                    const SizedBox(height: 30),
                  MainInput(
                    enabled: false,
                    validator: checkValidator,
                      initialValue: widget.bookName,
                      //hintText: "Product Name",
                      label: const Text("Edit Product Name"),
                      //controller: nameController,
                      obscureText: false,
                    onChanged: (value){
                      booksName=value;
                    },
                    ),
                    const SizedBox(height: 40),
                     MainInput(
                       validator: checkValidator,
                      initialValue: widget.description,
                      hintText: "Edit description here",
                      label: const Text("Description"),
                     // controller: amountController,
                      //keyboardType: TextInputType.number,
                      obscureText: false,
                       onChanged: (value){
                         description=value;
                       },
                    ),

                    const SizedBox(height: 40),
                    MainInput(
                      validator: checkValidator,
                      initialValue: widget.category,
                      //hintText: "Product Name",
                      label: const Text("Edit Category"),
                      //controller: nameController,
                      obscureText: false,
                      onChanged: (value){
                        category=value;
                      },
                    ),
                    const SizedBox(height: 40),
                    MainInput(
                      validator: checkValidator,
                      initialValue: widget.price.toString(),
                      hintText: "Edit price here",
                      label: const Text("Price"),
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      onChanged: (value){
                        price=double.parse(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Change Book"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // File("$filePath")
                        Text(filePath.length>=30?
                        "${filePath.substring(0,30)}...":filePath),
                        const Icon(Icons.book_outlined,color:Colors.red)
                      ],
                    ),
                    Visibility(
                      visible:fileGotten,
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // File("$filePath")
                          Text("$sizePath B"),
                          Text(extPath),
                        ],
                      ),

                    ),
                    const SizedBox(height:20),


                    const Text("Change Photo"),
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
                    Visibility(
                      visible:network_or_file,
                      replacement: Container(
                        margin: const EdgeInsets.only(left:50,right:50),
                        width: 200,height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: Image.file(File(imagePath),
                              fit: BoxFit.fitWidth,).image,
                          ),
                          //color: Colors.white70
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left:50,right:50),
                        width: 200,height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: Image.network(widget.picture,
                              fit: BoxFit.fitWidth,).image,
                          ),
                          //color: Colors.white70
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    const SizedBox(height: 7),


                    ]),
                  ),

           SizedBox(
             width:double.infinity,
             child: MainButton(
                onPressed:
                isLoading
                    ? null
                    :
                    () async {
                  setState(() {
                    isLoading = true;
                  });
                  uploadFile(product: productProvider?.typeOf);

                },
                backgroundColor: Colors.green,
                color: Colors.green,
                child: Visibility(
                    visible: !isLoading,
                    replacement: const CircularProgressIndicator(),
                    child: const Text("Submit")),
              ),
           ),
            const SizedBox(height:10),
              ],
            ),
          ),),
        );

  }
  Future<bool> deleteBook(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              //backgroundColor: Color.fromRGBO(217, 217, 217, 1),
              content: Container(
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.circular(10)),
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Are you sure you want to delete book?",
                      //  style:TextStyle(color:!iconThemeCheck?colors.)
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async{
                            await  FirebaseFirestore.instance.
                              collection('Books_Catalogue')
                                  .doc(customerProvider?.appUser?.id).
                              collection("Books")
                                  .doc(widget.id)
                                  .delete().whenComplete(() =>

                            Navigator.pushNamed(context,"home"));
                            },
                            child: const Text("Yes"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(240, 50, 50, 1),
                                foregroundColor: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop(true);
                                });
                              },
                              child:
                              const Text("No", style: TextStyle(color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                // shape: const OutlinedBorder(
                                //   side: BorderSide(color: Colors.blue,width: 2,style: BorderStyle.solid)
                                // )
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
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
        fileGotten=true;

      });
    } else {

      // User canceled the picker
    }
  }
  Future<String?> uploadFile({required Book? product}) async{
String? pName=product?.bookName;
String? describe=product?.description;
double? pricing=product?.price;
String? pic=product?.picture;
if(network_or_file==true){
  setState(() {
    pName=booksName;
    describe=description;
    pricing=price;
  });
  var prods=product;
  prods?.bookName=pName;
  prods?.description=describe;
  prods?.price=pricing;
  await updateUser(product: prods!);
}
else{
    File file = File(imagePath);
    final storageReference = FirebaseStorage.instance
        .ref(customerProvider?.appUser?.email)
        .child(imagePath);
    final uploadTask = storageReference.putFile(file);
    String? returnURL;
    await   uploadTask.whenComplete(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL)  async {
        returnURL = fileURL;
        setState(() {
          URL=fileURL;
          pName=booksName;
        describe=description;
        pricing=price;
        pic=imagePath;
        });
        var prods=product;
        prods?.bookName=pName;
        prods?.description=describe;
        prods?.picture=fileURL;
        prods?.price=pricing;
        await updateUser(product: prods!);
      });

      return URL;
    } );}
    return URL;

  }
  updateUser({required Book product}) async {
    var result=await productProvider?.updateProduct(product: product, id: customerProvider?.appUser?.id);
    if (result?.status == QueryStatuses.successful) {
      setState(() {
        isLoading = false;
      });
      PrimarySnackBar(context).displaySnackBar(
        message: "Product updated successfully",
        backgroundColor: Colors.green,
      );

      return;
    }
    if (result?.status == QueryStatuses.failed) {
      setState(() {
        isLoading = false;
      });
      PrimarySnackBar(context).displaySnackBar(
        message: "Error saving profile details",
        backgroundColor: Colors.red,
      );
    }
  }

  String? checkValidator(String? value) {
    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }
    return null;
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
              width: double.infinity,
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
          imagePath=pickedFile!.path;
          network_or_file=false;
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
          imagePath=pickedFile!.path;
          network_or_file=false;
        });
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DisplayPictureScreen(
        //     // Pass the automatically generated path to
        //     // the DisplayPictureScreen widget.
        //     imagePath: pickedFile!.path,
        //   ),
        // ));
      }
    });
  }
}
