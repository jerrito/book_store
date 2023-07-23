import 'package:book_store/pages/addProduct.dart';
import 'package:book_store/main.dart';
import 'package:book_store/widgets/bookList.dart';
import 'package:book_store/widgets/bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_store/constants/Size_of_screen.dart';
import 'package:book_store/widgets/drawer.dart';
import 'package:book_store/userProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

import 'package:book_store/pages/editProduct.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {




  CustomerProvider? customerProvider;
  BookProvider? productProvider;

  TextEditingController controller=TextEditingController();


  @override
  void initState(){
    super.initState();
    customerProvider=context.read<CustomerProvider>();
    productProvider =context.read<BookProvider>();

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: const Drawers(),
      bottomNavigationBar: BottomNavBar(idx:0),
      appBar: AppBar(
        //backgroundColor: Colors.green,
        title: const Text("Book Store"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search for a specific food',
            onPressed: () {
              showSearch(context: context,
                  delegate:
                 BookSearching());
            },
          ),

        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body:
      Container(
        color:const Color.fromRGBO(210, 210, 210, 0.2),

        padding: const EdgeInsets.only(left:10,),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getBooks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No books added yet"));
                    }
                    else
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //FlutterSpinkit
                      return const Center(child: CircularProgressIndicator());
                    }
            return GridView.builder(
              padding: const EdgeInsets.only(top: 10),
                    // physics: NeverScrollableScrollPhysics(),
                    //shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 30.0,
                      ),
                      itemBuilder:(BuildContext context ,index){
                                  var book = snapshot.data?.docs[index];
                                  print(snapshot.data?.docs[index].id);
                                  return  InkWell(
                                    onTap:()async{

                                      await productProvider?.getProduct(
                                          productName: book["productName"],
                                          id:customerProvider!.appUser!.id! );
                                      if(!context.mounted)return;
                                      productProvider=context.read<BookProvider>();

                                      if(!context.mounted)return;
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context){
                                                return EditBook(
                                                  bookName: book["productName"],
                                                  description:book["description"],
                                                  picture:book["picture"],
                                                  price:book["price"],
                                                  file:book["file"],
                                                  category:book["category"],
                                                  id: snapshot.data!.docs[index].id!,
                                                );}));

                                      },
                                    child: BookContainer(
                                        name:book!["productName"],
                                        price: book["price"].toString(),
                                        description: book["description"],
                                        image: book["picture"],
                                      color:Colors.white ),
                        );
                      });
          }
        ),
      ),
    );}

  List<Color> color=[
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow,

  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> getBooks(){
    final getData = FirebaseFirestore.instance
        .collection("Books_Catalogue")
        .doc(customerProvider?.appUser?.id).
    collection("Books")
        .snapshots();
    return getData;

  }}


class BookSearching extends SearchDelegate {
  CustomerProvider? customerProvider;
  BookProvider? productProvider;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(
              context,
               BookSearching(

              ));
        });
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    customerProvider=context.read<CustomerProvider>();
    productProvider=context.read<BookProvider>();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Books_Catalogue')
            .doc(customerProvider?.appUser?.id).
        collection("Books")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData) {
            final results =
            snapshot.data?.docs.where((book) => book['productName'].contains(query));

            var booksCount = snapshot.data?.docs.length;
           return ListView(
              children: results!.map<Widget>((book) => ListTile(
                onTap:()async{
                  await productProvider?.getProduct(
                  productName: book["productName"],
                  id:customerProvider!.appUser!.id! );
                  if(!context.mounted)return;
                  Navigator.push(context,
                  MaterialPageRoute(
                  builder: (BuildContext context){
                  return EditBook(
                  bookName: book["productName"],
                  description:book["description"],
                  picture:book["picture"],
                  price:book["price"],
                  file:book["file"],
                  category:book["category"],
                  id: '',
                  );}));
                },
                  leading: CircleAvatar(
                      backgroundImage:Image.network( book['picture'],).image),
                  title: Text(book["productName"]),
                  trailing:Text(book["price"].toString()))).toList(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: wS * 72.22,
                height: hS * 20.625,
                child: const Center(
                    child: SpinKitFadingCube(
                      color: Colors.pink,
                      size: 50.0,
                    )),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No results match your search",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          } else {
            return Center(
              child: SizedBox(
                width: wS * 72.22,
                height: hS * 20.625,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.pink,
                      size: 30,
                    ),
                    SizedBox(height: 30),
                    Text("Network error",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
        });
    //throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    customerProvider=context.read<CustomerProvider>();
    productProvider=context.read<BookProvider>();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection('Books_Catalogue')
            .doc(customerProvider?.appUser?.id).
        collection("Books")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final results =
            snapshot.data?.docs.where((book) => book['productName'].contains(query));
            var bookCount =  snapshot.data?.docs.length;
           return ListView(
              children: results!.map<Widget>((book) => ListTile(
                onTap: ()async{
                  await productProvider?.getProduct(
                  productName: book["productName"],
                  id:customerProvider!.appUser!.id! );
                  if(!context.mounted)return;
                  Navigator.push(context,
                  MaterialPageRoute(
                  builder: (BuildContext context){
                  return EditBook(
                  bookName: book["productName"],
                  description:book["description"],
                  picture:book["picture"],
                  price:book["price"],
                  file:book["file"],
                  category:book["category"],
                  id: '',
                  );}));
                },
                  leading: CircleAvatar(
                    backgroundImage:Image.network( book['picture'],).image),
              title: Text(book["productName"]),
              trailing:Text(book["price"].toString()))).toList(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: wS * 72.22,
                height: hS * 20.625,
                child: const Center(
                    child: SpinKitFadingCube(
                      color: Colors.pink,
                      size: 50.0,
                    )),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No results match your search",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          } else {
            return Center(
              child: SizedBox(
                width: wS * 72.22,
                height: hS * 20.625,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.pink,
                      size: 30,
                    ),
                    SizedBox(height: 30),
                    Text("Network error",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
        });
    throw UnimplementedError();
  }
}


