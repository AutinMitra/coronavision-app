import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// A model class for the details given per location
/// [date] the date in YYYY-MM-DD
/// The d{Confirmed, Dead, Recovered, Active} stands for delta
/// the rest is self-explanatory
class LocationDetails implements Equatable {
  final DateTime date;
  final String country, province, county;
  final int confirmed, deaths, recovered, active;
  final int dConfirmed, dDeaths, dRecovered, dActive;

  LocationDetails({
    Key key,
    @required this.date,
    @required this.country,
    this.province = "",
    this.county = "",
    @required this.confirmed,
    @required this.deaths,
    @required this.recovered,
    @required this.active,
    this.dConfirmed = 0,
    this.dDeaths = 0,
    this.dRecovered = 0,
    this.dActive = 0,
  }):
    assert(date != null),
    assert(country != null),
    assert(confirmed != null),
    assert(deaths != null),
    assert(recovered != null),
    assert(active != null);

  factory LocationDetails.fromJSON(Map<String, dynamic> json) {
    var date = DateTime.parse(json["entry_date"]);
    var country = json["country"];
    var province = json["province"];
    var county = json["admin2"];
    var confirmed = json["confirmed"];
    var deaths = json["deaths"];
    var recovered = json["recovered"];
    var active = json["active"];
    var dConfirmed = json["dconfirmed"];
    var dDeaths = json["ddeaths"];
    var dRecovered = json["drecovered"];
    var dActive = json["dactive"];

    return LocationDetails(
      date: date,
      country: country,
      province: province,
      county: county,
      confirmed: confirmed,
      deaths: deaths,
      recovered: recovered,
      active: active,
      dConfirmed: dConfirmed,
      dDeaths: dDeaths,
      dRecovered: dRecovered,
      dActive: dActive,
    );
  }

  @override
  List<Object> get props => [date, country, province, county, confirmed, deaths, recovered, active, dConfirmed, dDeaths, dRecovered, dActive];

  @override
  bool get stringify => true;
}

/// A GeoJSON class containing radius and location details
class GeoJSONDetails implements Equatable {
  final int radius, lat, lng;
  final String name;
  final LocationDetails locationDetails;

  GeoJSONDetails({@required this.radius, @required this.name, @required this.locationDetails, @required this.lat, @required this.lng});

  factory GeoJSONDetails.fromJSON(json) {
    return GeoJSONDetails(
      radius: json["radius"],
      lat: json["latitude"],
      lng: json["longitude"],
      name: json["name"],
      locationDetails: LocationDetails.fromJSON(json)
    );
  }

  @override
  List<Object> get props => [radius, lat, lng, name, locationDetails];

  @override
  bool get stringify => true;
}

