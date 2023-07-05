import 'package:beautiful_land_2/LanguageDropdown.dart';
import 'package:beautiful_land_2/screens/calendar.dart';
import 'package:beautiful_land_2/LanguageDropdown.dart';
import 'package:beautiful_land_2/home.dart';
import 'package:beautiful_land_2/screens/calendar.dart';
import 'package:beautiful_land_2/screens/money.dart';
import 'package:beautiful_land_2/screens/weatherDisplay.dart';
import 'package:beautiful_land_2/screens/year_converter_screen.dart';
// import 'package:beautiful_land_2/screens/year_converter_screen.dart';
import 'package:flutter/material.dart';
import 'package:abushakir/abushakir.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautiful_land_2/blocs/blocs.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:beautiful_land_2/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/calendar/calendar_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales:const [Locale('en',"US"),Locale('am', 'ET')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en','US'),
      child:  MyApp(),
    ),
  );
}

const List<String> _weekdays = [
  "ሰ",
  "ማ",
  "ረ",
  "ሐ",
  "አ",
  "ቅ",
  "እ",
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfigu().init(constraints, orientation);
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Beautiful Land',
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<CalendarBloc>(
                    create: (BuildContext context) =>
                        CalendarBloc(currentMoment: ETC.today()),
                  ),
                ],
                child: MyHomePage(title: "A Land of Beauty and Wonder",),
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<_MyHomePageState> _pageKey = GlobalKey<_MyHomePageState>();
  EtDatetime a = new EtDatetime.now();
  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    CurrencyConverterScreen(),
    YearConverter(),
    weatherDisplay(),
    MyCalendar()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: RefreshIndicator(
        key: _pageKey,
        onRefresh: () async {
          setState(() {});
        },
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home,size: 30),
          Icon(Icons.monetization_on_outlined,size: 30),
          Icon(Icons.date_range,size: 30),
          Icon(Icons.cloud,size: 30),
          Icon(Icons.calendar_month,size: 30),
        ],
        color: HexColor('#90A955'),
        buttonBackgroundColor: Colors.white70,
        backgroundColor:HexColor('#31572C'),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
