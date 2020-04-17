import 'package:flutter/material.dart';

@immutable
abstract class StatsEvent {}

class FetchStatsEvent extends StatsEvent {
  final String country, province, county, date;

  FetchStatsEvent({this.country = "", this.province = "", this.county = "", this.date});
}