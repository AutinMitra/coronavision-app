import 'package:coronavision/bloc/stats/stats_bloc.dart';
import 'package:coronavision/bloc/stats/stats_event.dart';
import 'package:coronavision/bloc/stats/stats_state.dart';
import 'package:coronavision/models/location_details.dart';
import 'package:coronavision/style/palette.dart';
import 'package:coronavision/style/text_styles.dart';
import 'package:coronavision/style/ui_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  static double margin = 24.0;

  void handleRefresh() {
    final StatsBloc statsBloc = BlocProvider.of<StatsBloc>(context);
    statsBloc.add(FetchStatsEvent());
  }

  Widget _statsBlock({@required color, @required title, @required num, dark: false}) {
    String number = num.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    
    return new Container(
      height: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (dark) ? Palette.bgDark : Palette.bgLight,
        borderRadius: BorderRadius.circular(32),
        boxShadow: UIValues.boxShadow
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyles.dataHeader),
            Text(number, style: TextStyles.dataNumber.copyWith(color: color))
          ],
        ),
      ),
    );
  }

  Widget _title({description = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("Stats", style: TextStyles.pageHeader),
        Text(description, style: TextStyles.pageSubHeader),
      ],
    );
  }

  Widget _casesOverview(LocationDetails details, {dark: false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _statsBlock(
                  color: Palette.red,
                  title: "Confirmed",
                  num: details.confirmed,
                  dark: dark
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _statsBlock(
                  color: Palette.orange,
                  title: "Active",
                  num: details.active,
                  dark: dark
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _statsBlock(
                  color: Palette.green,
                  title: "Recovered",
                  num: details.recovered,
                  dark: dark
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _statsBlock(
                  color: Palette.purple,
                  title: "Dead",
                  num: details.deaths,
                  dark: dark
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _reload({dark: false}) {
    return Center(
      child: GestureDetector(
        onTap: handleRefresh,
        child: Container(
          width: 92,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.0),
            color: Palette.navyBlue,
            boxShadow: UIValues.boxShadow
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(LineIcons.redo_alt_solid, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Center(child: Text("Reload", style: TextStyles.bodyBold.copyWith(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;

    final StatsBloc statsBloc = BlocProvider.of<StatsBloc>(context);

    Widget loadingReloadContent = Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          // TODO: Loading bar/animation
          Expanded(
            child: Center(
              child: Container(
                width: 158,
                height: 158,
                child: CircularProgressIndicator(
                  strokeWidth: 12,
                )
              ),
            ),
          )
        ],
      ),
    );

    return BlocBuilder<StatsBloc, StatsState>(builder: (context, state) {
      if(state is UnitStatsState) {
        statsBloc.add(FetchStatsEvent());
        return loadingReloadContent;
      } else if(state is ReloadingStatsState) {
        return loadingReloadContent;
      } else if(state is ChangedStatsState) {
        LocationDetails currentDetails = state.currentDetails;
        String location = "";
        if(currentDetails.county != "")
          location = "${currentDetails.county}, ${currentDetails.province}";
        else if(currentDetails.province != "")
          location = "${currentDetails.province}, ${currentDetails.country}";
        else if(currentDetails.country != "")
          location = "${currentDetails.country}";
        else
          location = "Worldwide";

        String subhead = "$location | ${DateFormat("yyyy-MM-dd").format(currentDetails.date)}";
        return ListView(
            physics: ClampingScrollPhysics(),
            addRepaintBoundaries: false,
            padding: EdgeInsets.all(margin),
            children: <Widget> [
              _title(description: subhead),
              SizedBox(height: 18),
              _casesOverview(state.currentDetails, dark: darkMode),
              SizedBox(height: 16),
              _reload(dark: darkMode)
            ]
        );
      }

      return Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(),
            // TODO: Custom icon
            Text("An error occured")
          ],
        ),
      );
    });
  }
}
