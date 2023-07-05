import 'package:abushakir/abushakir.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class YearConverter extends StatefulWidget {
  @override
  _YearConverterState createState() => _YearConverterState();
}

class _YearConverterState extends State<YearConverter> {
  int selectedETDay = 1;
  int selectedETMonth = 1;
  int selectedETYear = 1990;

  int selectedGRDay = 1;
  int selectedGRMonth = 1;
  int selectedGRYear = 1990;

  List<int> DAYS = List<int>.generate(30, (index) => index + 1);
  List<String> ETMONTHS = [
    "መስከረም",
    "ጥቅምት",
    "ህዳር",
    "ታህሳስ",
    "ጥር",
    "የካቲት",
    "መጋቢት",
    "ሚያዝያ",
    "ግንቦት",
    "ሰኔ",
    "ሀምሌ",
    "ነሃሴ",
    "ጳጉሜ"
  ];
  List<String> gregorianMonth = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  List<int> YEARS = List<int>.generate(61, (index) => index + 1990);

  int convertedYear = 0;
  String convertedMonth = '';
  int convertedDay = 0;

  int convertedGregYear = 0;
  String convertedGregMonth = '';
  int convertedGregDay = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Converter'.tr()),
        backgroundColor: HexColor('#31572C'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "From Ethiopian to Gregorian".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: selectedETDay,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedETDay = newValue!;
                    });
                  },
                  items: DAYS.map<DropdownMenuItem<int>>(
                        (int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(width: 16.0),
                DropdownButton<int>(
                  value: selectedETMonth,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedETMonth = newValue!;
                    });
                  },
                  items: ETMONTHS.asMap().entries.map<DropdownMenuItem<int>>(
                        (entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key + 1,
                        child: Text(entry.value),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(width: 16.0),
                DropdownButton<int>(
                  value: selectedETYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedETYear = newValue!;
                    });
                  },
                  items: YEARS.map<DropdownMenuItem<int>>(
                        (int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Convert Ethiopian to Gregorian
                  final etConvert = EtDatetime(
                    year: selectedETYear,
                    month: selectedETMonth,
                    day: selectedETDay,
                  );
                  final gregorian =
                  DateTime.fromMillisecondsSinceEpoch(etConvert.moment);
                  convertedYear = gregorian.year;
                  convertedMonth = gregorianMonth[gregorian.month - 1];
                  convertedDay = gregorian.day;
                });
              },
              child: Text("Convert".tr()),
              style: ElevatedButton.styleFrom(
                primary: HexColor('#31572C'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: HexColor('#90A955'),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Text(
                "$convertedMonth - $convertedDay - $convertedYear",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              "From Gregorian to Ethiopian".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: selectedGRDay,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedGRDay = newValue!;
                    });
                  },
                  items: DAYS.map<DropdownMenuItem<int>>(
                        (int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(width: 16.0),
                DropdownButton<int>(
                  value: selectedGRMonth,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedGRMonth = newValue!;
                    });
                  },
                  items: gregorianMonth.asMap().entries.map<DropdownMenuItem<int>>(
                        (entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key + 1,
                        child: Text(entry.value),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(width: 16.0),
                DropdownButton<int>(
                  value: selectedGRYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedGRYear = newValue!;
                    });
                  },
                  items: YEARS.map<DropdownMenuItem<int>>(
                        (int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Convert Gregorian to Ethiopian
                  final gregorian = DateTime(
                    selectedGRYear,
                    selectedGRMonth,
                    selectedGRDay,
                  );
                  final ethiopian = EtDatetime.fromMillisecondsSinceEpoch(
                      gregorian.millisecondsSinceEpoch);
                  convertedGregYear = ethiopian.year;
                  convertedGregMonth = ETMONTHS[ethiopian.month - 1];
                  convertedGregDay = ethiopian.day + 1;
                });
              },
              child: Text("Convert".tr()),
              style: ElevatedButton.styleFrom(
                primary: HexColor('#31572C'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: HexColor('#90A955'),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Text(
                "$convertedGregMonth - $convertedGregDay - $convertedGregYear ዓ.ም",
                style: TextStyle(fontSize: 22.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double? _textMultiplier;
  static double? _widthMultiplier;
  static double? _heightMultiplier;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;

    _textMultiplier = blockSizeVertical;
    _widthMultiplier = blockSizeHorizontal;
    _heightMultiplier = blockSizeVertical;

    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! -
        _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! -
        _safeAreaVertical!) / 100;
  }

  static double? get textMultiplier => _textMultiplier;

  static double? get widthMultiplier => _widthMultiplier;

  static double? get heightMultiplier => _heightMultiplier;
}
