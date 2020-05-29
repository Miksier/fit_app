import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

BoxDecoration raoundedDecoration(Color color, double radius,
        {Gradient gradient = null}) =>
    BoxDecoration(
        gradient: gradient,
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)));

var redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [Color(0xffffecf2), Color(0xffffd7e3)]);

var blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [Color(0xffeceffd), Color(0xffdce5ff)]);

class MonthData {
  String title;
  int pulse;
  int walking;
  int riding;
  int time;
  MonthData({this.pulse, this.riding, this.time, this.title, this.walking});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }

        // If device not support with locale to get language code then default get first on from the list
        return supportedLocales.first;
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August"
  ];
  final List<Tab> myTabs = List.generate(
    months.length,
    (index) => Tab(text: '${months[index]}'),
  );

  final List<MonthData> monthsData = List.generate(
    months.length,
    (index) => MonthData(
        title: months[index],
        pulse: Random().nextInt(100),
        riding: Random().nextInt(100),
        time: Random().nextInt(100),
        walking: Random().nextInt(100)),
  );
  int _currentMonthIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
            child: Text(
          "Fitness Tracker",
          style: TextStyle(color: Colors.black),
        )),
      ),
      drawer: Drawer(
        child: ListView(),
        elevation: 16,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TabBar(
              onTap: (value) {
                setState(() {
                  _currentMonthIndex = value;
                });
              },
              controller: _tabController,
              isScrollable: true,
              tabs: myTabs,
              labelColor: Colors.black,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.grey,
            ),
            Container(
              height: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Spacer(),
                  AanimatedChartColumn(
                      chartValue: monthsData[_currentMonthIndex].pulse,
                      color: Color.fromARGB(255, 254, 235, 242),
                      icon: Icons.healing,
                      textColor: Color(0xFFF60345)),
                  AanimatedChartColumn(
                    chartValue: monthsData[_currentMonthIndex].walking,
                    color: Color.fromARGB(255, 255, 247, 237),
                    icon: Icons.directions_walk,
                    textColor: Color(0xFFFF8E0D),
                  ),
                  AanimatedChartColumn(
                    chartValue: monthsData[_currentMonthIndex].riding,
                    color: Color.fromARGB(255, 241, 242, 255),
                    icon: Icons.shopping_cart,
                    textColor: Color(0xFF9356FF),
                  ),
                  AanimatedChartColumn(
                    chartValue: monthsData[_currentMonthIndex].time,
                    color: Color.fromARGB(255, 234, 241, 255),
                    icon: Icons.timer,
                    textColor: Color(0xFF1764FF),
                  ),
                  Spacer()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Top chart")),
            ),
            StatItem(
                value: monthsData[_currentMonthIndex].riding,
                backgroundColor: Color.fromARGB(255, 241, 242, 255),
                iconColor: Color(0xFF9356FF),
                icon: Icons.shopping_cart),
            StatItem(
                value: monthsData[_currentMonthIndex].walking,
                backgroundColor: Color.fromARGB(255, 255, 247, 237),
                iconColor: Color(0xFFFF8E0D),
                icon: Icons.directions_walk),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  StatCard(
                    backgroudnGradient: redGradient,
                    iconColor: Color(0xFFF60345),
                    icon: Icons.healing,
                    value: monthsData[_currentMonthIndex].pulse,
                    header: "Heart rate",
                    valueDescription: "bmp",
                  ),
                  StatCard(
                    backgroudnGradient: blueGradient,
                    iconColor: Color(0xFF1764FF),
                    icon: Icons.timer,
                    value: monthsData[_currentMonthIndex].time,
                    header: "Sleep rate",
                    valueDescription: "hrs/day",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    this.backgroudnGradient,
    this.valueDescription,
    this.header,
    this.icon,
    this.iconColor,
    this.value,
    Key key,
  }) : super(key: key);

  final int value;
  final String valueDescription;
  final String header;
  final Gradient backgroudnGradient;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 12),
      child: Container(
        height: 200,
        width: 300,
        decoration:
            raoundedDecoration(Colors.red, 15, gradient: backgroudnGradient),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(header,
                          style: TextStyle(
                              color: iconColor, fontWeight: FontWeight.bold)),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "$value ",
                          children: [
                            TextSpan(
                                text: valueDescription,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: iconColor,
                                    fontWeight: FontWeight.normal))
                          ],
                          style: TextStyle(
                              fontSize: 34,
                              color: iconColor,
                              fontWeight: FontWeight.bold)),
                    ),
                    Spacer(),
                    Text("monitor",
                        style: TextStyle(decoration: TextDecoration.underline))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  const StatItem(
      {Key key, this.value, this.backgroundColor, this.iconColor, this.icon})
      : super(key: key);

  final int value;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(const Radius.circular(15.0))),
              child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: iconColor,
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("riding"),
              Text(
                "${value} km",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Show stats",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class AanimatedChartColumn extends StatelessWidget {
  const AanimatedChartColumn(
      {Key key,
      @required this.chartValue,
      this.color,
      this.textColor,
      this.icon})
      : super(key: key);

  final int chartValue;
  final Color color;
  final Color textColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedContainer(
        height: 100.0 + chartValue,
        width: 40,
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(const Radius.circular(30.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                chartValue.toString(),
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              Icon(
                icon,
                color: textColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
