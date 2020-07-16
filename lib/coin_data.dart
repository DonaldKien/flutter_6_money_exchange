import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> baseCurrenciesList = [
  'USD',
  'SGD',
  'MYR',
];

class CoinData {
  Future getApiData(String selectedCurrency) async {
    List<dynamic> allDataReturn = [];

    for (String currency in baseCurrenciesList) {
      http.Response response = await http.get(
          'https://api.exchangerate.host/convert?from=$currency&to=$selectedCurrency');
      if (response.statusCode == 200) {
        var dataReturn = jsonDecode(response.body);
        allDataReturn.add(dataReturn);
      } else {
        print('Status Code: ${response.statusCode}');
        throw 'Problem with the get request';
      }
    }
    return allDataReturn;
  }
}
