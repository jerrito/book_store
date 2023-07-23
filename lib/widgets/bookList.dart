import 'package:flutter/material.dart';
class BookContainer extends StatelessWidget {
 final String name;
 final String description;
 final String price;
 final String image;
 final Color color;
  const BookContainer({super.key, required this.name,
   required this.description,required this.price,
    required this.image, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 150,
      child:  Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius:BorderRadius.circular(10) ,
        ),
        child: Column(

         // mainAxisSize: MainAxisSize.max,
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name.length>=25?
                "${name.substring(0,25)}...":name
                ,style: const TextStyle(
                fontSize: 18,fontWeight: FontWeight.bold
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(description,style: const TextStyle(
                  fontSize: 14,fontWeight: FontWeight.bold,
                  color:Colors.grey
                  ,),),
              ),
            ),
            Center(
              child: Text("GH₵ ${price}",style: const TextStyle(
                  fontSize: 14,fontWeight: FontWeight.bold,
                color:Colors.blue
              ,),),
            )

          ],
        ),
      ),
    );
  }
}
