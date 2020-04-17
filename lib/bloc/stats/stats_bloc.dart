import 'dart:async';
import 'package:coronavision/models/location_details.dart';
import 'package:coronavision/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {


  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if(event is FetchStatsEvent) {
      yield* mapFetchStatsEventToState(event);
    }
  }

  Stream<StatsState> mapFetchStatsEventToState(FetchStatsEvent event) async* {
    try {
      yield ReloadingStatsState();

      LocationDetails currentDetails = (await CoronaVisionAPI.getCases(
        country: event.county,
        province: event.province,
        county: event.county,
        date: event.date
      ))[0];

      Map<DateTime, LocationDetails> history = await CoronaVisionAPI.getCasesHistory(
        country: event.county,
        province: event.province,
        county: event.county,
      );

      yield ChangedStatsState(currentDetails: currentDetails, history: history);
    } catch(error, trace) {
      print('$error $trace');
      yield ErrorStatsState(error.message ?? "An error occurred");
    }
  }

  @override
  StatsState get initialState => UnitStatsState();
}