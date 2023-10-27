import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Apicaller {
  http.Client client = http.Client();
  List<String> currencies = [];
  var url;

  Apicaller();

  Apicaller.onAppStart() {
    getCurrencies().then((value) => currencies = value);
    Apicaller();
  }

  Future<List<String>> getCurrencies() async {
    var currenciesURL = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies.json');
    var response = await client.get(currenciesURL);
    var jsonResponse = convert.jsonDecode(response.body);
    var currencies = jsonResponse.toString().split(',');
    return currencies;
  }

  Future<double> getRate(String code1, String code2) async {
    var rateURL = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies/${code1.toLowerCase()}/${code2.toLowerCase()}.json');
    var response = await client.get(rateURL);
    var jsonResponse = convert.jsonDecode(response.body);
    var rate = jsonResponse['${code2.toLowerCase()}'];
    return rate;
  }
}
