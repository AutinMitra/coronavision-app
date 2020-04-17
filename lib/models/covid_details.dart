import 'package:flutter/material.dart';

class Symptom {
  final String name;
  final String description;
  final bool contactHelp;

  Symptom({@required this.name, @required this.description, this.contactHelp = false})
  : assert(name != null),
    assert(description != null);
}