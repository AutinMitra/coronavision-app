import 'package:coronavision/style/theme.dart';
import 'package:flutter/material.dart';
import 'bloc/stats/stats_bloc.dart';
import 'views/outer_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(
    MultiBlocProvider(
      providers: <BlocProvider> [
        BlocProvider<StatsBloc>(create: (context) => StatsBloc()),
      ],
      child: CoronaVision(),
    )
  );
}

class CoronaVision extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoronaVision',
      theme: Themes.lightMode,
      darkTheme: Themes.darkMode,
      home: OuterScaffold(),
    );
  }
}


