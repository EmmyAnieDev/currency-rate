import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  'NGN',
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
  'BCH',
  'BTC',
  'ETH',
  'LTC',
  'SHIB',
  'SOL',
  'USDT',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'A08B11FD-EC4B-4125-BC1A-F2E0BDE8B2A1';

class CoinData {
  CoinData(this.url);
  final String url;

  // Future<Map<String, String>> getCoinData(String selectedCurrency) async {
  //   Map<String, String> cryptoPrices = {};
  //   for (String crypto in cryptoList) {
  //     String url = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
  //     http.Response response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       var decodedData = jsonDecode(response.body);
  //       var lastPrice =
  //           decodedData['rate']; // Assuming 'rate' is the key for the price
  //       cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
  //     } else {
  //       if (kDebugMode) {
  //         print(response.statusCode);
  //       }
  //       throw 'Problem with the get request';
  //     }
  //   }
  //   return cryptoPrices;
  // }
  Future<Map<String, Map<String, String>>> getCoinData() async {
    Map<String, Map<String, String>> cryptoPrices = {};

    for (String crypto in cryptoList) {
      Map<String, String> rates = {};

      for (String currency in currenciesList) {
        String url = '$coinAPIURL/$crypto/$currency?apikey=$apiKey';
        http.Response response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          var lastPrice = decodedData['rate'];

          rates[currency] = lastPrice.toStringAsFixed(0);
        } else {
          if (kDebugMode) {
            print(response.statusCode);
          }
          throw 'Problem with the get request';
        }
      }

      cryptoPrices[crypto] = rates;
    }

    return cryptoPrices;
  }
}
