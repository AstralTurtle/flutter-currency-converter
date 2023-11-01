import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'conversion_rate.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController ddm1 = TextEditingController();
  final TextEditingController ddm2 = TextEditingController();

  double conversionRate = 1;
  String currency1 = "usd";
  String currency2 = "eur";

  Map<String, dynamic> currencies = {};
  List<DropdownMenuEntry<String>> currencyList = [];
  double result = 0;
  @override
  void initState() {
    Apicaller.onAppStart().then((value) {
      globals.api = value;
      globals.api!.getCurrencies().then((value) {
        setState(() {
          currencies = value;
          currencyList = currencies.keys
              .map((e) => DropdownMenuEntry<String>(
                    label: currencies[e],
                    value: e,
                  ))
              .toList();
        });
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Currency Converter'),
              backgroundColor: Colors.purple,
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter the amount to convert',
                          ),
                          controller: _controller,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: DropdownMenu<String>(
                            menuHeight: 200,
                            controller: ddm1,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            initialSelection: currency1,
                            dropdownMenuEntries: currencyList,
                            label: const Text('From'),
                            onSelected: (String? newValue) {
                              setState(() {
                                currency1 = newValue ??= 'usd';
                              });
                            }),
                      ),
                    ),
                    const Icon(Icons.arrow_downward),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: DropdownMenu<String>(
                            menuHeight: 200,
                            controller: ddm2,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            initialSelection: currency2,
                            dropdownMenuEntries: currencyList,
                            label: const Text('To'),
                            onSelected: (String? newValue) {
                              setState(() {
                                currency2 = newValue ??= 'usd';
                              });
                            }),
                      ),
                    ),
                    TextButton(
                        child: const Text('Convert'),
                        onPressed: () {
                          globals.api!
                              .getRate(currency1, currency2)
                              .then((value) {
                            setState(() {
                              conversionRate = value;
                              result = double.parse(_controller.text) *
                                  conversionRate;
                            });
                          });
                        }),
                    Text(
                      result.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 32),
                    )
                  ]),
            )));
  }
}
