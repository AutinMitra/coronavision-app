import 'package:coronavision/models/location_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class StatsState extends Equatable {
  final List _props;

  StatsState([this._props]) : super();

  @override
  List<Object> get props => _props;

  @override
  bool get stringify => true;
}

class UnitStatsState extends StatsState {}

class ReloadingStatsState extends StatsState {}

class ChangedStatsState extends StatsState {
  final Map<DateTime, LocationDetails> history;
  final LocationDetails currentDetails;
  final DateTime lastUpdated = DateTime.now();

  ChangedStatsState({@required this.history, @required this.currentDetails})
  : assert(history != null),
    assert(currentDetails != null);
}

class ErrorStatsState extends StatsState {
  final String error;

  ErrorStatsState(this.error);
}

