import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  CurrencyCard(
      {@required this.baseCurrency,
        @required this.lastCurrencyValue,
        @required this.toCurrency});
  final String baseCurrency;
  final String lastCurrencyValue;
  final String toCurrency;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          child: Text(
            '1 $baseCurrency = $lastCurrencyValue $toCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}