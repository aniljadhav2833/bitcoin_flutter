import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  String selectedCurrency = 'INR';

  DropdownButton<String> dropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(
          item,
          style: TextStyle(color: Colors.white),
        ),
        value: item,
      ));
    }
    return DropdownButton(
      dropdownColor: Colors.black,
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker cupertinoPicker() {
    List<Text> listOfItems = [];
    for (String items in currenciesList) {
      listOfItems.add(Text(
        items,
        style: TextStyle(color: Colors.white),
      ));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: listOfItems,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedCurrency = currenciesList[value];
          getData();
        });
      },
      itemExtent: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                cryptoCurrency: 'BTC',
                //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data.
                value: isWaiting ? '?' : coinValues['BTC']!,
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                value: isWaiting ? '?' : coinValues['ETH']!,
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'LTC',
                value: isWaiting ? '?' : coinValues['LTC']!,
                selectedCurrency: selectedCurrency,
              )
            ],
          ),
          Container(
            height: 150,
            color: Colors.blue,
            child: Platform.isIOS ? cupertinoPicker() : dropdownButton(),
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30),
          )
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {super.key,
      required this.value,
      required this.cryptoCurrency,
      required this.selectedCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Card(
        elevation: 5,
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
