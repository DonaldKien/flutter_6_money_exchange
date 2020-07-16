import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'currency_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownButtonValue = 'USD';
  String currentSelected;
  String lastCurrencyValue = '?';
  String toCurrency = 'Currency';
  List<Widget> currencyCardList;
  bool isWaiting = false;

  void initState() {
    super.initState();
    startingCardLoop();
  }

  startingCardLoop() {
    currencyCardList = [];
    for (String currency in baseCurrenciesList) {
      var currencyCard = CurrencyCard(
          baseCurrency: currency,
          lastCurrencyValue: isWaiting == true ? 'Loading' : lastCurrencyValue,
          toCurrency: isWaiting == true ? '...' : toCurrency);
      currencyCardList.add(
        currencyCard,
      );
    }
    return currencyCardList;
  }

  androidPicker() {
    List<DropdownMenuItem<String>> dropDownList = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownList.add(newItem);
    }
    return DropdownButton<String>(
      value: dropDownButtonValue,
      items: dropDownList,
      onChanged: (selectedValue) {
        setState(() {
          dropDownButtonValue = selectedValue;
          currentSelected = selectedValue;
          loading();
          getApi();
        });
      },
    );
  }

  CupertinoPicker iOSPicket() {
    List<Text> allCupertinoPickerItem = [];
    for (String currency in currenciesList) {
      allCupertinoPickerItem.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedValue) async {
        currentSelected = currenciesList[selectedValue];
        isWaiting = true;
        loading();
        getApi();
      },
      children: allCupertinoPickerItem,
    );
  }

  loading() {
    currencyCardList = [];
    for (String currency in baseCurrenciesList) {
      var currencyCard = CurrencyCard(
        baseCurrency: currency,
        lastCurrencyValue: 'Loading',
        toCurrency: '...',
      );
      currencyCardList.add(currencyCard);
    }
    return currencyCardList;
  }

  CoinData coinData = CoinData();
  getApi() async {
    try {
      var decodedDataList = await coinData.getApiData(currentSelected);
      updateUI(decodedDataList);
    } catch (e) {
      print('Error found: $e');
    }
  }

  updateUI(dynamic apiDataList) {
    currencyCardList = [];
    setState(() {
      for (dynamic apiData in apiDataList) {
        var currencyCard = CurrencyCard(
          baseCurrency: apiData['query']['from'],
          lastCurrencyValue: apiData['info']['rate'].toStringAsFixed(3),
          toCurrency: apiData['query']['to'],
        );
        currencyCardList.add(currencyCard);
      }
    });
    return currencyCardList;
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
        children: <Widget>[
          Column(
            children: currencyCardList,
          ),
          Container(
            height: 150.0,
            color: Colors.lightBlue,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            child: Platform.isIOS ? iOSPicket() : androidPicker(),
          ),
        ],
      ),
    );
  }
}
