import 'package:http/http.dart' as http;

void main(List<String> args) {
  Apicaller a = Apicaller();
  a.getCurrencies().then((value) => print(value));
}

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
    return response.body.split(',');
  }
}
