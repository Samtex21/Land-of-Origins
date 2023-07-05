import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:beautiful_land_2/services/currency_api_client.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;

  final String apiKey = 'CHjXAlPvmCyAwA3DYdVHRhuq3bxPVDpXWyp49QQq';

  CurrencyAPI currencyAPI = CurrencyAPI(
    apiKey: 'CHjXAlPvmCyAwA3DYdVHRhuq3bxPVDpXWyp49QQq',
    baseCurrency: 'USD',
  );
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _convertCurrency() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Circular progress indicator',
                  color: HexColor('#093A3E'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Converting... To $_toCurrency',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          );
        },
      );

      await Future.delayed(Duration(seconds: 1)); // Wait for 1 second

      final double amount = double.parse(_amountController.text);

      if (_toCurrency == 'ETB') {
        // Conversion to Ethiopian Birr (ETB)
        final double convertedAmount = amount * 54.35;
        setState(() {
          _result = convertedAmount;
        });
        Navigator.pop(context); // Close the progress dialog
      } else {
        // Conversion using API
        currencyAPI
            .convertCurrency(_fromCurrency, _toCurrency, amount)
            .then((value) {
          setState(() {
            _result = value;
          });
          Navigator.pop(context); // Close the progress dialog
        }).catchError((error) {
          setState(() {
            _result = 0.0;
          });
          Navigator.pop(context); // Close the progress dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Conversion Error'),
                content: Text('Failed to convert currency: $error'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'.tr()),
        backgroundColor: HexColor('#31572C'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Todays currency Exchange'.tr(),
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: HexColor('#90A955'),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _fromCurrency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _fromCurrency = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'USD',
                                    'EUR',
                                    'GBP',
                                    // Add more currencies as needed
                                  ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'From Currency'.tr(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _toCurrency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _toCurrency = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'USD',
                                    'EUR',
                                    'GBP',
                                    'ETB', // Add Ethiopian Birr (ETB)
                                    // Add more currencies as needed
                                  ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'To Currency'.tr(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount'.tr(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _convertCurrency,
                            child: Text('Convert'.tr()),
                            style: ElevatedButton.styleFrom(
                              primary: HexColor('#093A3E'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: HexColor('#90A955'),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Converted: $_result $_toCurrency',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
