import 'package:http/http.dart' as http;
import 'dart:convert';

const uri = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '';

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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoprice = {};
    for (String crypto in cryptoList) {
      String requestURL = '$uri/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var rateCoin = jsonDecode(response.body);
        double data = rateCoin['rate'];

        cryptoprice[crypto] = data.toStringAsFixed(2);
      } else {
        print(response.statusCode);
      }
    }
    return cryptoprice;
  }
}
