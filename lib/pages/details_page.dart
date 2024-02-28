import 'package:card_project_ui/models/credit_card_model.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiredDateController = TextEditingController();


  String cardNumber = '0000 0000 0000 0000';
  String expiredDate = 'MM/YY';



  var cardNumberMaskFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var expiryDateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );



  void saveCreditCard(){
    setState(() {
      String cardNumber = cardNumberController.text;
      String expiredDate = expiredDateController.text;

      CreditCard creditCard = CreditCard(cardNumber: cardNumber, expiredDate: expiredDate);

      if(cardNumber.trim().isEmpty || cardNumber.length < 16){
        showToast('Enter valid card number');
        return ;
      }
      if(expiredDate.trim().isEmpty || expiredDate.length < 5){
        showToast('Enter valid date');
        return ;
      }


      if(cardNumber.startsWith('4')){
        creditCard.cardImage = 'assets/images/ic_card_visa.png';
        creditCard.cardType = 'visa';
      } else if(cardNumber.startsWith('5')){
        creditCard.cardImage = 'assets/images/ic_card_master.png';
        creditCard.cardType = 'master';
      } else {
        showToast("Enter only Visa and Master cards");
        return;
      }

      backToFinish(creditCard);
    });
  }

  void backToFinish(CreditCard creditCard){
    Navigator.of(context).pop(creditCard);
  }


  void showToast(String massage){
    Fluttertoast.showToast(
        msg: massage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  String getCardType(){
    if(cardNumber.isEmpty){
      return '';
    }
    if( cardNumber.startsWith('4') ){
      return 'VISA';
    } else if(cardNumber.startsWith('5')){
      return 'MASTER';
    }
    return '';
  }

  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    // enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  Future<void> scanCard() async {
    final CardDetails? cardDetails =
    await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted || cardDetails == null) return;
    setState(() {
      _cardDetails = cardDetails;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Card"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1005/555,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/im_card_bg.png'),
                            fit: BoxFit.cover,
                          )
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(getCardType(), style: TextStyle(color: Colors.white, fontSize: 22),)
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(cardNumber, style: TextStyle(color: Colors.white, fontSize: 25),),
                                  Text(expiredDate, style: TextStyle(color: Colors.white, fontSize: 20),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    child: TextField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                          hintText: "Card Number"),
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                        });
                      },
                      inputFormatters: [cardNumberMaskFormatter],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    child: TextField(
                      controller: expiredDateController,
                      decoration: InputDecoration(
                          hintText: "Expired Date"),
                      onChanged: (value) {
                        setState(() {
                          expiredDate = value;
                        });
                      },
                      inputFormatters: [expiryDateMaskFormatter],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: MaterialButton(
                onPressed: (){
                  saveCreditCard();
                },
                child: Text(
                  "Save Card",
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
}
