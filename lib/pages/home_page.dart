

 import 'package:card_project_ui/models/credit_card_model.dart';
import 'package:card_project_ui/pages/details_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   const HomePage({super.key});

   @override
   State<HomePage> createState() => _HomePageState();
 }

 class _HomePageState extends State<HomePage> {

  List<CreditCard> cards = [
    CreditCard(
      cardNumber: '**** **** **** 0000',
      expiredDate: '12/22',
      cardType: 'visa',
      cardImage: 'assets/images/ic_card_visa.png',
    ),
    CreditCard(
      cardNumber: '**** **** **** 0000',
      expiredDate: '12/19',
      cardType: 'master',
      cardImage: 'assets/images/ic_card_master.png'),
  ];

   Future _openDetailsPage() async {
     CreditCard result = await Navigator.of(context).push(
       MaterialPageRoute(
         builder: (BuildContext context){
           return DetailsPage();
         }
       ),
     );

     setState(() {
       if(result != null){
         cards.add(result);
       }
     });
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.white,
         title: Text('My Cards'),
       ),
       body: Container(
         padding: EdgeInsets.all(20),
         child: Column(
           children: [
             Expanded(
               child: ListView.builder(
                 // padding: EdgeInsets.only(top: 30),
                 itemCount: cards.length,
                 itemBuilder: (ctx, i) {
                   return _itemOfCardList(cards[i]);
                 }
               ),
             ),
             Container(
               width: double.infinity,
               height: 45,
               decoration: BoxDecoration(
                 color: Colors.blue,
                 borderRadius: BorderRadius.circular(5)
               ),
               child: MaterialButton(
                 onPressed: (){
                   _openDetailsPage();
                 },
                 child: Text(
                   "Add Card",
                   style: TextStyle(
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

   Widget _itemOfCardList(CreditCard creditCard){
     return Container(
       margin: EdgeInsets.only(bottom: 15),
       height: 70,
       width: double.infinity,
       child: Row(
         children: [
           Container(
             margin: EdgeInsets.only(right: 15),
             child: Image(
               image: AssetImage(creditCard.cardImage!),
             ),
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(creditCard.cardNumber!,
                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               Text(
                 creditCard.expiredDate!,
                 style: TextStyle(
                   fontSize: 18, fontWeight: FontWeight.w500,
                 ),
               )
             ],
           )

         ],
       ),
     );
   }
 }
