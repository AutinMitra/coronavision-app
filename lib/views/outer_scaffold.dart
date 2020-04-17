import 'package:coronavision/style/palette.dart';
import 'package:coronavision/style/text_styles.dart';
import 'package:coronavision/style/ui_values.dart';
import 'package:coronavision/views/health_page.dart';
import 'package:coronavision/views/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class OuterScaffold extends StatefulWidget {
  @override
  _OuterScaffoldState createState() => _OuterScaffoldState();
}

class _OuterScaffoldState extends State<OuterScaffold> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HealthPage(),
    StatsPage(),
    Text(
      'Index 3: Map',
      style: TextStyles.tabItem,
    ),
    Text(
      'Index 4: News',
      style: TextStyles.tabItem,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: (darkMode) ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Theme.of(context).backgroundColor
    ));

    return Scaffold(
      body: SafeArea(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: (darkMode) ? Palette.bgDark : Palette.bgLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: UIValues.boxShadow,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: (darkMode) ? Colors.black : Colors.white,
                color: (darkMode) ? Colors.white : Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 300),
                tabBackgroundColor: (darkMode) ? Palette.scLight : Palette.scDark,
                tabs: [
                  GButton(
                    icon: LineIcons.heart,
                    text: 'Health',
                  ),
                  GButton(
                    icon: LineIcons.chart_line_solid,
                    text: 'Stats',
                  ),
                  GButton(
                    icon: LineIcons.map,
                    text: 'Map',
                  ),
                  GButton(
                    icon: LineIcons.newspaper_solid,
                    text: 'News',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}