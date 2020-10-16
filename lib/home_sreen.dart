import 'dart:convert';

import 'package:BitcoinZ/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

import 'coin_details.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrency = 'AUD';

  List<Widget> contents = [
    Container(),
    Container(),
    Container(),
  ];

  DropdownButton<String> getDropDownList() {
    return DropdownButton(
      value: selectedCurrency,
      underline: Container(
        height: 2.5,
        color: Colors.deepPurpleAccent.shade400,
      ),
      iconSize: 20.0,
      icon: Icon(
        Icons.arrow_downward,
      ),
      items: currenciesList
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              child: Text(
                value,
                style: kCurrencyTextStyle(),
              ),
              value: value,
            ),
          )
          .toList(),
      elevation: 16,
      onChanged: (String value) {
        setState(
          () {
            selectedCurrency = value;
            updateContents();
          },
        );
      },
    );
  }

  TextStyle kCurrencyTextStyle() {
    return TextStyle(
      fontSize: 20.0,
      color: Colors.grey.shade200,
    );
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      onSelectedItemChanged: (int selectedValue) {
        setState(() {
          selectedCurrency = currenciesList[selectedValue];
          updateContents();
        });
      },
      itemExtent: 20.0,
      children: currenciesList
          .map<Text>(
            (String value) => Text(
              value,
              style: kCurrencyTextStyle(),
            ),
          )
          .toList(),
      squeeze: 0.9,
      magnification: 1.4,
    );
  }

  Future<String> getConvertion(String currency) async {
    http.Response response = await http.get(
        'https://free.currconv.com/api/v7/convert?q=${currency}_$selectedCurrency&compact=ultra&apiKey=326e3bf6ea8f89cbf839');
    print(response.body);
    double convertionValue =
        await jsonDecode(response.body)['${currency}_$selectedCurrency'];
    return '$currency = $convertionValue $selectedCurrency';
  }

  void updateContents() async {
    for (int i = 0; i < cryptoList.length; i++) {
      contents[i] = ReusableCard(
        color: Colors.blueGrey,
        child: Text(
          await getConvertion(cryptoList[i]),
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    setState(() {
      contents = [...contents];
    });
  }

  @override
  void initState() {
    super.initState();
    updateContents();
  }

  @override
  Widget build(BuildContext context) {
    updateContents();
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Currency Rates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.purple.shade700,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...contents,
            ReusableCard(
              color: Colors.transparent,
              flex: 3,
            ),
            ReusableCard(
              color: Colors.blueGrey,
              child: Platform.isIOS ? getCupertinoPicker() : getDropDownList(),
            ),
          ],
        ),
      ),
    );
  }
}
