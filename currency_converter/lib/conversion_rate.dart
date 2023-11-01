import 'package:currency_converter/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main(List<String> args) {
  var api;
  Apicaller.onAppStart().then((value) => api);
  print(api.currencies);
  var rate = api.getRate('USD', 'INR');
  rate.then((value) => print(value));
}

class Apicaller {
  http.Client client = http.Client();
  Map<String, dynamic> currencies = {};

  Apicaller();

  static Future<Apicaller> onAppStart() async {
    var api = Apicaller();
    api.setCurrencies(await api.getCurrencies());
    return api;
  }

  setCurrencies(Map<String, dynamic> currencies) {
    this.currencies = currencies;
  }

  Future<Map<String, dynamic>> getCurrencies() async {
    var currenciesURL = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies.json');
    var response = await client.get(currenciesURL);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    // var currencies = Map.castFrom(jsonResponse);
    return jsonResponse;
  }

  Future<double> getRate(String code1, String code2) async {
    var rateURL = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies/${code1.toLowerCase()}/${code2.toLowerCase()}.json');
    print(rateURL);
    var response = await client.get(rateURL);
    var jsonResponse = convert.jsonDecode(response.body);
    var rate = jsonResponse['${code2.toLowerCase()}'];
    return rate;
  }
}
