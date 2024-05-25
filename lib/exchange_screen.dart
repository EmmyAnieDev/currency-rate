import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constant.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' show Platform;

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  final FocusNode _focusNode = FocusNode();
  String selectedCrypto = 'BTC';
  String selectedCurrency = 'USD';
  String enteredAmount = '';
  Map<String, String> cryptoRates = {}; // Store fetched rates
  Map<String, Map<String, String>> cryptoPrices = {};

  @override
  void initState() {
    super.initState();
    getData(); // Fetch initial data
  }

  // Future<void> getData() async {
  //   try {
  //     CoinData coinData = CoinData('$coinAPIURL?apikey=$apiKey');
  //     Map<String, Map<String, String>> data = await coinData.getCoinData();
  //     setState(() {
  //       cryptoRates = data[selectedCrypto] ?? {};
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  Future<void> getData() async {
    try {
      CoinData coinData = CoinData('$coinAPIURL?apikey=$apiKey');
      cryptoPrices = await coinData.getCoinData();

      setState(() {
        cryptoRates = cryptoPrices[selectedCrypto] ?? {};
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  CupertinoPicker iOSPickerCrypto() {
    List<Text> pickerItems = [];

    for (String crypto in cryptoList) {
      pickerItems.add(Text(crypto));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCrypto = cryptoList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> andriodDropdownCrypto() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String crypto in cryptoList) {
      var newItem = DropdownMenuItem(
        value: crypto,
        child: Text(crypto),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCrypto,
      items: dropdownItems,
      style: kTextStyle3,
      dropdownColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          selectedCrypto = value!;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.yellow,
      ),
    );
  }

  CupertinoPicker iOSPickerCurrency() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        // print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  DropdownButton<String> andriodDropdownCurrency() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      style: kTextStyle4,
      dropdownColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
    );
  }

  void updateAmount(String value) {
    setState(() {
      enteredAmount = value;
    });
  }

  String calculateConversion() {
    if (enteredAmount.isEmpty || cryptoRates.isEmpty) return '0';
    double amount = double.tryParse(enteredAmount) ?? 0;
    double rate = double.tryParse(cryptoRates[selectedCrypto] ?? '0') ?? 0;
    double result = amount * rate;
    return result.toStringAsFixed(2); // Update decimal places as needed
  }

  String calculateRateForUSDBTC() {
    if (cryptoPrices.containsKey('BTC') &&
        cryptoPrices['BTC']!.containsKey('USD')) {
      return cryptoPrices['BTC']!['USD']!;
    } else {
      return 'Rate not available';
    }
  }

  @override
  Widget build(BuildContext context) {
    String rateForUSDBTC = calculateRateForUSDBTC();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currency Exchange',
                  style: kTextStyle2,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: TextField(
                        cursorColor: Colors.white,
                        focusNode: _focusNode,
                        style: kTextStyle5,
                        textAlign: TextAlign.center,
                        onChanged: updateAmount, // Update entered amount
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: kTextFieldDecoration,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(selectedCrypto, style: kTextStyle1),
                  ],
                ),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Colors.yellow,
                  ),
                  child: Icon(
                    Icons.arrow_downward,
                    size: 30.sp,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      //enteredAmount.isEmpty ? '0' : calculateConversion(),
                      rateForUSDBTC,
                      style: kTextStyle2,
                    ),
                    Text(selectedCurrency, style: kTextStyle1)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Platform.isIOS
                          ? iOSPickerCrypto()
                          : andriodDropdownCrypto(),
                    ),
                    Container(
                      child: Platform.isIOS
                          ? iOSPickerCurrency()
                          : andriodDropdownCurrency(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
